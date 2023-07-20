//
//  BaseTableViewCell.swift
//  RYTransitioningDelegateSwift_Example
//
//  Created by SSR on 2023/7/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    static let identifier = "RYTransitioningDelegateSwift_Example.BaseTableViewCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLab: UILabel = {
        let lab = UILabel(frame: contentView.bounds)
        lab.textAlignment = .center
        lab.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return lab
    }()
}
