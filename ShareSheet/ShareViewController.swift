//
//  ShareViewController.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/02/14.
//

import MobileCoreServices
import SwiftUI
import UIKit

@objc(ShareViewController)
class ShareViewController: UIViewController {
    @IBOutlet weak var container: UIView!
    
    var vc = UIHostingController(rootView: LabelViewFromOutside())
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        addChild(vc)
        vc.view.frame = container.bounds
        container.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        
        self.view.backgroundColor = .systemGray6
        
       // self.setupNavBar()
        self.setUpConstraints()
    }
    
    func setUpConstraints() {
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    

    // 2: Set the title and the navigation items
    private func setupNavBar() {
        self.navigationItem.title = "???"

        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)

        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }

    // 3: Define the actions for the navigation items
    @objc private func cancelAction() {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}

@objc(ShareNavigationController)
class ShareNavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        // 2: set the ViewControllers
        self.setViewControllers([ShareViewController()], animated: false)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
