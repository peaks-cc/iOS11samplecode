//
//  CommencementTranscriptViewController.swift
//  iOS11ProgrammingAuthors
//
//  Created by Yusuke Kawanabe on 8/19/17.
//  Copyright © 2017 Yusuke Kawanabe. All rights reserved.
//

import UIKit

class CommencementTranscriptViewController: UIViewController {

    @IBOutlet var transcriptLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.addSubview(transcriptLabel)
        transcriptLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.layoutMarginsGuide.leadingAnchor.constraint(equalTo: transcriptLabel.leadingAnchor),
            scrollView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: transcriptLabel.trailingAnchor),
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: transcriptLabel.topAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: transcriptLabel.bottomAnchor)
            ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Steve Jobs"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            scrollView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: titleLabel.topAnchor)
             ])
    }
}

