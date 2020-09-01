//
//  InputContainerView.swift
//  GuessTheNumber
//
//  Created by Apurva Deshmukh on 8/31/20.
//  Copyright © 2020 Kaavya Singhal. All rights reserved.
//

import UIKit

class InputContainerView: UIView {

    // MARK: - Lifecycle
    
    init(image: UIImage?, textField: UITextField) {
        super.init(frame: .zero)
        
        setHeight(height: 50)
        
        let iv = UIImageView()
        iv.image = image
        iv.tintColor = .white
        iv.alpha = 0.87
        
        addSubview(iv)
        iv.centerY(inView: self)
        iv.anchor(left: leftAnchor, paddingLeft: 8)
        iv.setDimensions(height: 24, width: 24)
        
        addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: iv.bottomAnchor, right: rightAnchor,
                         paddingLeft: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        dividerView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                           paddingLeft: 8, height: 0.75)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
