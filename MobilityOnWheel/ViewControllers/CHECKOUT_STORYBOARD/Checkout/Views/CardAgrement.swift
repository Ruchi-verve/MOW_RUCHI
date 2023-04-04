//
//  TopPicksView.swift
//  VIPApp
//
//  Created by Arvind Kanjariya on 18/02/20.
//  Copyright © 2020 Arvind Kanjariya. All rights reserved.
//

import UIKit

protocol OnCloseClick {
    func onClose()
}


class CardAgrement: UIView {
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var innerView: UIView!
    var delegate : OnCloseClick?
   
   
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("CardAgrement", owner: self, options: nil)
        contentView.frame = self.bounds
        innerView.layer.borderWidth = 2.0
        innerView.layer.borderColor = AppConstants.kColor_Primary.cgColor
        innerView.layer.cornerRadius  = 10
        innerView.clipsToBounds = true
        contentView.fixInView(self)
     
    }
    
    @IBAction func btnCloseClick(sender: UIButton!) {
        if delegate != nil {
            delegate?.onClose()
        }
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
