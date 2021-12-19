//
//  JISViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/10.
//  Copyright © 2019年 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class JISViewController: UIViewController {
    
    let appName:AppName = .jis
    
    @IBOutlet var Tbil:UISegmentedControl!
    @IBOutlet var Alb:UISegmentedControl!
    @IBOutlet var PT:UISegmentedControl!
    @IBOutlet var Ascites:UISegmentedControl!
    @IBOutlet var Encep:UISegmentedControl!
    @IBOutlet var ChildClass:UILabel!
    @IBOutlet var ChildPoint:UILabel!
    @IBOutlet var kazu:UISegmentedControl!
    @IBOutlet var ookisa:UISegmentedControl!
    @IBOutlet var shinshu:UISegmentedControl!
    @IBOutlet var rinpa:UISegmentedControl!
    @IBOutlet var enkaku:UISegmentedControl!
    @IBOutlet var tnmLabel:UILabel!
    @IBOutlet var stageLabel:UILabel!
    @IBOutlet var Jpoint:UILabel!
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
        let vTbil = Tbil.selectedSegmentIndex
        let vAlb = Alb.selectedSegmentIndex
        let vPT = PT.selectedSegmentIndex
        let vAscites = Ascites.selectedSegmentIndex
        let vEncep = Encep.selectedSegmentIndex
        let vChildPoint = vTbil + vAlb + vPT + vAscites + vEncep + 5
        ChildPoint.text = "\(vChildPoint)"
        ChildClass.text = "A"
        var vJchildPoint = 0
        if vChildPoint >= 7 && vChildPoint <= 9 {
            ChildClass.text = "B"
            vJchildPoint = 1
        }
        if vChildPoint >= 10 {
            ChildClass.text = "C"
            vJchildPoint = 2
        }
        let ka = kazu.selectedSegmentIndex
        let oo = ookisa.selectedSegmentIndex
        let sh = shinshu.selectedSegmentIndex
        let vT = ka + oo + sh + 1
        let vN = rinpa.selectedSegmentIndex
        let vM = enkaku.selectedSegmentIndex
        tnmLabel.text = "T\(vT) N\(vN) M\(vM)"
        var vStagePoint = 0
        if vT == 1 && vN == 0 && vM == 0 {
            stageLabel.text = "Stage I"
            vStagePoint = 0
        }
        if vT == 2 && vN == 0 && vM == 0 {
            stageLabel.text = "Stage II"
            vStagePoint = 1
        }
        if vT == 3 && vN == 0 && vM == 0 {
            stageLabel.text = "Stage III"
            vStagePoint = 2
        }
        if vT == 4 && vN == 0 && vM == 0 {
            stageLabel.text = "Stage IV A"
            vStagePoint = 3
        }
        if vN == 1 && vM == 0 {
            stageLabel.text = "Stage IV A"
            vStagePoint = 3
        }
        if vM == 1 {
            stageLabel.text = "Stage IV B"
            vStagePoint = 3
        }
        let vJpoint = vJchildPoint + vStagePoint
        Jpoint.text = "\(vJpoint)"
        saveString = "JIS \(vJpoint)"
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
        if ka == 0 {
            detailString += "腫瘍数：単発\n"
        }
        else {
            detailString += "腫瘍数：多発\n"
        }
        if oo == 0 {
            detailString += "大きさ ≦2cm\n"
        }
        else {
            detailString += "大きさ >2cm\n"
        }
        if vN == 0 {
            detailString += "リンパ節転移：なし\n"
        }
        else {
            detailString += "リンパ節転移：あり\n"
        }
        if vM == 0 {
            detailString += "遠隔転移なし\n"
        }
        else {
            detailString += "遠隔転移あり\n"
        }
        detailString += "\(tnmLabel.text!) \(stageLabel.text!)\n\n"
        detailString += "JIS score \(vJpoint)点"
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
        kazu.selectedSegmentIndex = 0
        ookisa.selectedSegmentIndex = 0
        shinshu.selectedSegmentIndex = 0
        rinpa.selectedSegmentIndex = 0
        enkaku.selectedSegmentIndex = 0
        tnmLabel.text = "T1 N0 M0"
        stageLabel.text = "Stage I"
        Jpoint.text = "0"
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
    
}//class JISViewController: UIViewController
