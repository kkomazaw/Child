//
//  MELDViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/06.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class MELDViewController: UIViewController {
    
    let appName:AppName = .meld
    
    @IBOutlet var Tbil:UITextField!
    @IBOutlet var PTINR:UITextField!
    @IBOutlet var Cre:UITextField!
    @IBOutlet var Alcohol:UISegmentedControl!
    @IBOutlet var Dialysis:UISegmentedControl!
    @IBOutlet var Na:UITextField!
    @IBOutlet var MELDScore:UILabel!
    @IBOutlet var MELDNaScore:UILabel!
    @IBOutlet var decimalButton:UIButton!
    @IBOutlet var RUNButton:UIButton!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = "MELD 6"
    var detailString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        if height > 800.0 && height < 1000.0{
            myToolBar.frame = CGRect(x: 0, y: height * 0.92, width: width, height: height * 0.055)
        }
        if height > 1000.0 {
            myToolBar.frame = CGRect(x: 0, y: height * 0.94, width: width, height: height * 0.05)
        }
        Tbil.becomeFirstResponder()
    }
    
    func calculation(){
        var vTbil = Double(Tbil.text!) ?? 0.0
        if vTbil < 1.0{
            vTbil = 1.0
            Tbil.text = "1.0"
        }
        var vPTINR = Double(PTINR.text!) ?? 0.0
        if vPTINR < 1.0{
            vPTINR = 1.0
            PTINR.text = "1.0"
        }
        var vCre = Double(Cre.text!) ?? 0.0
        if vCre < 1.0{
            vCre = 1.0
            Cre.text = "1.0"
        }
        if vCre > 4.0 {
            vCre = 4.0
            Cre.text = "4.0"
        }
        let vAlcohol = Double(Alcohol.selectedSegmentIndex)
        if Dialysis.selectedSegmentIndex == 1 {
            vCre = 4.0
            Cre.text = "4.0"
        }
        var vNa = 140.0
        if let i = Double(Na.text!){
            vNa = i
        }
        let vMELD = 3.78 * log(vTbil) + 11.2 * log(vPTINR) + 9.57 * log(vCre) + 6.43 * (1.0 - vAlcohol)
        let roundedMELD = Int(round(vMELD))
        MELDScore.text = String(roundedMELD)
        if let i = Na.text, !i.isEmpty {
            let vMELDNa = vMELD - vNa - (0.025 * vMELD * (140.0 - vNa)) + 140.0
            let roundedMELDNa = Int(round(vMELDNa))
            MELDNaScore.text = String(roundedMELDNa)
        }
        else{
            MELDNaScore.text = "––"
        }
        //saveStringはSaveViewControllerのtableで表示される
        //detailStringはSaveDetailViewControllerのtextViewで表示される
        saveString = "MELD " + MELDScore.text!
        detailString = "T-bil: \(vTbil) mg/dl\n"
        detailString += "PT-INR: \(vPTINR)\n"
        detailString += "Cre: \(vCre) mg/dl\n"
        if Alcohol.selectedSegmentIndex == 0 {
            detailString += "アルコール性肝疾患または胆汁うっ滞性肝疾患：いいえ\n"
        }
        else {
            detailString += "アルコール性肝疾患または胆汁うっ滞性肝疾患：はい\n"
        }
        if Dialysis.selectedSegmentIndex == 0 {
            detailString += "週2回以上の透析：いいえ\n"
        }
        else {
            detailString += "週2回以上の透析：はい\n"
        }
        if MELDNaScore.text != "––" {
            detailString += "Na " + Na.text! + " mEq/L\n"
        }
        detailString += "\n" + saveString
        if MELDNaScore.text != "––" {
            detailString += "\nMELD-Na \(MELDNaScore.text!)"
        }
    }//func calculation()
    
    @IBAction func decimalButtonTapped(){
        if Tbil.isEditing{
            if Double(Tbil.text!) == nil{
                Tbil.text = "0."
            }
            if Tbil.text!.range(of: ".") == nil{
                Tbil.text?.append(".")
            }
        }
        if PTINR.isEditing{
            if Double(PTINR.text!) == nil{
                PTINR.text = "0."
            }
            if PTINR.text!.range(of: ".") == nil{
                PTINR.text?.append(".")
            }
        }
        if Cre.isEditing{
            if Double(Cre.text!) == nil{
                Cre.text = "0."
            }
            if Cre.text!.range(of: ".") == nil{
                Cre.text?.append(".")
            }
        }
        if Na.isEditing{
            if Double(Na.text!) == nil{
                Na.text = "0."
            }
            if Na.text!.range(of: ".") == nil{
                Na.text?.append(".")
            }
        }
    }//@IBAction func decimalButtonTapped()
    
    @IBAction func RUNButtonTapped(){
        view.endEditing(true)
        calculation()
    }
    
    @IBAction func clearButtonTapped(){
        Tbil.text = ""
        PTINR.text = ""
        Cre.text = ""
        Alcohol.selectedSegmentIndex = 0
        Dialysis.selectedSegmentIndex = 0
        Na.text = ""
        MELDScore.text = ""
        MELDNaScore.text = ""
        Tbil.becomeFirstResponder()
    }
    
    @IBAction func myActionSave(){
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
    
}
