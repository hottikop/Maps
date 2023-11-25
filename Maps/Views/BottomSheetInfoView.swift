//
//  BottomSheetInfoView.swift
//  Maps
//
//  Created by Максим Целигоров on 25.11.2023.
//

import UIKit
import SnapKit

final class BottomSheetInfoView: UIView {
    
    // MARK: - Subviews
    
    enum LocalConstants {
        static let lblTitleFontSize: CGFloat = 17
        static let ivIconSize: CGFloat = 55
        static let borderWidth: CGFloat = 2
        
        static let shadowRadius: CGFloat = 4
        static let shadowHeight: CGFloat = 2
        static let shadowOpacity: Float = 0.5
        
        static let btnHistoryTitle = "Посмотреть историю"
    }
    
    private lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: LocalConstants.lblTitleFontSize)
        return lbl
    }()
    
    private lazy var lblGPS: UILabel = {
        let lbl = UILabel()
        lbl.text = "GPS"
        return lbl
    }()
    
    private lazy var lblDate = UILabel()
    private lazy var lblTime = UILabel()
    
    private lazy var ivIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = LocalConstants.borderWidth
        iv.layer.borderColor = UIColor.blue.cgColor
        iv.layer.cornerRadius = LocalConstants.ivIconSize / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private lazy var btnHistory = RoundedButtonView(
        title: LocalConstants.btnHistoryTitle,
        target: self,
        action: #selector(btnHistory_touchUpInside)
    )
    
    private lazy var ivWifi = UIImageView(image: UIImage(systemName: "wifi"))
    private lazy var ivCalendar = UIImageView(image: UIImage(systemName: "calendar"))
    private lazy var ivClock = UIImageView(image: UIImage(systemName: "clock"))
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(
        title: String?,
        image: UIImage?,
        date: String?,
        time: String?
    ) {
        lblTitle.text = title
        lblDate.text = date
        lblTime.text = time
        ivIcon.image = image
    }
    
    private func setupUI() {
        addSubviews(
            lblTime, lblGPS, lblDate, lblTitle,
            ivIcon, ivWifi, ivClock, ivCalendar,
            btnHistory
        )
        backgroundColor = .white
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = LocalConstants.shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: LocalConstants.shadowHeight)
        layer.shadowRadius = LocalConstants.shadowRadius
        layer.masksToBounds = false
    }
    
    private func setupConstraints() {
        ivIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Paddings.large)
            $0.leading.equalToSuperview().inset(Paddings.large)
            $0.size.equalTo(LocalConstants.ivIconSize)
        }
        lblTitle.snp.makeConstraints {
            $0.bottom.equalTo(lblGPS.snp.top).offset(-Paddings.small)
            $0.leading.equalTo(ivIcon.snp.trailing).offset(Paddings.medium)
        }
        
        ivWifi.snp.makeConstraints {
            $0.centerY.equalTo(ivIcon)
            $0.leading.equalTo(ivIcon.snp.trailing).offset(Paddings.medium)
        }
        lblGPS.snp.makeConstraints {
            $0.centerY.equalTo(ivIcon)
            $0.leading.equalTo(ivWifi.snp.trailing).offset(Paddings.micro)
        }
        
        ivCalendar.snp.makeConstraints {
            $0.centerY.equalTo(ivIcon)
            $0.leading.equalTo(lblGPS.snp.trailing).offset(Paddings.small)
        }
        lblDate.snp.makeConstraints {
            $0.centerY.equalTo(ivIcon)
            $0.leading.equalTo(ivCalendar.snp.trailing).offset(Paddings.micro)
        }
        
        ivClock.snp.makeConstraints {
            $0.centerY.equalTo(ivIcon)
            $0.leading.equalTo(lblDate.snp.trailing).offset(Paddings.small)
        }
        lblTime.snp.makeConstraints {
            $0.centerY.equalTo(ivIcon)
            $0.leading.equalTo(ivClock.snp.trailing).offset(Paddings.micro)
        }
        
        btnHistory.snp.makeConstraints {
            $0.top.equalTo(lblTime.snp.bottom).inset(-Paddings.medium)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(Paddings.large)
        }
    }
    
    // MARK: - Actions
    
    @objc private func btnHistory_touchUpInside(_ sender: UIButton) {
        
    }
}
