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
    @IBOutlet var container: UIView!
    // @ObservedObject var model = extensionOutput()

    var vc = UIHostingController(rootView: LabelViewFromOutside())

    override func viewWillAppear(_ animated: Bool) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
        setupNavBar()
        addChild(vc)
        vc.view.frame = container.bounds
        container.addSubview(vc.view)
        vc.didMove(toParent: self)

        view.backgroundColor = .systemGray6

        setUpConstraints()
    }

    func setUpConstraints() {
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        vc.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    // MARK: - Get Image file from share extension

    func getImage() {
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeData as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeData as String) {
                        [unowned self] imageData, _ in
                        if let item = imageData as? Data {
                            // self.model.imageData = UIImage(data: item)
                            // print(self.model.imageData)
                            // self.imageView.image = UIImage(data: item)
                            print(UIImage(data: item))
                        }
                    }
                }
            }
        }
    }

    // 2: Set the title and the navigation items
    private func setupNavBar() {
        navigationItem.title = "???"

        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        navigationItem.setLeftBarButton(itemCancel, animated: false)

        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.setRightBarButton(itemDone, animated: false)
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
        setViewControllers([ShareViewController()], animated: false)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// class extensionOutput: ObservableObject {
//    @Published var imageData: UIImage
//    init(imageData: UIImage) {
//        self.imageData = imageData
//    }
// }
