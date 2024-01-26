//
//  ViewController.swift
//  ToastMasterExample
//
//  Created by Pavel Moslienko on 01.01.2024.
//

import UIKit
import ToastMaster

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ToastView.shared.show(message: "Hello!", controller: self, icon: nil, linkTapped: nil)
    }


}

