//
//  ALBIViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/09/10.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class ALBIViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let appName:AppName = .albi
    
    @IBOutlet var PadOrPickerSelector:UISegmentedControl!
    @IBOutlet var Alb:UITextField!
    @IBOutlet var Tbil:UITextField!
    @IBOutlet var ALBIscore:UILabel!
    @IBOutlet var Grade:UILabel!
    @IBOutlet var decimalButton:UIButton!
    @IBOutlet var clearButton:UIButton!
    @IBOutlet var RUN:UIButton!
    @IBOutlet var AlbPicker:UIPickerView!
    @IBOutlet var TbilPicker:UIPickerView!
    @IBOutlet var AlbPickerLabel:UILabel!
    @IBOutlet var TbilPickerLabel:UILabel!
    @IBOutlet var AlbLowerLabel:UILabel!
    @IBOutlet var TbilLowerLabel:UILabel!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = ""
    var detailString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        Alb.becomeFirstResponder()
        ALBIscore.text = ""
        Grade.text = ""
        AlbPickerLabel.text = ""
        TbilPickerLabel.text = ""
        numberPadDisplay()
    }//override func viewDidLoad()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberPadDisplay(){
        Alb.isHidden = false
        Tbil.isHidden = false
        decimalButton.isHidden = false
        clearButton.isHidden = false
        RUN.isHidden = false
        AlbPickerLabel.isHidden = true
        TbilPickerLabel.isHidden = true
        AlbLowerLabel.isHidden = true
        AlbPicker.isHidden = true
        TbilLowerLabel.isHidden = true
        TbilPicker.isHidden = true
    }
    
    func pickerModeDisplay(){
        Alb.isHidden = true
        Tbil.isHidden = true
        decimalButton.isHidden = true
        clearButton.isHidden = true
        RUN.isHidden = true
        AlbPickerLabel.isHidden = false
        TbilPickerLabel.isHidden = false
        AlbLowerLabel.isHidden = false
        AlbPicker.isHidden = false
        TbilLowerLabel.isHidden = false
        TbilPicker.isHidden = false
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var c = 0
        if pickerView.tag == 0 {
            c = 100
        }
        else {
            c = 200
        }
        return c
    }//func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return String(Double(row + 1) / 10.0)
    }
    
    func calc(){
        ALBIscore.text = ""
        Grade.text = ""
        guard let alb = Double(Alb.text!), alb > 0, let tbil = Double(Tbil.text!), tbil > 0 else {
            return
        }
        let albiScore = log10(tbil * 17.1) * 0.66 + alb * 10.0 * (-0.085)
        ALBIscore.text = String(format: "%.2f", albiScore)
        let displayedScore:Double = Double(ALBIscore.text!) ?? 0.0
        var grade = ""
        if displayedScore <= -2.60 {
            grade = "1"
        }
        if displayedScore > -2.60 && displayedScore <= -2.27 {
            grade = "2a"
        }
        if displayedScore > -2.27 && displayedScore <= -1.39 {
            grade = "2b"
        }
        if displayedScore > -1.39 {
            grade = "3"
        }
        Grade.text = "Grade \(grade)"
        saveString = "G\(grade) (\(ALBIscore.text!))"
        detailString = "アルブミン \(Alb.text!) g/dL\n"
        detailString += "総ビリルビン \(Tbil.text!) mg/dL\n\n"
        detailString += "ALBI score \(ALBIscore.text!)\n"
        detailString += "Grade \(grade)"
    }//func calc()
    
    @IBAction func selectorChanged(){
        if PadOrPickerSelector.selectedSegmentIndex == 0 {
            Alb.text = ""
            Tbil.text = ""
            calc()
            numberPadDisplay()
            Alb.becomeFirstResponder()
        }
        else {
            pickerModeDisplay()
            if Alb.text == "" {
                Alb.text = "4.0"
            }
            if Tbil.text == "" {
                Tbil.text = "1.0"
            }
            pickerRowInitiation()
            calc()
            view.endEditing(true)
        }
    }//@IBAction func selectorChanged()
    
    func pickerRowInitiation(){
        var albRow = 0
        var tbilRow = 0
        if let alb = Double(Alb.text!), alb > 0{
            albRow = Int(alb * 10) - 1
        }
        if let tbil = Double(Tbil.text!), tbil > 0{
            tbilRow = Int(tbil * 10) - 1
        }
        if albRow >= 100 || tbilRow >= 200 {
            let titleString = "Picker mode の数値範囲"
            let messageString = "アルブミンは0.1~10.0\n総ビリルビンは0.1~20.0\nの範囲で設定してください。"
            let alert: UIAlertController = UIAlertController(title:titleString,message: messageString,preferredStyle: UIAlertController.Style.alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK",style: UIAlertAction.Style.default,handler:{(action:UIAlertAction!) -> Void in
            })
            alert.addAction(okAction)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }//if albRow >= 100 || tbilRow >= 200
        if albRow >= 100 {
            albRow = 99
            Alb.text = "10"
        }
        if tbilRow >= 200 {
            tbilRow = 199
            Tbil.text = "20"
        }
        AlbPickerLabel.text = Alb.text
        TbilPickerLabel.text = Tbil.text
        view.endEditing(true)
        AlbPicker.selectRow(albRow, inComponent: 0, animated: true)
        TbilPicker.selectRow(tbilRow, inComponent: 0, animated: true)
    }//func pickerRowInitiation()
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            Alb.text = String(Double(row + 1) / 10.0)
            AlbPickerLabel.text = Alb.text
        }
        else {
            Tbil.text = String(Double(row + 1) / 10.0)
            TbilPickerLabel.text = Tbil.text
        }
        calc()
    }//func pickerView(_ pickerView: UIPickerView, didSelectRow
    
    @IBAction func myActionDecimal(){
        if Alb.isEditing {
            if Double(Alb.text!) == nil {
                Alb.text = "0."
            }
            if !(Alb.text?.contains("."))! {
                Alb.text?.append(".")
            }
        }//if Alb.isEditing
        if Tbil.isEditing {
            if Double(Tbil.text!) == nil {
                Tbil.text = "0."
            }
            if !(Tbil.text?.contains("."))! {
                Tbil.text?.append(".")
            }
        }//if Tbil.isEditing
    }//@IBAction func myActionDecimal()
    
    @IBAction func myActionClear(){
        Alb.text = ""
        Tbil.text = ""
        AlbPickerLabel.text = ""
        TbilPickerLabel.text = ""
        ALBIscore.text = ""
        Grade.text = ""
        PadOrPickerSelector.selectedSegmentIndex = 0
        Alb.becomeFirstResponder()
    }//@IBAction func myActionClear()
    
    @IBAction func myActionRUN(){
        calc()
    }//@IBAction func myActionRUN()
    
    @IBAction func myActionSave(){
        guard ALBIscore.text != "", Grade.text != "" else {
            return
        }
        let titleString = "注釈入力"
        let messageString = "注釈（メモ、名前等）が入力できます\n（日付と点数は自動的に入力されます）"
        let alert = UIAlertController(title:titleString, message: messageString, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "入力完了", style: UIAlertAction.Style.default, handler:{(action:UIAlertAction!) -> Void in
            let textField = alert.textFields![0]
            let childData = ChildData(context: self.myContext)
            childData.title = self.appName.rawValue
            childData.date = Date()
            childData.memo = textField.text
            childData.value = self.saveString
            childData.detailValue = self.detailString
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let id = self.appName.rawValue + "Save"
            self.performSegue(withIdentifier: id, sender: true)
        })//let okAction = UIAlertAction
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{(action:UIAlertAction!) -> Void in
        })//let cancelAction = UIAlertAction
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        // UIAlertControllerにtextFieldを追加
        alert.addTextField { (textField:UITextField!) -> Void in }
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }//@IBAction func myActionSave()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sendText = segue.destination as! SaveViewController
        sendText.myText = appName.rawValue
    }//override func prepare(for segue
    
}//class ALBIViewController: UIViewController
