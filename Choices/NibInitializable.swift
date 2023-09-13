//
//  NibInitializable.swift
//  Choices
//
//  Created by MertcanAkyürek on 28.07.2023.
//

import UIKit

protocol NibInitializable {
    var nibName: String { get set }
}

extension NibInitializable where Self: UIView {
    internal func initialize(withNibName nibName: String, _ initializeCallback: ((UIView) -> Void)? = nil) {
        guard let view = loadView(fromNibName: nibName) else {
            print("failed to initialize nib, nibName: \(nibName)")
            return
        }
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = self.bounds
        
        self.addSubview(view)
        
        initializeCallback?(view)
    }
    
    private func loadView(fromNibName nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
