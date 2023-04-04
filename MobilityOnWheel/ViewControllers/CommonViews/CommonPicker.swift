//
//  CommonPicker.swift
//
//  Created by admin on 09/02/21.
//  Copyright © 2021 Sheela Dodiya. All rights reserved.
//

import Foundation
import UIKit

protocol CommonPickerViewDelegate: AnyObject {
    func didTapDone()
}

class CommonPicker: UIPickerView {

    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: CommonPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        toolBar.setItems([spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }

}
