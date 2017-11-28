//
//  CameraProfileViewController.swift
//
//  Created by ToKoRo on 2017-09-12.
//

import UIKit
import HomeKit

class CameraProfileViewController: UITableViewController, ContextHandler {
    typealias ContextType = HMCameraProfile

    var cameraProfile: HMCameraProfile { return context! }

    @IBOutlet weak var uniqueIdentifierLabel: UILabel?

    @IBOutlet weak var currentHorizontalTiltLabel: UILabel?
    @IBOutlet weak var currentVerticalTiltLabel: UILabel?
    @IBOutlet weak var digitalZoomLabel: UILabel?
    @IBOutlet weak var imageMirroringLabel: UILabel?
    @IBOutlet weak var imageRotationLabel: UILabel?
    @IBOutlet weak var nightVisionLabel: UILabel?
    @IBOutlet weak var opticalZoomLabel: UILabel?
    @IBOutlet weak var targetHorizontalTiltLabel: UILabel?
    @IBOutlet weak var targetVerticalTiltLabel: UILabel?

    @IBOutlet weak var cameraStreamEnabledLabel: UILabel?
    @IBOutlet weak var streamStateLabel: UILabel?
    @IBOutlet weak var audioStreamSettingLabel: UILabel?
    @IBOutlet weak var cameraViewPlace: UIView?

    @IBOutlet weak var snapshotEnabledLabel: UILabel?
    @IBOutlet weak var captureDateLabel: UILabel?
    @IBOutlet weak var snapshotViewPlace: UIView?

    @IBOutlet weak var speakerMuteLabel: UILabel?
    @IBOutlet weak var speakerVolumeLabel: UILabel?
    @IBOutlet weak var microphoneMuteLabel: UILabel?
    @IBOutlet weak var microphoneVolumeLabel: UILabel?

    weak var cameraView: HMCameraView?
    weak var snapshotView: HMCameraView?

    var selectedCharacteristic: HMCharacteristic?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let streamControl = cameraProfile.streamControl {
            streamControl.delegate = self
            setupCameraView(with: streamControl)
        }

        if let snapshotControl = cameraProfile.snapshotControl {
            snapshotControl.delegate = self
            setupSnapshotView(with: snapshotControl)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "Characteristic":
            return selectedCharacteristic != nil
        default:
            break
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Characteristic"?:
            sendContext(selectedCharacteristic, to: segue.destination)
        default:
            break
        }
    }

    private func refresh() {
        uniqueIdentifierLabel?.text = cameraProfile.uniqueIdentifier.uuidString

        currentHorizontalTiltLabel?.text = cameraProfile.settingsControl?.currentHorizontalTilt == nil ? "nil" : "1"
        currentVerticalTiltLabel?.text = cameraProfile.settingsControl?.currentVerticalTilt == nil ? "nil" : "1"
        digitalZoomLabel?.text = cameraProfile.settingsControl?.digitalZoom == nil ? "nil" : "1"
        imageMirroringLabel?.text = cameraProfile.settingsControl?.imageMirroring == nil ? "nil" : "1"
        imageRotationLabel?.text = cameraProfile.settingsControl?.imageRotation == nil ? "nil" : "1"
        nightVisionLabel?.text = cameraProfile.settingsControl?.nightVision == nil ? "nil" : "1"
        opticalZoomLabel?.text = cameraProfile.settingsControl?.opticalZoom == nil ? "nil" : "1"
        targetHorizontalTiltLabel?.text = cameraProfile.settingsControl?.targetHorizontalTilt == nil ? "nil" : "1"
        targetVerticalTiltLabel?.text = cameraProfile.settingsControl?.targetVerticalTilt == nil ? "nil" : "1"

        cameraStreamEnabledLabel?.text = cameraProfile.streamControl == nil ? "不可" : "可"
        streamStateLabel?.text = {
            guard let value = cameraProfile.streamControl?.streamState else {
                return "nil"
            }
            return String(describing: value)
        }()
        audioStreamSettingLabel?.text = {
            guard let value = cameraProfile.streamControl?.cameraStream?.audioStreamSetting else {
                return "nil"
            }
            return String(describing: value)
        }()

        snapshotEnabledLabel?.text = cameraProfile.snapshotControl == nil ? "不可" : "可"
        captureDateLabel?.text = {
            guard let date = cameraProfile.snapshotControl?.mostRecentSnapshot?.captureDate else {
                return "nil"
            }
            return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
        }()

        speakerMuteLabel?.text = cameraProfile.speakerControl?.mute == nil ? "nil" : "1"
        speakerVolumeLabel?.text = cameraProfile.speakerControl?.volume == nil ? "nil" : "1"
        microphoneMuteLabel?.text = cameraProfile.microphoneControl?.mute == nil ? "nil" : "1"
        microphoneVolumeLabel?.text = cameraProfile.microphoneControl?.volume == nil ? "nil" : "1"
    }

    private func displayAudioStreamSettingAction() {
        guard cameraProfile.streamControl?.cameraStream != nil else {
            return
        }

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for setting in HMCameraAudioStreamSetting.all {
            let title = setting.description
            alert.addAction(UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.updateAudioStreamSetting(setting)
            })
        }
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func updateAudioStreamSetting(_ setting: HMCameraAudioStreamSetting) {
        cameraProfile.streamControl?.cameraStream?.updateAudioStreamSetting(setting) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}

// MARK: - UITableViewDelegate

extension CameraProfileViewController {
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch (indexPath.section, indexPath.row) {
        case (3, 0):
            selectedCharacteristic = cameraProfile.speakerControl?.mute
        case (3, 1):
            selectedCharacteristic = cameraProfile.speakerControl?.volume
        case (4, 0):
            selectedCharacteristic = cameraProfile.microphoneControl?.mute
        case (4, 1):
            selectedCharacteristic = cameraProfile.microphoneControl?.volume
        case (5, 0):
            selectedCharacteristic = cameraProfile.settingsControl?.currentHorizontalTilt
        case (5, 1):
            selectedCharacteristic = cameraProfile.settingsControl?.currentVerticalTilt
        case (5, 2):
            selectedCharacteristic = cameraProfile.settingsControl?.digitalZoom
        case (5, 3):
            selectedCharacteristic  = cameraProfile.settingsControl?.imageMirroring
        case (5, 4):
            selectedCharacteristic  = cameraProfile.settingsControl?.imageRotation
        case (5, 5):
            selectedCharacteristic  = cameraProfile.settingsControl?.nightVision
        case (5, 6):
            selectedCharacteristic  = cameraProfile.settingsControl?.opticalZoom
        case (5, 7):
            selectedCharacteristic  = cameraProfile.settingsControl?.targetHorizontalTilt
        case (5, 8):
            selectedCharacteristic  = cameraProfile.settingsControl?.targetVerticalTilt
        default:
            break
        }

        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        switch (indexPath.section, indexPath.row) {
        case (1, 2):
            displayAudioStreamSettingAction()
        case (1, 3):
            startCameraStream()
        case (1, 4):
            stopCameraStream()
        case (2, 1):
            takeSnapshot()
        default:
            break
        }
    }
}

// MARK: - Camera & Snapshot

extension CameraProfileViewController {
    private func startCameraStream() {
        cameraProfile.streamControl?.startStream()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] () in
            self?.refresh()
        }
    }

    private func stopCameraStream() {
        cameraProfile.streamControl?.stopStream()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] () in
            self?.refresh()
        }
    }

    private func takeSnapshot() {
        cameraProfile.snapshotControl?.takeSnapshot()
    }

    private func setupCameraView(with cameraStreamControl: HMCameraStreamControl) {
        defer {
            cameraView?.cameraSource = cameraStreamControl.cameraStream
        }

        guard cameraView == nil else {
            return
        }

        guard let view = cameraViewPlace else {
            return
        }

        let newCameraView = HMCameraView()
        newCameraView.frame = view.bounds
        newCameraView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(newCameraView)
        self.cameraView = newCameraView
    }

    private func setupSnapshotView(with snapshotControl: HMCameraSnapshotControl) {
        defer {
            snapshotView?.cameraSource = snapshotControl.mostRecentSnapshot
        }

        guard snapshotView == nil else {
            return
        }

        guard let view = snapshotViewPlace else {
            return
        }

        let newSnapshotView = HMCameraView()
        newSnapshotView.frame = view.bounds
        newSnapshotView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(newSnapshotView)
        self.snapshotView = newSnapshotView
    }
}

// MARK: - HMCameraStreamControlDelegate

extension CameraProfileViewController: HMCameraStreamControlDelegate {
    func cameraStreamControl(_ cameraStreamControl: HMCameraStreamControl, didStopStreamWithError error: Error?) {
        let errorDescription: String = {
            guard let error = error else {
                return "nil"
            }
            return String(describing: error)
        }()
        print("# cameraStreamControl.didStopStreamWithError: \(errorDescription)")

        refresh()
    }

    func cameraStreamControlDidStartStream(_ cameraStreamControl: HMCameraStreamControl) {
        print("# cameraStreamControlDidStartStream")

        cameraView?.cameraSource = cameraStreamControl.cameraStream

        refresh()
    }
}

// MARK: - HMCameraSnapshotControlDelegate

extension CameraProfileViewController: HMCameraSnapshotControlDelegate {
    func cameraSnapshotControl(_ cameraSnapshotControl: HMCameraSnapshotControl, didTake snapshot: HMCameraSnapshot?, error: Error?) {
        let errorDescription: String = {
            guard let error = error else {
                return "nil"
            }
            return String(describing: error)
        }()
        print("# cameraSnapshotControl.didTake.error: \(errorDescription)")

        snapshotView?.cameraSource = snapshot

        refresh()
    }

    func cameraSnapshotControlDidUpdateMostRecentSnapshot(_ cameraSnapshotControl: HMCameraSnapshotControl) {
        print("# cameraSnapshotControlDidUpdateMostRecentSnapshot")

        snapshotView?.cameraSource = cameraSnapshotControl.mostRecentSnapshot

        refresh()
    }
}
