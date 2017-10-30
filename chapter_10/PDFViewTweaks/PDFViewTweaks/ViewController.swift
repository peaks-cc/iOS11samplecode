//
//  ViewController.swift
//  PDFViewTweaks
//
//  Created by Kishikawa Katsumi on 2017/10/25.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UITableViewController {
    var options = PDFViewOptions()
    var displaysThumbnailView = false

    @IBOutlet weak var displayModeLabel: UILabel!
    @IBOutlet weak var displayDirectionLabel: UILabel!
    @IBOutlet weak var displaysPageBreaksSwitch: UISwitch!
    @IBOutlet weak var displayBoxLabel: UILabel!
    @IBOutlet weak var displaysAsBookSwitch: UISwitch!
    @IBOutlet weak var displaysRTLSwitch: UISwitch!
    @IBOutlet weak var interpolationQualityLabel: UILabel!
    @IBOutlet weak var autoScalesSwitch: UISwitch!
    @IBOutlet weak var usePageViewControllerSwitch: UISwitch!
    @IBOutlet weak var enableDataDetectorsSwitch: UISwitch!
    @IBOutlet weak var displaysThumbnailViewSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        displayModeLabel.text = options.displayMode.description
        displayDirectionLabel.text = options.displayDirection.description
        displaysPageBreaksSwitch.isOn = options.displaysPageBreaks
        displayBoxLabel.text = options.displayBox.description
        displaysAsBookSwitch.isOn = options.displaysAsBook
        displaysRTLSwitch.isOn = options.displaysRTL
        interpolationQualityLabel.text = options.interpolationQuality.description
        autoScalesSwitch.isOn = options.autoScales
        usePageViewControllerSwitch.isOn = options.usePageViewController
        enableDataDetectorsSwitch.isOn = options.enableDataDetectors
        displaysThumbnailViewSwitch.isOn = displaysThumbnailView
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? DisplayModeViewController {
            viewController.options = options
        }
        if let viewController = segue.destination as? DisplayDirectionViewController {
            viewController.options = options
        }
        if let viewController = segue.destination as? DisplayBoxViewController {
            viewController.options = options
        }
        if let viewController = segue.destination as? InterpolationQualityViewController {
            viewController.options = options
        }
    }

    @IBAction func openDocument(_ sender: Any) {
        if let navigationController = storyboard?.instantiateViewController(withIdentifier: "PDFNavigationController") as? UINavigationController,
            let viewController = navigationController.topViewController as? PDFViewController {
            viewController.options = options
            viewController.displaysThumbnailView = displaysThumbnailView
            present(navigationController, animated: true, completion: nil)
        }
    }

    @IBAction func displaysPageBreaksSwitchValueChanged(_ sender: UISwitch) {
        options.displaysPageBreaks = sender.isOn
    }

    @IBAction func displaysAsBookSwitchValueChanged(_ sender: UISwitch) {
        options.displaysAsBook = sender.isOn
    }

    @IBAction func displaysRTLSwitchValueChanged(_ sender: UISwitch) {
        options.displaysRTL = sender.isOn
    }

    @IBAction func autoScalesSwitchValueChanged(_ sender: UISwitch) {
        options.autoScales = sender.isOn
    }

    @IBAction func usePageViewControllerSwitchValueChanged(_ sender: UISwitch) {
        options.usePageViewController = sender.isOn
    }

    @IBAction func enableDataDetectorsSwitchValueChanged(_ sender: UISwitch) {
        options.enableDataDetectors = sender.isOn
    }

    @IBAction func displaysThumbnailViewSwitchValueChanged(_ sender: UISwitch) {
        displaysThumbnailView = sender.isOn
    }
}

class PDFViewOptions {
    var displayMode = PDFDisplayMode.singlePageContinuous
    var displayDirection = PDFDisplayDirection.vertical
    var displaysPageBreaks = true
    var pageBreakMargins = UIEdgeInsets(top: 4.75, left: 4.0, bottom: 4.75, right: 4.0)
    var displayBox = PDFDisplayBox.cropBox
    var displaysAsBook = false
    var displaysRTL = false
    var backgroundColor = UIColor(white: 0.5, alpha: 1.0)
    var interpolationQuality = PDFInterpolationQuality.high
    var usePageViewController = false
    var enableDataDetectors = false

    var scaleFactor: CGFloat = 1.0
    var minScaleFactor: CGFloat = 0.25
    var maxScaleFactor: CGFloat = 2.0
    var autoScales = false
}

class DisplayModeViewController: UITableViewController {
    var options: PDFViewOptions!

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            options.displayMode = .singlePage
        case 1:
            options.displayMode = .singlePageContinuous
        case 2:
            options.displayMode = .twoUp
        case 3:
            options.displayMode = .twoUpContinuous
        default:
            options.displayMode = .singlePageContinuous
        }

        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CATransaction.animationDuration()) {
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == options.displayMode.rawValue {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

class DisplayDirectionViewController: UITableViewController {
    var options: PDFViewOptions!

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            options.displayDirection = .vertical
        case 1:
            options.displayDirection = .horizontal
        default:
            options.displayDirection = .vertical
        }

        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CATransaction.animationDuration()) {
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == options.displayDirection.rawValue {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

class DisplayBoxViewController: UITableViewController {
    var options: PDFViewOptions!

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            options.displayBox = .mediaBox
        case 1:
            options.displayBox = .cropBox
        case 2:
            options.displayBox = .bleedBox
        case 3:
            options.displayBox = .trimBox
        case 4:
            options.displayBox = .artBox
        default:
            options.displayBox = .cropBox
        }

        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CATransaction.animationDuration()) {
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == options.displayBox.rawValue {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

class InterpolationQualityViewController: UITableViewController {
    var options: PDFViewOptions!

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            options.interpolationQuality = .none
        case 1:
            options.interpolationQuality = .low
        case 2:
            options.interpolationQuality = .high
        default:
            options.interpolationQuality = .high
        }

        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CATransaction.animationDuration()) {
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == options.interpolationQuality.rawValue {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

extension PDFDisplayMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .singlePage:
            return "Single Page"
        case .singlePageContinuous:
            return "Single Page Continuous"
        case .twoUp:
            return "Two Up"
        case .twoUpContinuous:
            return "Two Up Continuous"
        }
    }
}

extension PDFDisplayDirection: CustomStringConvertible {
    public var description: String {
        switch self {
        case .vertical:
            return "Vertical"
        case .horizontal:
            return "Horizontal"
        }
    }
}

extension PDFDisplayBox: CustomStringConvertible {
    public var description: String {
        switch self {
        case .mediaBox:
            return "Media Box"
        case .cropBox:
            return "Crop Box"
        case .bleedBox:
            return "Bleed Box"
        case .trimBox:
            return "Trim Box"
        case .artBox:
            return "Art Box"
        }
    }
}

extension PDFInterpolationQuality: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "None"
        case .low:
            return "Low"
        case .high:
            return "High"
        }
    }
}
