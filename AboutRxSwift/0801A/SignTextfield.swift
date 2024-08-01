//
//  SignTextfield.swift
//  AboutRxSwift
//
//  Created by 최대성 on 8/1/24.
//

import UIKit

class SignTextfield: UITextField {
    
    
    init(placeholderText: String) {
        
        super.init(frame: .zero)
        
        textColor = UIColor.black
        placeholder = placeholderText
        textAlignment = .center
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
