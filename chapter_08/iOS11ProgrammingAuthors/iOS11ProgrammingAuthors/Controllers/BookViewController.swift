//
//  BookViewController.swift
//  iOS11ProgrammingAuthors
//
//  Created by Yusuke Kawanabe on 7/18/17.
//  Copyright © 2017 Yusuke Kawanabe. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet var additionalView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bookImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bodyFont = UIFontMetrics.default.scaledFont(for: UIFont(name: "HiraKakuProN-W6", size: 14)!)
        detailLabel.font = bodyFont
        
        configureStackViewSpacing()
    }
    
    private func configureStackViewSpacing() {
        stackView.setCustomSpacing(30, after: bookImageView)
    }
    
    private func showAdditionalView() {
        additionalView.frame = view.frame
        view.addSubview(additionalView)
    }
}


