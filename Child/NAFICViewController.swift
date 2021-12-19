//
//  NAFICViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/04/11.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class NAFICViewController: UIViewController {
    
    let appName:AppName = .nafic
    
    @IBOutlet var Ferritin:UISegmentedControl!
    @IBOutlet var Insulin:UISegmentedControl!
    @IBOutlet var Collagen:UISegmentedControl!
    @IBOutlet var NAFICscore:UILabel!
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
        calc()
    }//override func viewDidLoad()
    
    func calc() {
        let vFerritin = Ferritin.selectedSegmentIndex
        let vInsulin = Insulin.selectedSegmentIndex
        let vCollagen = Collagen.selectedSegmentIndex * 2
        let vNAFICscore = vFerritin + vInsulin+vCollagen
        NAFICscore.text = "\(vNAFICscore)"
        saveString = "NAFIC \(vNAFICscore)"
        detailString = "ferritin ≧200ng/ml (female) or ≧300ng/ml (male): "
        if vFerritin == 0 {
            detailString += "-\n"
        }
        else {
            detailString += "+\n"
        }
        detailString += "fasting insulin ≧10μU/ml: "
        if vInsulin == 0 {
            detailString += "-\n"
        }
        else {
            detailString += "+\n"
        }
        detailString += "type IV collagen 7S ≧5.0ng/ml: "
        if vCollagen == 0 {
            detailString += "-\n\n"
        }
        else {
            detailString += "+\n\n"
        }
        detailString += "NAFIC score \(vNAFICscore)"
    }//func calc()
    
    @IBAction func myActionRUN(){
        calc()
    }//@IBAction func myActionRUN()
    
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
    
}//class NAFICViewController: UIViewController
