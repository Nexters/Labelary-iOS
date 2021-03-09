//
//  AddLabelViewController.swift
//  ShareSheet
//
//  Created by 우민지 on 2021/03/09.
//

import UIKit
import SwiftUI

class AddLabelViewController: UIViewController {

    @IBOutlet var container: UIView!
    var addLabelVC = UIHostingController(rootView: AddLabelView() )
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(addLabelVC)
        addLabelVC.view.frame = container.bounds
        addLabelVC.didMove(toParent: self)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
