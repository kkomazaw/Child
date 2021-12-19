//
//  Fib4ViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/04/10.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class Fib4ViewController: UIViewController {
    
    let appName:AppName = .fib
    
    @IBOutlet var Age:UITextField!
    @IBOutlet var AST:UITextField!
    @IBOutlet var ALT:UITextField!
    @IBOutlet var Platelet:UITextField!
    @IBOutlet var Fib4Index:UILabel!
    @IBOutlet var decimalButton:UIButton!
    @IBOutlet var clearButton:UIButton!
    @IBOutlet var RUN:UIButton!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = ""
    var detailString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        Age.becomeFirstResponder()
        Fib4Index.text = ""
        calc()
    }//override func viewDidLoad()
    
    func calc() {
        let vAge = Double(Age.text!) ?? 0.0
        let vAST = Double(AST.text!) ?? 0.0
        let vALT = Double(ALT.text!) ?? 0.0
        let vPlatelet = Double(Platelet.text!) ?? 0.0
        if vAge * vAST * vALT * vPlatelet != 0.0 {
            let vFib4Index = vAge * vAST / (vPlatelet * sqrt(vALT)) * 0.1
            Fib4Index.text = String(format: "%.2f", vFib4Index)
        }//if vAge * vAST * vALT * vPlatelet != 0.0
        saveString = "Fib4: \(Fib4Index.text!)"
        detailString = "年齢 \(Age.text!)歳\n"
        detailString += "AST \(AST.text!) IU/L\n"
        detailString += "ALT \(ALT.text!) IU/L\n"
        detailString += "血小板 \(Platelet.text!)万/μL\n\n"
        detailString += "Fib-4 index \(Fib4Index.text!)"
    }//func calc()
    
    @IBAction func myActionDecimal(){
        if Platelet.isEditing {
            if Double(Platelet.text!) == nil {
                Platelet.text = "0."
            }
            if !(Platelet.text?.contains("."))! {
                Platelet.text?.append(".")
            }
        }//if Platelet.isEditing
    }//@IBAction func myActionDecimal()
    
    @IBAction func myActionClear(){
        Age.text = ""
        AST.text = ""
        ALT.text = ""
        Platelet.text = ""
        Fib4Index.text = ""
        Age.becomeFirstResponder()
        calc()
    }
    
    @IBAction func myActionRUN(){
        calc()
    }//@IBAction func myActionRUN()
    
    @IBAction func myActionSave(){
        guard Fib4Index.text != "" else {
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
    
}//class Fib4ViewController: UIViewController
