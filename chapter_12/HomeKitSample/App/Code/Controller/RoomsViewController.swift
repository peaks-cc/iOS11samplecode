//
//  RoomsViewController.swift
//
//  Created by ToKoRo on 2017-08-26.
//

import UIKit
import HomeKit

class RoomsViewController: UITableViewController, ContextHandler {
    typealias ContextType = RoomStore

    @IBInspectable var isSelectMode: Bool = false

    var store: RoomStore { return context! }
    var rooms: [HMRoom] { return store.rooms }

    var selectedRoom: HMRoom?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Room"?:
            sendContext(selectedRoom, to: segue.destination)
        case "SelectRoom"?:
            let context: RoomStore = {
                switch store.roomStoreKind {
                case .home(let home):
                    return home
                case .zone(let zone):
                    return zone.home ?? zone
                }
            }()
            sendContext(context, to: segue.destination)
        default:
            break
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func room(at indexPath: IndexPath) -> HMRoom? {
        return rooms.safe[indexPath.row]
    }

    @IBAction func addButtonDidTap(sender: AnyObject) {
        switch store.roomStoreKind {
        case .home:
            displayNewRoomAlert()
        case .zone:
            displayNewRoomAction()
        }
    }

    @IBAction func cancelButtonDidTap(sender: AnyObject) {
        dismiss(animated: true)
    }

    private func displayNewRoomAlert() {
        let alert = UIAlertController(title: nil, message: "追加するRoomの名前を入力してください", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard
                let name = alert.textFields?.first?.text,
                name.count > 0
            else {
                return
            }
            self?.handleNewRoomName(name)
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func displayNewRoomAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "新規追加", style: .default) { [weak self] _ in
            self?.displayNewRoomAlert()
        })
        alert.addAction(UIAlertAction(title: "既存のRoom", style: .default) { [weak self] _ in
            self?.selectRoom()
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel))
        present(alert, animated: true)
    }

    private func handleNewRoomName(_ name: String) {
        switch store.roomStoreKind {
        case .home(let home):
            home.addRoom(withName: name) { [weak self] room, error in
                if let room = room {
                    print("# added room: \(room)")
                }
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        case .zone(let zone):
            zone.home?.addRoom(withName: name) { [weak self] room, error in
                if let error = error {
                    print("# error: \(error)")
                }
                if let room = room {
                    zone.addRoom(room) { [weak self] error in
                        if let error = error {
                            print("# error: \(error)")
                        }
                        self?.refresh()
                    }
                }
            }
        }
    }

    private func selectRoom() {
        performSegue(withIdentifier: "SelectRoom", sender: nil)
    }
}

// MARK: - RoomActionHandler

extension RoomsViewController: RoomActionHandler {
    func handleRemove(_ room: HMRoom) {
        switch store.roomStoreKind {
        case .home(let home):
            home.removeRoom(room) { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        case .zone(let zone):
            zone.removeRoom(room) { [weak self] error in
                if let error = error {
                    print("# error: \(error)")
                }
                self?.refresh()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension RoomsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Room", for: indexPath)
        if let room = room(at: indexPath) {
            cell.textLabel?.text = room.name
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RoomsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        self.selectedRoom = room(at: indexPath)

        if isSelectMode, let room = selectedRoom {
            ResponderChain(from: self).send(room, protocol: RoomSelector.self) { room, handler in
                handler.selectRoom(room)
            }
            dismiss(animated: true)
        } else {
            performSegue(withIdentifier: "Room", sender: nil)
        }
    }
}

// MARK: - RoomSelector

extension RoomsViewController: RoomSelector {
    func selectRoom(_ room: HMRoom) {
        guard case .zone(let zone) = store.roomStoreKind else {
            return
        }

        zone.addRoom(room) { [weak self] error in
            if let error = error {
                print("# error: \(error)")
            }
            self?.refresh()
        }
    }
}
