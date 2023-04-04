//
//  ProductCell.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit

let ProductCellID = "ProductCellID"


class ProductCell: UICollectionViewCell {

    @IBOutlet weak var imgproductImage:UIImageView!
    @IBOutlet weak var lblproductName:UILabel!
    @IBOutlet weak var lblproductPrice:UILabel!
    @IBOutlet weak var viewProduct:UIView!
    @IBOutlet weak var actiIndi:UIActivityIndicatorView!
    @IBOutlet weak var conlblPrice:NSLayoutConstraint!
    @IBOutlet weak var viewDesc:UIView!
    override func layoutSubviews() {
      self.layoutIfNeeded()
     }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewProduct.roundedViewCorner(radius: 8)
    }

}
