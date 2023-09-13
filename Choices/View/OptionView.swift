//
//  OptionView.swift
//  Choices
//
//  Created by MertcanAkyürek on 27.07.2023.
//

import UIKit

class OptionView: UIView, NibInitializable {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var nibName = "OptionView"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize(withNibName: nibName)
    }
}
