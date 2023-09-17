//
//  ViewController.swift
//  RYTransitioningDelegateSwift
//
//  Created by RisingSSR on 07/20/2023.
//  Copyright (c) 2023 RisingSSR. All rights reserved.
//

import UIKit
import RYTransitioningDelegateSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var containerViewBackBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("back", for: .normal)
        btn.backgroundColor = .orange
        btn.addTarget(self, action: #selector(touchUpInside(btn:)), for: .touchUpInside)
        return btn
    }()
    
    @objc func touchUpInside(btn: UIButton) {
        self.viewController(presentedViewController as! FullViewController, touchUpInside: btn)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ViewController.situation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = ViewController.situation[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.identifier, for: indexPath) as! BaseTableViewCell
        cell.titleLab.text = model
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 0:
            presentFullViewController()
        case 1:
            presentCustomizeHeight()
        case 2:
            presentCustomizeWithBackBtn()
        default:
            break
        }
    }
}

extension ViewController {
    func presentFullViewController() {
        let transitioningDelegate = RYTransitioningDelegate()
        transitioningDelegate.supportedTapOutsideBackWhenPresent = false
        
        let vc = FullViewController()
        vc.transitioningDelegate = transitioningDelegate
        vc.modalPresentationStyle = .custom
        
        vc.delegate = self
        
        self.present(vc, animated: true)
    }
    
    func presentCustomizeHeight() {
        let heightForPresented: CGFloat = 560
        
        let transitioningDelegate = RYTransitioningDelegate()
        transitioningDelegate.supportedTapOutsideBackWhenPresent = false
        transitioningDelegate.present = { transition in
            transition.heightForPresented = heightForPresented
        }
        
        let vc = FullViewController()
        vc.transitioningDelegate = transitioningDelegate
        vc.modalPresentationStyle = .custom
        
        vc.title = "customize height: \(heightForPresented)"
        vc.delegate = self
        
        self.present(vc, animated: true)
    }
    
    func presentCustomizeWithBackBtn() {
        let height: CGFloat = 420
        
        let transitioningDelegate = RYTransitioningDelegate()
        transitioningDelegate.supportedTapOutsideBackWhenPresent = false
        transitioningDelegate.present = { transition in
            transition.heightForPresented = height
            transition.prepareAnimationAction = { context in
                transition.prepareWithBase(context: context)
                self.containerViewBackBtn.alpha = 0
                context.containerView.addSubview(self.containerViewBackBtn)
            }
            transition.finishAnimationAction = { context in
                transition.finishedWithBase(context: context)
                context.containerView.backgroundColor = .black.withAlphaComponent(0.5)
                self.containerViewBackBtn.alpha = 1
            }
        }
        
        let vc = FullViewController()
        vc.transitioningDelegate = transitioningDelegate
        vc.modalPresentationStyle = .custom
        
        vc.view.frame.size.height = height
        vc.title = "customize height: \(vc.view.frame.size.height) with back Btn"
        vc.delegate = self
        
        self.present(vc, animated: true)
    }
}

extension ViewController: FullViewControllerDelegate {
    func viewController(_ viewController: FullViewController, touchUpInside button: UIButton) {
        if let selectedRow = tableView.indexPathForSelectedRow?.row {
            if selectedRow == 2 {
                let transitioningDelegate = RYTransitioningDelegate()
                viewController.transitioningDelegate = transitioningDelegate
                viewController.dismiss(animated: true)
            } else {
                viewController.dismiss(animated: true)
            }
        } else {
            viewController.dismiss(animated: true)
        }
    }
}

extension ViewController {
    static var situation: [String] = [
        "present full viewController",
        "customize a section of height",
        "customize height with custom delegate"
    ]
}
