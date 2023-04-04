//
//  LeftMenuCell.swift
//  Aamlucky
//
//  Created by Arvind Kanjariya on 17/01/20.
//  Copyright © 2020 Arvind Kanjariya. All rights reserved.
//

import UIKit
protocol SideMenuSubItemClick {
    func onSubOptionSelected(item: String)
}


let LeftMenuCellID = "LeftMenuCellID"

class LeftMenuCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblItem: UILabel!
    @IBOutlet weak var tblSubMenu: UITableView!
   
    var itemSubListener: SideMenuSubItemClick!
    var itemArraysubDelivery = [[String:AnyObject]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tblSubMenu.register(UINib(nibName: "SelectDestCell", bundle: nil), forCellReuseIdentifier: "SelectDestCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK:-UITableview Delegate  & DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArraysubDelivery.count
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 40: 30
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectDestCell = tableView.dequeueReusableCell(withIdentifier: "SelectDestCell", for: indexPath) as! SelectDestCell
        //        cell.imgIcon.image = UIImage(named: itemImageArray[indexPath.row])
        cell.lblDestName.text = "\u{2022}\(itemArraysubDelivery[indexPath.row]["name"] as? String ?? "")"
        cell.btnRadio.isHidden = true
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemSubListener.onSubOptionSelected(item:itemArraysubDelivery[indexPath.row]["name"] as! String)
    }
    
}
