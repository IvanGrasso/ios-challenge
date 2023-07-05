//
//  UIView+Utils.swift
//  Paradigma Challenge
//
//  Created by Ivan Grasso on 7/5/23.
//

import Foundation
import UIKit

extension UIView {
    func pinToSuperview(leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}
