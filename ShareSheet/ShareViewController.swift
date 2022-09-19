//
//  ShareViewController.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/02/14.
//

import MobileCoreServices
import Realm
import RealmSwift
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
        accessMainRealm() // realm 확인하기
        shareRealm()
        if shareExtension.dismiss {
            print("dismiss share extension ")
            let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
            navigationItem.setLeftBarButton(itemCancel, animated: true)
        }
    }

    // MARK: - Realm


    func inLibraryFolder(fileName: String) -> URL {
        let libraryUserDomain = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        let makeFileURL = URL(fileURLWithPath: libraryUserDomain[0], isDirectory: true)
        return makeFileURL.appendingPathComponent(fileName)
    }

    func accessMainRealm() {
        print(#function)
        let config = Realm.Configuration(fileURL: inLibraryFolder(fileName: "default.realm"))
        let realm = try! Realm(configuration: config)
        let labels = realm.objects(LabelRealmModel.self)
        print("Labels in DB: =\(labels.count)")
        print(config.fileURL!)
        print("======================")
    }

    func shareRealm() {
        print(#function)
        let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Fullstack")?.appendingPathComponent("default.realm")
        let sharedConfig = Realm.Configuration(fileURL: directory)
        if let bundleURL = Bundle.main.url(forResource: "bundle", withExtension: "realm") {
            try! FileManager.default.copyItem(at: bundleURL, to: sharedConfig.fileURL!)
            print(sharedConfig.fileURL!)
        } else {
            print(sharedConfig.fileURL!)
            print("file exist")
        }
        
        let realm = try! Realm(configuration: sharedConfig)
        let labels = realm.objects(LabelRealmModel.self)
        print("shared.realm -> Labels in DB = \(labels.count)")
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
