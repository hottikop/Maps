//
//  RoundedButtonView.swift
//  Maps
//
//  Created by Максим Целигоров on 25.11.2023.
//

import UIKit
import SnapKit

final class RoundedButtonView: UIButton {
    
    //MARK: - Subviews
    
    private lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var vInner: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.masksToBounds = true
        return view
    }()
    
    //MARK: - Init
    
    init(title: String?, target: Any?, action: Selector) {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        
        lblTitle.text = title
        addTargetTouch(target, action: action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        vInner.layer.cornerRadius = bounds.height / 2
    }
    
    // MARK: - Methods
    
    private func setupUI() {
        addSubview(vInner)
        vInner.addSubview(lblTitle)
    }
    
    private func setupConstraints() {
        vInner.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        lblTitle.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(Paddings.small)
            $0.horizontalEdges.equalToSuperview().inset(Paddings.medium)
        }
    }
    
}
