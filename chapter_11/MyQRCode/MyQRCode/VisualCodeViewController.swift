//
//  VisualCodeViewController.swift
//  MyQRCode
//
//  Created by Kishikawa Katsumi on 2017/09/04.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit

class VisualCodeViewController: UIViewController {
    var visualCodeImage: UIImage?
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = visualCodeImage
    }

    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
