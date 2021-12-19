//
//  AIH2008ViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/09.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class AIH2008ViewController: UIViewController {
    
    let appName:AppName = .simpleAIH
    
    @IBOutlet var ANA:UISegmentedControl!
    @IBOutlet var LKM:UISegmentedControl!
    @IBOutlet var SLA:UISegmentedControl!
    @IBOutlet var IgG:UISegmentedControl!
    @IBOutlet var Histol:UISegmentedControl!
    @IBOutlet var Viral:UISegmentedControl!
    @IBOutlet var Tensu:UILabel!
    @IBOutlet var DefiniteDiagnosis:UILabel!
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
    
    func calc(){
        let vANA = ANA.selectedSegmentIndex
        let vLKM = LKM.selectedSegmentIndex * 2
        let vSLA = SLA.selectedSegmentIndex * 2
        var vAutoimmune = vANA + vLKM + vSLA
        if vAutoimmune >= 3 {
            vAutoimmune = 2
        }
        let vIgG = IgG.selectedSegmentIndex
        let vHistol = Histol.selectedSegmentIndex
        let vViral = Viral.selectedSegmentIndex * 2
        let vTensu = vAutoimmune + vIgG + vHistol + vViral
        Tensu.text = "\(vTensu)"
        if vTensu <= 5 {
            DefiniteDiagnosis.text = ""
        }
        if vTensu == 6 {
            DefiniteDiagnosis.text = "Probable"
        }
        if vTensu >= 7 {
            DefiniteDiagnosis.text = "Definite"
        }
        saveString = "\(vTensu)点 \(DefiniteDiagnosis.text!)"
        if ANA.selectedSegmentIndex == 0 {
            detailString = "ANA or SMA <1:40\n"
        }
        if ANA.selectedSegmentIndex == 1 {
            detailString = "ANA or SMA ≧1:40\n"
        }
        if ANA.selectedSegmentIndex == 2 {
            detailString = "ANA or SMA ≧1:80\n"
        }
        if LKM.selectedSegmentIndex == 0 {
            detailString += "anti LKM <1:40\n"
        }
        else {
            detailString += "anti LKM ≧1:40\n"
        }
        if SLA.selectedSegmentIndex == 0 {
            detailString += "anti SLA -\n"
        }
        else {
            detailString += "anti SLA +\n"
        }
        if IgG.selectedSegmentIndex == 0 {
            detailString += "IgG: within normal limit\n"
        }
        if IgG.selectedSegmentIndex == 1 {
            detailString += "IgG: >upper limit\n"
        }
        if IgG.selectedSegmentIndex == 2 {
            detailString += "IgG: >1.1 x upper limit\n"
        }
        if Histol.selectedSegmentIndex == 0 {
            detailString += "histological fiding: not compatible with AIH\n"
        }
        if Histol.selectedSegmentIndex == 1 {
            detailString += "histological fiding: compatible with AIH\n"
        }
        if Histol.selectedSegmentIndex == 2 {
            detailString += "histological fiding: typical AIH\n"
        }
        if Viral.selectedSegmentIndex == 0 {
            detailString += "viral hepatitis +\n\n"
        }
        else {
            detailString += "viral hepatitis -\n\n"
        }
        detailString += "AIH score \(vTensu)点 \(DefiniteDiagnosis.text!)"
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

}//class AIH2008ViewController: UIViewController
