//
//  GenericDataSource.swift
//  DrlogyPro
//
//  Created by Arvind Kanjariya on 27/06/19.
//  Copyright © 2019 Arvind Kanjariya. All rights reserved.
//

import UIKit


class GenericDataSourceWithSection<T>: NSObject, UITableViewDataSource, UITableViewDelegate {
    typealias CellConfigurator = (T, UITableViewCell) -> Void
    typealias CellConfiguratorSection = ([T], UITableViewHeaderFooterView) -> Void
    typealias ItemClick = (T, IndexPath, UITableViewCell) -> Void
    
    var models: [[T]] = [[]]
    private let reuseIdentifier: String
    private let reuseIdentifierSection: String
    private let cellConfigurator: CellConfigurator
    private let cellConfiguratorSection: CellConfiguratorSection
    private let itemClick: ItemClick
    
    var loadMore: ((_ pageNo: Int) -> (Void))?
    
    var pageNo:Int = 1;
    var enableSwipeToDelete: Bool = false
    var enableMoveRow: Bool = false
    var enableReorderRow: Bool = false
    
    init(models: [[T]],
         reuseIdentifier: String,
         reuseIdentifierSection: String,
         cellConfigurator: @escaping CellConfigurator,
         cellConfiguratorSection: @escaping CellConfiguratorSection,
         itemClick: @escaping ItemClick) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.reuseIdentifierSection = reuseIdentifierSection
        self.cellConfigurator = cellConfigurator
        self.cellConfiguratorSection = cellConfiguratorSection
        self.itemClick = itemClick
    }
    
    func setNewData(model: [[T]]) {
        self.models = model
    }
    
    func resetPageNo() {
        self.pageNo = 1
    }
    
    func setPageNo(page:Int) {
        self.pageNo = page
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let model = models[section]
        return model.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = models[section]
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifierSection)
        
        headerView?.tag = section
        cellConfiguratorSection(model, headerView!)

        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        cell.tag = indexPath.row
        cellConfigurator(model[indexPath.row], cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:UITableViewCell = tableView.cellForRow(at: indexPath) ?? UITableViewCell()
        let model = models[indexPath.section]
        itemClick(model[indexPath.row],indexPath, cell)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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

