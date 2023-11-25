//
//  ImageButtonView.swift
//  Maps
//
//  Created by Максим Целигоров on 24.11.2023.
//

import UIKit
import SnapKit

final class ImageButtonView: UIButton {
    
    // MARK: - Constants
    
    enum LocalConstants {
        static let imageButtonSize = 48
    }
    
    //MARK: - Subviews
    
    private lazy var imageButton = UIImageView()
    
    //MARK: - Init
    
    init(image: UIImage?, target: Any?, action: Selector) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        
        imageButton.image = image
        addTargetTouch(target, action: action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        addSubview(imageButton)
    }
    
    private func setupConstraints() {
        imageButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(LocalConstants.imageButtonSize)
        }
    }
}
