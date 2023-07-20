//
//  FullViewController.swift
//  RYTransitioningDelegateSwift_Example
//
//  Created by SSR on 2023/7/20.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

@objc protocol FullViewControllerDelegate {
    @objc optional
    func viewController(_ viewController: FullViewController, touchUpInside button: UIButton) -> Void
}

class FullViewController: UIViewController {
    
    var delegate: FullViewControllerDelegate?
    
    override var title: String? {
        willSet {
            titleLab.text = newValue
            titleLab.sizeToFit()
            titleLab.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        view.addSubview(titleLab)
        view.addSubview(backBtn)
    }
    
    @objc func touchUpInside(btn: UIButton) {
        delegate?.viewController?(self, touchUpInside: btn)
    }
    
    lazy var titleLab: UILabel = {
        let lab = UILabel(frame: CGRect(x: 10, y: 100, width: 50, height: 20))
        lab.text = "This is a Full viewController"
        lab.sizeToFit()
        lab.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        return lab
    }()
    
    lazy var backBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 100, width: 40, height: 80))
        btn.setTitle("back", for: .normal)
        btn.addTarget(self, action: #selector(touchUpInside(btn:)), for: .touchUpInside)
        return btn
    }()

}
