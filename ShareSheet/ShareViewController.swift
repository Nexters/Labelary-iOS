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
    @ObservedObject var shareExtension = ShareExtensionViewObservable()
    var tempImage = UIImage()
    private var sharedImage = model(imageData: UIImage())

    override func viewWillAppear(_ animated: Bool) {
        var input = model(imageData: UIImage())
        getImage()
        let childView = UIHostingController(rootView: LabelViewFromOutside(sharedImage: sharedImage))
        addChild(childView)
        childView.view.frame = container.bounds
        container.addSubview(childView.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if shareExtension.dismiss {
            print("dismiss share extension ")
            let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
            navigationItem.setLeftBarButton(itemCancel, animated: true)
        }
    }

    // MARK: - Get Image file from share extension

    func getImage() {
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeData as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypeData as String, options: [:]) { [self]
                        data, _ in

                        var image: UIImage?

                        if let someURL = data as? URL {
                            image = UIImage(contentsOfFile: someURL.path)

                            if let someImage = image {
                                self.sharedImage.imageData = someImage
                            } else {
                                print("Bad share data \n")
                            }
                        } else if let someImage = data as? UIImage {
                            image = someImage
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

class model: ObservableObject {
    @Published var imageData: UIImage?

    init(imageData: UIImage) {
        self.imageData = imageData // imageData from the url
    }
}
