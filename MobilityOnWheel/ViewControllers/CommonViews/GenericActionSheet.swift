//
//  GenericActionSheet.swift
//  DrlogyPro
//
//  Created by Arvind Kanjariya on 12/07/19.
//  Copyright © 2019 Arvind Kanjariya. All rights reserved.
//

import UIKit

class GenericActionSheet<T>: NSObject {
    typealias ItemClick = (T, String) -> Void
    var models: [T] = []
    var alert:UIAlertController!
    private let itemClick: ItemClick
    
    init(models: [T], itemClick: @escaping ItemClick) {
        self.models = models
        self.itemClick = itemClick
    }
    
    func showActionSheet(context:UIViewController, title:String, message:String) {
        alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for model in models {
            if model is String {
                alert.addAction(UIAlertAction(title: model as? String, style: .default, handler: doSomething(action:)))
            }
        }
        
		alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
		alert.popoverPresentationController?.sourceView = context.view
		alert.popoverPresentationController?.permittedArrowDirections = []
        context.present(alert, animated: true, completion: nil)
    }
    
    func doSomething(action: UIAlertAction) {
        let index:Int = alert.actions.firstIndex(of: action) ?? 0
        let model = models[index]
        itemClick(model,"")
    }
}
