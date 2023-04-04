//
//  GenericDataSource.swift
//  DrlogyPro
//
//  Created by Arvind Kanjariya on 27/06/19.
//  Copyright © 2019 Arvind Kanjariya. All rights reserved.
//

import UIKit


class GenericDataSource<T>: NSObject, UITableViewDataSource, UITableViewDelegate {
    typealias CellConfigurator = (T, UITableViewCell) -> Void
    typealias ItemClick = (T, IndexPath, UITableViewCell) -> Void
    
    var models: [T] = []
    var arrmodels: [[T]] = [[]]

    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    private let itemClick: ItemClick
    var isArrofDict :Bool = false
    
    var loadMore: ((_ pageNo: Int) -> (Void))?
    
    var pageNo:Int = 1;
    var enableSwipeToDelete: Bool = false
    var enableMoveRow: Bool = false
    var enableReorderRow: Bool = false
    var cellHeight: Int = -1
    

    init(models: [T],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator,
         itemClick: @escaping ItemClick) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
        self.itemClick = itemClick
    }
    
    func setNewData(model: [T]) {
        self.models = model
    }
    
    
    init(arrmodels: [[T]],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator,
         itemClick: @escaping ItemClick) {
        self.arrmodels = arrmodels
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
        self.itemClick = itemClick
    }
    
    func setNewData(arrmodels: [[T]]) {
        self.arrmodels = arrmodels
    }

    func resetPageNo() {
        self.pageNo = 1
    }
    
    func setPageNo(page:Int) {
        self.pageNo = page
    }
    
    func setCellHeightNo(cellHeight:Int) {
        self.cellHeight = cellHeight
    }
    
    func enableSwipeToDelete(isEnable:Bool) {
        self.enableSwipeToDelete = isEnable
    }
    
    func enableMoveRow(isEnable:Bool) {
        self.enableMoveRow = isEnable
    }
    
    func enableReorderRow(isEnable:Bool) {
        self.enableReorderRow = isEnable
    }
    
    func enableReorderTable(_ tableView:UITableView) {
        tableView.isEditing = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isArrofDict == true {
            return arrmodels.count
        }
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isArrofDict == true {
            let model = arrmodels[indexPath.row]
            let cell = tableView.dequeueReusableCell(
                withIdentifier: reuseIdentifier,
                for: indexPath
            )
            cell.tag = indexPath.row
            cellConfigurator(model as! T, cell)
            return cell
        }
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        cell.tag = indexPath.row
        cellConfigurator(model, cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isArrofDict == true {
            let cell:UITableViewCell = tableView.cellForRow(at: indexPath) ?? UITableViewCell()
            let model = arrmodels[indexPath.row]
            itemClick(model as! T,indexPath, cell)
            return
        }

        let cell:UITableViewCell = tableView.cellForRow(at: indexPath) ?? UITableViewCell()
        let model = models[indexPath.row]
        itemClick(model,indexPath, cell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.cellHeight > 0 {
            return CGFloat(self.cellHeight)
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.models.count - 2 {
            if loadMore != nil {
                pageNo += 1
                loadMore!(pageNo)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.enableSwipeToDelete {
            return self.enableSwipeToDelete
        } else if self.enableReorderRow {
            return self.enableReorderRow
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.enableMoveRow
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if self.enableSwipeToDelete {
            return .delete
        } else {
            return .none
        }
        
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if self.enableReorderRow {
            print("Reorder Enable")
            let model = models[sourceIndexPath.row]
            models.remove(at: sourceIndexPath.row)
            models.insert(model, at: destinationIndexPath.row)
        }
    }
}

