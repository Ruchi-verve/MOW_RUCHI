//
//  LocationCell.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 16/08/21.
//

import UIKit



protocol saveUserData:AnyObject     {
    func getAllUserData(billAdd:String,City:String,isSelect:Int,State:String,stateId:Int,customeNo:String,zip:String)
}


class LocationCell: UITableViewCell,UITextFieldDelegate,CommonPickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var btnRadio:UIButton!
    @IBOutlet weak var lblLocName:UILabel!
    @IBOutlet weak var btnInfo:UIButton!
    @IBOutlet weak var imgInfo:UIImageView!

    @IBOutlet weak var txtBillingAdd: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCity: SkyFloatingLabelTextField!
    @IBOutlet weak var txtState: SkyFloatingLabelTextField!
    @IBOutlet weak var txtZip: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAppartment: SkyFloatingLabelTextField!
    @IBOutlet weak var txtContactNo: SkyFloatingLabelTextField!

    @IBOutlet weak var btnCheckbox: UIButton!
    
    var isCome = String()
    weak var setDelegate: saveUserData?
    var dictSetData = CustomerAdressModel()
    var arrState = [StateSubListModel]()
    fileprivate let pickerState = CommonPicker()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnInfo.isHidden = true
        self.imgInfo.isHidden = true
        
        pickerState.delegate = self
        pickerState.dataSource = self
        self.pickerState.toolbarDelegate = self
        txtState.inputView = pickerState
        txtState.inputAccessoryView = self.pickerState.toolbar
        self.pickerState.selectRow(0, inComponent: 0, animated: false)

    }
    func didTapDone() {}

    @IBAction func btnTapped(_ sender:UIButton) {
        btnCheckbox.isSelected = !btnCheckbox.isSelected
        if btnCheckbox.isSelected == false {
            txtCity.text = ""
              txtZip.text = ""
              txtState.text = ""
              txtAppartment.text = ""
            txtContactNo.text = ""
            txtBillingAdd.text = ""
        } else {
            btnCheckbox.isSelected = true
            txtCity.text = dictSetData.billCity
              txtZip.text = dictSetData.billZip
            if dictSetData.billStateId != 0  {
                txtState.text = dictSetData.stateName
            } else {
                txtState.text = dictSetData.otherBillStateName
            }
           let filteredArr = arrState.filter{ $0.stateName == txtState.text}
            APP_DELEGATE.otherStateId = filteredArr[0].id
              txtAppartment.text = dictSetData.billAddress2
           txtContactNo.text = dictSetData.notes
              txtBillingAdd.text = dictSetData.billAddress1
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isCome == "yes" {
            self.btnInfo.isHidden = false
            self.imgInfo.isHidden = false
        }else {
            self.btnInfo.isHidden = true
            self.imgInfo.isHidden = true
        }
    }
    
    //MARK:- Pickerview Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return arrState.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return arrState[row].stateName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtState.text = arrState[row].stateName
        APP_DELEGATE.otherStateId = arrState[row].id
        txtState.endEditing(true)
    }

}

