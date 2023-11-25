//
//  PinView.swift
//  Maps
//
//  Created by Максим Целигоров on 25.11.2023.
//

import UIKit
import SnapKit

final class PinView: UIView {
    
    // MARK: - Constants
    
    enum LocalConstants {
        static let trackerSize: CGFloat = 55
        static let iconSize: CGFloat = 40
        static let topPadding: CGFloat = 4
    }
    
    // MARK: - Subviews
    
    private lazy var ivTracker: UIImageView = {
        let frame = CGRect(
            x: 0,
            y: 0,
            width: LocalConstants.trackerSize,
            height: LocalConstants.trackerSize
        )
        let iv = UIImageView(frame: frame)
        iv.image = Images.imageTracker
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var ivIcon: UIImageView = {
        let frame = CGRect(
            x: LocalConstants.trackerSize / 2 - LocalConstants.iconSize / 2,
            y: LocalConstants.topPadding,
            width: LocalConstants.iconSize,
            height: LocalConstants.iconSize
        )
        let iv = UIImageView(frame: frame)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = LocalConstants.iconSize / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    // MARK: - Init
    
    init(_ image: UIImage?) {
        let frame = CGRect(
            x: 0,
            y: 0,
            width: LocalConstants.trackerSize,
            height: LocalConstants.trackerSize
        )
        super.init(frame: frame)
        
        setupUI()
        ivIcon.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        addSubviews(ivTracker, ivIcon)
        isOpaque = false
        backgroundColor = .clear.withAlphaComponent(0.0)
    }
}
