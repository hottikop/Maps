//
//  ViewController.swift
//  Maps
//
//  Created by Максим Целигоров on 24.11.2023.
//

import UIKit
import SnapKit
import YandexMapsMobile
import CoreLocation

final class MapViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var btnPlus = ImageButtonView(
        image: Images.imageZoomPlus,
        target: self,
        action: #selector(btnPlus_touchUpInside)
    )
    
    private lazy var btnMinus = ImageButtonView(
        image: Images.imageZoomMinus,
        target: self,
        action: #selector(btnMinus_touchUpInside)
    )
    
    private lazy var btnLocation = ImageButtonView(
        image: Images.imageMyLocation,
        target: self,
        action: #selector(btnLocation_touchUpInside)
    )
    
    private lazy var btnNextTracker = ImageButtonView(
        image: Images.imageNextTracker,
        target: self,
        action: #selector(btnNextTracker_touchUpInside)
    )
    
    private lazy var vMap: YMKMapView = {
        let view = YMKMapView()
        view.mapWindow.map.mapType = .vectorMap
        view.mapWindow.map.addInputListener(with: self)
        view.mapWindow.map.setMapLoadedListenerWith(self)
        return view
    }()
    
    private lazy var vInfo: BottomSheetInfoView = {
        let view = BottomSheetInfoView()
        view.isHidden = true
        return view
    }()
    
    //MARK: - Properties
    
    private lazy var dateFormatter = DateFormatter()
    private let pinService: PinServiceProtocol
    private var pins = [PinModel]()
    
    private var currentLocation = Coordinate()
    private var selectedPinId = -1
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    //MARK: - Init
    
    init(pinService: PinServiceProtocol = PinService()) {
        self.pinService = pinService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        vMap.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        startLocationUpdate()
        
        setupUI()
        setupConstraints()
        createUserLocationLayer()
    }
    
    //MARK: - Methods
    
    private func createUserLocationLayer() {
        let mapKit = YMKMapKit.sharedInstance()
        let layer = mapKit.createUserLocationLayer(with: vMap.mapWindow)
        layer.setVisibleWithOn(true)
        layer.isHeadingEnabled = true
        layer.setObjectListenerWith(self)
    }
    
    private func startLocationUpdate() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func loadData() {
        pinService.getPins { [weak self] pins in
            self?.pins = pins
            self?.addPlacemarksToMap()
        }
    }

    private func setupUI() {
        view.addSubviews(
            vMap,
            btnPlus,
            btnMinus,
            btnLocation,
            btnNextTracker,
            vInfo
        )
    }
    
    private func setupConstraints() {
        btnPlus.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Paddings.huge)
            $0.trailing.equalToSuperview().inset(Paddings.small)
        }
        
        btnMinus.snp.makeConstraints {
            $0.top.equalTo(btnPlus.snp.bottom).offset(Paddings.medium)
            $0.trailing.equalToSuperview().inset(Paddings.small)
        }
        
        btnLocation.snp.makeConstraints {
            $0.top.equalTo(btnMinus.snp.bottom).offset(Paddings.medium)
            $0.trailing.equalToSuperview().inset(Paddings.small)
        }
        
        btnNextTracker.snp.makeConstraints {
            $0.top.equalTo(btnLocation.snp.bottom).offset(Paddings.medium)
            $0.trailing.equalToSuperview().inset(Paddings.small)
        }
        
        vInfo.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }

    private func addPlacemarksToMap() {
        for pin in pins {
            let placemark = vMap.mapWindow.map.mapObjects.addPlacemark()
            placemark.geometry = pin.coordinate.ymkPoint
            placemark.addTapListener(with: self)
            placemark.userData = pin.id
            guard
                let provider = YRTViewProvider(uiView: PinView(pin.image))
            else {
                continue
            }
            placemark.setViewWithView(provider)
        }
    }
    
    private func adjustZoom(_ deltaZoom: Double) {
        let currentZoom = vMap.mapWindow.map.cameraPosition.zoom
        vMap.mapWindow.map.move(
            with: YMKCameraPosition(
                target: vMap.mapWindow.map.cameraPosition.target,
                zoom: currentZoom + Float(deltaZoom),
                azimuth: 0,
                tilt: 0
            ),
            animation: YMKAnimation(type: .smooth, duration: 0.3),
            cameraCallback: nil
        )
    }
    
    private func moveCameraToPoint(_ point: YMKPoint) {
        let animation = YMKAnimation(
            type: .smooth,
            duration: 0.3
        )
        let position = YMKCameraPosition(
            target: point,
            zoom: 15,
            azimuth: 0,
            tilt: 0
        )
        vMap.mapWindow.map.move(
            with: position,
            animation: animation,
            cameraCallback: nil
        )
    }
    
    private func showBottomSheetInfo(for pin: PinModel) {
        dateFormatter.dateFormat = "dd.MM.yy"
        let date = dateFormatter.string(from: pin.date)
        
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: pin.date)
        
        vInfo.isHidden = false
        vInfo.configure(
            title: pin.name,
            image: pin.image,
            date: date,
            time: time
        )
    }

    //MARK: - Actions
    
    @objc private func btnPlus_touchUpInside(_ sender: UIButton) {
        adjustZoom(1)
    }

    @objc private func btnMinus_touchUpInside(_ sender: UIButton) {
        adjustZoom(-1)
    }
    
    @objc private func btnLocation_touchUpInside(_ sender: UIButton) {
        moveCameraToPoint(currentLocation.ymkPoint)
        vInfo.isHidden = true
        selectedPinId = -1
    }
    
    @objc private func btnNextTracker_touchUpInside(_ sender: UIButton) {
        selectedPinId += 1
        selectedPinId = selectedPinId > pins.count - 1 ? 0 : selectedPinId
        
        guard let pin = pins.first(where: { $0.id == selectedPinId }) else { return }
        showBottomSheetInfo(for: pin)
        moveCameraToPoint(pin.coordinate.ymkPoint)
    }
}

// MARK: - YMKMapObjectTapListener

extension MapViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard
            let id = mapObject.userData as? Int,
            let pin = pins.first(where: { $0.id == id})
        else {
            return false
        }
        showBottomSheetInfo(for: pin)
        selectedPinId = pin.id
        
        return true
    }
}

// MARK: - YMKMapInputListener

extension MapViewController: YMKMapInputListener {
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        vInfo.isHidden = true
        selectedPinId = -1
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) { }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        currentLocation.longitude = location.coordinate.longitude
        currentLocation.latitude = location.coordinate.latitude
    }
}

//MARK: - YMKUserLocationObjectListener

extension MapViewController: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {
        guard let image = Images.imageMyLocation else { return }
        
        view.accuracyCircle.fillColor = .clear
        let style = YMKIconStyle()
        style.scale = 0.5
        view.arrow.setIconWith(image, style: style)
        
        view.pin.setIconWith(image, style: style)
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) { }
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) { }
}

// MARK: - YMKMapLoadedListener

extension MapViewController: YMKMapLoadedListener {
    func onMapLoaded(with statistics: YMKMapLoadStatistics) {
        moveCameraToPoint(currentLocation.ymkPoint)
    }
}
