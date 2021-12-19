//
//  CLIPViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/13.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class CLIPViewController: UIViewController {
    
    let appName:AppName = .clip
    
    @IBOutlet var Tbil:UISegmentedControl!
    @IBOutlet var Alb:UISegmentedControl!
    @IBOutlet var PT:UISegmentedControl!
    @IBOutlet var Ascites:UISegmentedControl!
    @IBOutlet var Encep:UISegmentedControl!
    @IBOutlet var ChildClass:UILabel!
    @IBOutlet var ChildPoint:UILabel!
    @IBOutlet var TumorBurden:UISegmentedControl!
    @IBOutlet var AFP:UISegmentedControl!
    @IBOutlet var PVthrombus:UISegmentedControl!
    @IBOutlet var Cpoint:UILabel!
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
        let vTbil = Tbil.selectedSegmentIndex
        let vAlb = Alb.selectedSegmentIndex
        let vPT = PT.selectedSegmentIndex
        let vAscites = Ascites.selectedSegmentIndex
        let vEncep = Encep.selectedSegmentIndex
        let vChildPoint = 5 + vTbil + vAlb + vPT + vAscites + vEncep
        var Cchildpoint = 0
        if vChildPoint <= 6 {
            ChildClass.text = "A"
        }
        if vChildPoint >= 7 && vChildPoint <= 9 {
            ChildClass.text = "B"
            Cchildpoint = 1
        }
        if vChildPoint >= 10 {
            ChildClass.text = "C"
            Cchildpoint = 2
        }
        ChildPoint.text = "\(vChildPoint)"
        let vTumorBurden = TumorBurden.selectedSegmentIndex
        let vAFP = AFP.selectedSegmentIndex
        let vPVthrombus = PVthrombus.selectedSegmentIndex
        let vCpoint = Cchildpoint + vTumorBurden + vAFP + vPVthrombus
        Cpoint.text = "\(vCpoint)"
        saveString = "CLIP \(vCpoint)"
        detailString = "総ビリルビン(mg/dl) "
        if vTbil == 0 {
            detailString += "<2.0\n"
        }
        if vTbil == 1 {
            detailString += "2.0-3.0\n"
        }
        if vTbil == 2 {
            detailString += ">3.0\n"
        }
        detailString += "アルブミン(g/dl) "
        if vAlb == 0 {
            detailString += ">3.5\n"
        }
        if vAlb == 1 {
            detailString += "2.8-3.5\n"
        }
        if vAlb == 2 {
            detailString += "<2.8\n"
        }
        detailString += "PT(%) "
        if vPT == 0 {
            detailString += ">70\n"
        }
        if vPT == 1 {
            detailString += "40-70\n"
        }
        if vPT == 2 {
            detailString += "<40\n"
        }
        detailString += "腹水 "
        if vAscites == 0 {
            detailString += "なし\n"
        }
        if vAscites == 1 {
            detailString += "少量\n"
        }
        if vAscites == 2 {
            detailString += "中等\n"
        }
        detailString += "脳症 "
        if vEncep == 0 {
            detailString += "なし\n"
        }
        if vEncep == 1 {
            detailString += "軽度\n"
        }
        if vEncep == 2 {
            detailString += "高度\n"
        }
        detailString += "Child \(ChildClass.text!) \(vChildPoint)点\n\n"
        if vTumorBurden == 0 {
            detailString += "単結節かつ占拠部位<50%\n"
        }
        if vTumorBurden == 1 {
            detailString += "多結節かつ占拠部位<50%\n"
        }
        if vTumorBurden == 2 {
            detailString += "塊状型 or 占拠部位>50%\n"
        }
        if vAFP == 0 {
            detailString += "AFP < 400ng/ml\n"
        }
        else {
            detailString += "AFP ≧ 400ng/ml\n"
        }
        if vPVthrombus == 0 {
            detailString += "門脈腫瘍栓なし\n\n"
        }
        else {
            detailString += "門脈腫瘍栓あり\n\n"
        }
        detailString += "CLIP \(vCpoint)点"
    }//func calc()
    
    @IBAction func myActionRUN(){
        calc()
    }//@IBAction func myActionRUN()
    
    @IBAction func myActionReset(){
        Tbil.selectedSegmentIndex = 0
        Alb.selectedSegmentIndex = 0
        PT.selectedSegmentIndex = 0
        Ascites.selectedSegmentIndex = 0
        Encep.selectedSegmentIndex = 0
        ChildClass.text = "A"
        ChildPoint.text = "5"
        TumorBurden.selectedSegmentIndex = 0
        AFP.selectedSegmentIndex = 0
        PVthrombus.selectedSegmentIndex = 0
        Cpoint.text = "0"
        calc()
    }//@IBAction func myActionReset()
    
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
