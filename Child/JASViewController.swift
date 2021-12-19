//
//  JASViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/04/04.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class JASViewController: UIViewController {
    
    let appName:AppName = .jas
    
    @IBOutlet var WBC:UISegmentedControl!
    @IBOutlet var Cre:UISegmentedControl!
    @IBOutlet var PTinr:UISegmentedControl!
    @IBOutlet var TB:UISegmentedControl!
    @IBOutlet var GIDIC:UISegmentedControl!
    @IBOutlet var AgeYear:UISegmentedControl!
    @IBOutlet var JASscore:UILabel!
    @IBOutlet var JASgrade:UILabel!
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
    }
    
    func calc() {
        let vWBC = WBC.selectedSegmentIndex + 1
        let vCre = Cre.selectedSegmentIndex + 1
        let vPTinr = PTinr.selectedSegmentIndex + 1
        let vTB = TB.selectedSegmentIndex + 1
        let vGIDIC = GIDIC.selectedSegmentIndex + 1
        let vAgeYear = AgeYear.selectedSegmentIndex + 1
        let vJASscore = vWBC + vCre + vPTinr + vTB + vGIDIC + vAgeYear
        JASscore.text = "\(vJASscore)"
        if vJASscore <= 7 {
            JASgrade.text = "mild"
        }
        if vJASscore == 8 || vJASscore == 9 {
            JASgrade.text = "moderate"
        }
        if vJASscore >= 10 {
            JASgrade.text = "severe"
        }
        saveString = "\(JASgrade.text!)(\(vJASscore))"
        if vWBC == 1 {
            detailString = "WBC <10,000/μL\n"
        }
        if vWBC == 2 {
            detailString = "WBC ≧10,000/μL ~ <20,000/μL\n"
        }
        if vWBC == 3 {
            detailString = "WBC ≧20,000/μL\n"
        }
        if vCre == 1 {
            detailString += "Cre ≦1.5mg/dl\n"
        }
        if vCre == 2 {
            detailString += "Cre >1.5mg/dl ~ <3mg/dl\n"
        }
        if vCre == 3 {
            detailString += "Cre ≧3mg/dl\n"
        }
        if vPTinr == 1 {
            detailString += "INR ≦1.8 or PT ≧40%\n"
        }
        if vPTinr == 2 {
            detailString += "INR >1.8 ~ <2 or PT >30% ~ <40%\n"
        }
        if vPTinr == 3 {
            detailString += "INR ≧2 or PT ≦30%\n"
        }
        if vTB == 1 {
            detailString += "TB <5mg/dl\n"
        }
        if vTB == 2 {
            detailString += "TB ≧5mg/dl ~ <10mg/dl\n"
        }
        if vTB == 3 {
            detailString += "TB ≧10mg/dl\n"
        }
        if vGIDIC == 1 {
            detailString += "GI bleeding or DIC: -\n"
        }
        if vGIDIC == 2 {
            detailString += "GI bleeding or DIC: +\n"
        }
        if vAgeYear == 1 {
            detailString += "Age <50y/o\n\n"
        }
        if vAgeYear == 2 {
            detailString += "Age ≧50y/o\n\n"
        }
        detailString += "JAS score \(vJASscore) \(JASgrade.text!)"
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
    
}//class JASViewController: UIViewController
