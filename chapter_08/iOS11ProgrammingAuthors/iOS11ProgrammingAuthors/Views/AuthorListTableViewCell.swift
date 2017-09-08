//
//  AuthorListTableViewCell.swift
//  iOS11ProgrammingAuthors
//
//  Created by Yusuke Kawanabe on 8/21/17.
//  Copyright © 2017 Yusuke Kawanabe. All rights reserved.
//

import UIKit

class AuthorListTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with author: Author) {
        let name = "\(author.name) (\(author.twitter))"
        let title = author.isFavorite ? "⭐️" + name : name
        titleLabel.text = title
        profileImageView.image = author.image
    }

}
