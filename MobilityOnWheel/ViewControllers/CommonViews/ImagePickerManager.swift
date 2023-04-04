//
//  ImagePickerManager.swift
//  DrlogyPro
//
//  Created by Arvind Kanjariya on 05/07/19.
//  Copyright © 2019 Arvind Kanjariya. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
   
    var picker = UIImagePickerController();
	var alert = UIAlertController(title: "Choose", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    var pickDocumentCallback : ((URL) -> ())?;
    var isVideoSelect: Bool = false
    override init(){
        super.init()
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
		let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
		let gallaryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
		alert.popoverPresentationController?.permittedArrowDirections = []
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func pickImageAndVideo(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ()), _ callbackDocument: @escaping ((URL) -> ())) {
        pickImageCallback = callback;
        pickDocumentCallback = callbackDocument
        self.viewController = viewController;
        
		let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
		let gallaryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
		let videoAction = UIAlertAction(title: "Video", style: .default){
            UIAlertAction in
            self.openVideoGallery()
        }
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(videoAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
		alert.popoverPresentationController?.permittedArrowDirections = []
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    func pickImageAndDocument(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ()), _ callbackDocument: @escaping ((URL) -> ())) {
        pickImageCallback = callback;
        pickDocumentCallback = callbackDocument
        self.viewController = viewController
        
		let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
		let gallaryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
		let documetnAction = UIAlertAction(title: "Document", style: .default){
            UIAlertAction in
            self.openDocument()
        }
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(documetnAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
		alert.popoverPresentationController?.permittedArrowDirections = []
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            // Show alert for no camera
//            Utility.ShowErrorAlert(self.viewController!, "Warning", "OK", "You don't have camera")
        }
    }
    
    
    
    
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    func openVideoGallery(){
        self.isVideoSelect = true
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    func openDocument(){
        alert.dismiss(animated: true, completion: nil)
        let types = [kUTTypePDF]
        let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)

//        if #available(iOS 11.0, *) {
//            importMenu.allowsMultipleSelection = true
//        }

        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.viewController!.present(importMenu, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        pickDocumentCallback?(urls[0])
        controller.dismiss(animated: true, completion: nil)
    }

     func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //  // For Swift 4.2
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if isVideoSelect {
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL]as? NSURL
            print(videoURL!)
            pickDocumentCallback?(videoURL! as URL)
        } else {
            guard let image = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
              }
            pickImageCallback?(image)
        }
            
        picker.dismiss(animated: true, completion: nil)
      }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
}
