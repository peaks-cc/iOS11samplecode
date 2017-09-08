//
//  AuthorListViewController.swift
//  iOS11ProgrammingAuthors
//
//  Created by Yusuke Kawanabe on 7/18/17.
//  Copyright © 2017 Yusuke Kawanabe. All rights reserved.
//

import UIKit

class AuthorListViewController: UIViewController, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!

    var authors = [Author(name: "堤 修一", twitter:"@shu223", image: #imageLiteral(resourceName: "tsutsumi")),
                   Author(name: "吉田 悠一", twitter:"@sonson_twit", image: #imageLiteral(resourceName: "yoshida")),
                   Author(name: "池田 翔", twitter:"@ikesyo", image: #imageLiteral(resourceName: "ikeda")),
                   Author(name: "坂田 晃一", twitter:"@huin", image: #imageLiteral(resourceName: "sakata")),
                   Author(name: "川邉 雄介", twitter:"@jeffsuke", image: #imageLiteral(resourceName: "kawanabe")),
                   Author(name: "岸川 克己", twitter:"@k_katsumi", image: #imageLiteral(resourceName: "kishikawa")),
                   Author(name: "加藤 尋樹", twitter:"@cockscomb", image: #imageLiteral(resourceName: "katou")),
                   Author(name: "所 友太", twitter:"@tokorom", image: #imageLiteral(resourceName: "tokoro")),
                   Author(name: "永野 哲久", twitter:"@7gano", image: #imageLiteral(resourceName: "nagano"))
    ]
    
    var filteredAuthors: [Author] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredAuthors = authors
        tableView.separatorInset = UIEdgeInsets(top: 120, left: 120, bottom: 120, right: 120)
        // ラージタイトルの追加
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // ラージタイトルのスタイルを変更
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "SnellRoundhand-Black", size:42)!,
            NSAttributedStringKey.foregroundColor: UIColor.blue
        ]
        
        // 検索フィールドの追加
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text,
            text.count > 0 {
            filteredAuthors = authors.filter { $0.name.contains(text.lowercased()) || $0.twitter.contains(text.lowercased()) }
        } else {
            filteredAuthors = authors
        }
        
        tableView.reloadData()
    }
    
    fileprivate func remove(_ unwantedAuthor: Author) {
        if let index = authors.index(where: { $0 == unwantedAuthor}) {
            authors.remove(at: index)
        }
        
        if let index = filteredAuthors.index(where: { $0 == unwantedAuthor}) {
            filteredAuthors.remove(at: index)
        }
    }
    
    fileprivate func updateFavoriteState(of authorToUpdate: Author) {
        if let index = authors.index(where: { $0 == authorToUpdate}) {
            authors[index].isFavorite = !authors[index].isFavorite
        }
        
        if let index = filteredAuthors.index(where: { $0 == authorToUpdate}) {
            filteredAuthors[index].isFavorite = !filteredAuthors[index].isFavorite
        }
        tableView.reloadData()
    }
}

struct Author {
    let name: String
    let twitter: String
    let image: UIImage
    var isFavorite: Bool
    
    init(name: String, twitter: String, image: UIImage, isFavorite: Bool = false) {
        self.name = name
        self.twitter = twitter
        self.image = image
        self.isFavorite = isFavorite
    }
}

extension Author: Equatable {
    static func == (lhs: Author, rhs: Author) -> Bool {
        return lhs.name == rhs.name
    }
}

extension AuthorListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorListTableViewCell", for: indexPath) as! AuthorListTableViewCell
        let author = filteredAuthors[indexPath.row]
        cell.configure(with: author)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAuthors.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { (action, view, completionHandler) in
            self.updateFavoriteState(of: self.filteredAuthors[indexPath.row])
            completionHandler(true)
        }
        
        if filteredAuthors[indexPath.row].isFavorite {
            favoriteAction.title = "Unfavorite"
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.remove(self.filteredAuthors[indexPath.row])
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

