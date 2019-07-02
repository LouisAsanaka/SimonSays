//
//  CircularButton.swift
//  Simon Says
//
//  Created by Louis on 2019/7/2.
//  Copyright © 2019 Louis. All rights reserved.
//

import UIKit

class CircularButton: UIButton {

    func setCircular(bool: Bool) {
        if bool {
            layer.cornerRadius = bounds.size.width / 2
            layer.masksToBounds = true
            clipsToBounds = true
        } else {
            layer.cornerRadius = 0
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 1.0
            } else {
                alpha = 0.5
            }
        }
    }
}
