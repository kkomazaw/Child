//
//  PBCViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/10.
//  Copyright © 2019年 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class PBCViewController: UIViewController {
    
    let appName:AppName = .pbc
    
    @IBOutlet var Age:UITextField!
    @IBOutlet var Bil:UITextField!
    @IBOutlet var AlbPBC:UITextField!
    @IBOutlet var PTtime:UITextField!
    @IBOutlet var Edema:UISegmentedControl!
    @IBOutlet var Diuretic:UISegmentedControl!
    @IBOutlet var decimal:UIButton!
    @IBOutlet var RUN:UIButton!
    @IBOutlet var Prob1:UILabel!
    @IBOutlet var Prob2:UILabel!
    @IBOutlet var Prob3:UILabel!
    @IBOutlet var Prob4:UILabel!
    @IBOutlet var Prob5:UILabel!
    @IBOutlet var Prob6:UILabel!
    @IBOutlet var Prob7:UILabel!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = ""
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
        Age.becomeFirstResponder()
    }
    
    func calculate(){
        let vAge = Double(Age.text!) ?? 0.0
        let vBil = Double(Bil.text!) ?? 0.0
        let vAlbPBC = Double(AlbPBC.text!) ?? 0.0
        let vPTtime = Double(PTtime.text!) ?? 0.0
        if vAge * vBil * vAlbPBC * vPTtime == 0 {
            return
        }
        let vEdema = Double(Edema.selectedSegmentIndex)
        let vDiuretic = Double(Diuretic.selectedSegmentIndex)
        let edemascore = (vEdema + vDiuretic) / 2.0
        let riskscore = 0.051 * vAge + 1.209 * log(vBil) + 2.754 * log(vPTtime) - 3.304 * log(vAlbPBC) + 0.675 * edemascore
        let vP03 = Int(round(100.0 * pow(0.996, exp(riskscore - 6.119))))
        let vP06 = Int(round(100.0 * pow(0.992, exp(riskscore - 6.119))))
        let vP09 = Int(round(100.0 * pow(0.991, exp(riskscore - 6.119))))
        let vP12 = Int(round(100.0 * pow(0.989, exp(riskscore - 6.119))))
        let vP15 = Int(round(100.0 * pow(0.986, exp(riskscore - 6.119))))
        let vP18 = Int(round(100.0 * pow(0.98, exp(riskscore - 6.119))))
        let vP24 = Int(round(100.0 * pow(0.978, exp(riskscore - 6.119))))
        Prob1.text = "\(vP03)"
        Prob2.text = "\(vP06)"
        Prob3.text = "\(vP09)"
        Prob4.text = "\(vP12)"
        Prob5.text = "\(vP15)"
        Prob6.text = "\(vP18)"
        Prob7.text = "\(vP24)"
        saveString = "2年生存 \(vP24)%"
        detailString = "年齢 \(Age.text!)歳\n"
        detailString += "Bilirubin \(Bil.text!)mg/dl\n"
        detailString += "Albumin \(AlbPBC.text!)g/dl\n"
        detailString += "PT時間 \(PTtime.text!)sec.\n"
        if Edema.selectedSegmentIndex == 0 {
            detailString += "末梢浮腫なし\n"
        }
        else {
            detailString += "末梢浮腫あり\n"
        }
        if Diuretic.selectedSegmentIndex == 0 {
            detailString += "利尿剤使用なし\n\n"
        }
        else {
            detailString += "利尿剤使用あり\n\n"
        }
        detailString += "**生存確率**\n"
        detailString += " 3ヶ月 \(vP03)%\n"
        detailString += " 6ヶ月 \(vP06)%\n"
        detailString += " 9ヶ月 \(vP09)%\n"
        detailString += "12ヶ月 \(vP12)%\n"
        detailString += "15ヶ月 \(vP15)%\n"
        detailString += "18ヶ月 \(vP18)%\n"
        detailString += "24ヶ月 \(vP24)%"
    }//func calculate()
    
    @IBAction func myActionDecimal(){
        if Age.isEditing{
            if Double(Age.text!) == nil{
                Age.text = "0."
            }
            if Age.text!.range(of: ".") == nil{
                Age.text?.append(".")
            }
        }
        if Bil.isEditing{
            if Double(Bil.text!) == nil{
                Bil.text = "0."
            }
            if Bil.text!.range(of: ".") == nil{
                Bil.text?.append(".")
            }
        }
        if AlbPBC.isEditing{
            if Double(AlbPBC.text!) == nil{
                AlbPBC.text = "0."
            }
            if AlbPBC.text!.range(of: ".") == nil{
                AlbPBC.text?.append(".")
            }
        }
        if PTtime.isEditing{
            if Double(PTtime.text!) == nil{
                PTtime.text = "0."
            }
            if PTtime.text!.range(of: ".") == nil{
                PTtime.text?.append(".")
            }
        }
    }//@IBAction func myActionDecimal()
    
    @IBAction func myActionRUN(){
        view.endEditing(true)
        calculate()
    }
    
    @IBAction func myActionEdema(){
        calculate()
    }
    
    @IBAction func myActionClear(){
        Age.text = ""
        Bil.text = ""
        AlbPBC.text = ""
        PTtime.text = ""
        Prob1.text = ""
        Prob2.text = ""
        Prob3.text = ""
        Prob4.text = ""
        Prob5.text = ""
        Prob6.text = ""
        Prob7.text = ""
        Edema.selectedSegmentIndex = 0
        Diuretic.selectedSegmentIndex = 0
        Age.becomeFirstResponder()
    }//@IBAction func myActionClear()
    
    @IBAction func myActionSave(){
        let titleString = "注釈入力"
        let messageString = "注釈（メモ、名前等）が入力できます\n（日付と2年生存率は自動的に入力されます）"
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
    
}//class PBCViewController: UIViewController
