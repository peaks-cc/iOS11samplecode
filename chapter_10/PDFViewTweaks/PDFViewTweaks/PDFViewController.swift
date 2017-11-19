//
//  PDFViewController.swift
//  PDFViewTweaks
//
//  Created by Kishikawa Katsumi on 2017/10/25.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    var options: PDFViewOptions!
    var displaysThumbnailView = false
    
    var pdfDocument: PDFDocument!
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var pdfThumbnailView: PDFThumbnailView!
    @IBOutlet weak var thumbnailViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolbar: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.hidesBarsOnTap = true
        navigationController?.hidesBarsOnSwipe = true

        if let url = Bundle.main.url(forResource: "iOS11Programming", withExtension: "pdf") {
            pdfDocument = PDFDocument(url: url)
        }

        pdfView.displayMode = options.displayMode
        pdfView.displayDirection = options.displayDirection
        pdfView.displaysPageBreaks = options.displaysPageBreaks
        pdfView.pageBreakMargins = options.pageBreakMargins
        pdfView.displayBox = options.displayBox
        pdfView.displaysAsBook = options.displaysAsBook
        pdfView.displaysRTL = options.displaysRTL
        pdfView.backgroundColor = options.backgroundColor
        pdfView.interpolationQuality = options.interpolationQuality
        pdfView.usePageViewController(options.usePageViewController, withViewOptions: nil)
        pdfView.enableDataDetectors = options.enableDataDetectors

        pdfView.autoScales = options.autoScales

        pdfView.document = pdfDocument

        pdfThumbnailView.layoutMode = .horizontal
        pdfThumbnailView.pdfView = pdfView
        if !displaysThumbnailView {
            thumbnailViewHeightConstraint.constant = 0
            pdfThumbnailView.isHidden = true
            toolbar.isHidden = true
        }
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
