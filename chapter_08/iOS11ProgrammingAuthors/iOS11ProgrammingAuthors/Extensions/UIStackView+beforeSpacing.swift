//
//  UIStackView+beforeSpacing.swift
//  iOS11ProgrammingAuthors
//
//  Created by Yusuke Kawanabe on 8/27/17.
//  Copyright © 2017 Yusuke Kawanabe. All rights reserved.
//

import UIKit

extension UIStackView {
    func setCustomSpacing(_ spacing: CGFloat, before arrangedSubview: UIView) {
        let index = self.subviews.index(of: arrangedSubview)
        if let index = index,
            index > 1 {
            let view = self.subviews[index - 1]
            self.setCustomSpacing(12, after: view)
        }
    }
}

