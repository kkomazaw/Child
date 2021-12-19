//
//  BCLCViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/04/11.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class BCLCViewController: UIViewController {
    
    let appName:AppName = .bclc
    
    @IBOutlet var Alb: UISegmentedControl!
    @IBOutlet var Ascites: UISegmentedControl!
    @IBOutlet var ChildClass: UILabel!
    @IBOutlet var ChildPoint: UILabel!
    @IBOutlet var Encep: UISegmentedControl!
    @IBOutlet var PT: UISegmentedControl!
    @IBOutlet var Tbil: UISegmentedControl!
    @IBOutlet var Shuyoinshi: UISegmentedControl!
    @IBOutlet var Monmyakuatsu: UISegmentedControl!
    @IBOutlet var Gappeisho: UISegmentedControl!
    @IBOutlet var Performance: UISegmentedControl!
    @IBOutlet var BCLCstage: UILabel!
    @IBOutlet var LabelShuyoinshi: UILabel!
    @IBOutlet var LabelPI: UILabel!
    @IBOutlet var LabelMonmyakuatsu: UILabel!
    @IBOutlet var LabelGappeisho: UILabel!
    @IBOutlet var LabelEndstage: UILabel!
    @IBOutlet var LabelAdvanced: UILabel!
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
    
    func showInitialLabels(){
        LabelShuyoinshi.isHidden = false
        LabelPI.isHidden = false
        Shuyoinshi.isHidden = false
        LabelMonmyakuatsu.isHidden = false
        Monmyakuatsu.isHidden = false
        LabelGappeisho.isHidden = true
        Gappeisho.isHidden = true
        LabelEndstage.isHidden = true
        LabelAdvanced.text = ""
    }
    
    func calc() {
        showInitialLabels()
        let vPerformance = Performance.selectedSegmentIndex
        if vPerformance == 0 {
            detailString = "performance status: 0\n\n"
        }
        if vPerformance == 1 {
            detailString = "performance status: 1-2\n\n"
        }
        if vPerformance == 2 {
            detailString = "performance status: 3-4\n\n"
        }
        let vTbil = Tbil.selectedSegmentIndex
        let vAlb = Alb.selectedSegmentIndex
        let vPT = PT.selectedSegmentIndex
        let vAscites = Ascites.selectedSegmentIndex
        let vEncep = Encep.selectedSegmentIndex
        let vChildPoint = vTbil + vAlb + vPT + vAscites + vEncep + 5
        ChildPoint.text = "\(vChildPoint)"
        if vChildPoint <= 6 {
            ChildClass.text = "A"
        }
        if vChildPoint >= 7 && vChildPoint <= 9 {
            ChildClass.text = "B"
        }
        if vChildPoint >= 10 {
            ChildClass.text = "C"
        }
        detailString += "総ビリルビン(mg/dl) "
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
        if vChildPoint >= 10 || vPerformance == 2 {
            LabelShuyoinshi.isHidden = true
            LabelPI.isHidden = true
            Shuyoinshi.isHidden = true
            LabelMonmyakuatsu.isHidden = true
            Monmyakuatsu.isHidden = true
            LabelGappeisho.isHidden = true
            Gappeisho.isHidden = true
            LabelEndstage.isHidden = false
            saveString = "Stage D"
            detailString += "End stage (D) 症状緩和医療"
        }//if vChildPoint >= 10 || vPerformance == 2
        else{
            LabelShuyoinshi.isHidden = false
            LabelPI.isHidden = false
            Shuyoinshi.isHidden = false
            LabelMonmyakuatsu.isHidden = false
            Monmyakuatsu.isHidden = false
            LabelGappeisho.isHidden = false
            Gappeisho.isHidden = false
            LabelEndstage.isHidden = true
        }//else
        let vShuyoinshi = Shuyoinshi.selectedSegmentIndex
        let vMonmyakuatsu = Monmyakuatsu.selectedSegmentIndex
        if vMonmyakuatsu == 1 || vShuyoinshi == 2 {
            LabelGappeisho.isHidden = false
            Gappeisho.isHidden = false
        }//if vMonmyakuatsu == 1 || vShuyoinshi == 2
        else{
            LabelGappeisho.isHidden = true
            Gappeisho.isHidden = true
        }//else
        let vGappeisho = Gappeisho.selectedSegmentIndex
        if vPerformance == 2 || vChildPoint >= 10 {
            BCLCstage.text = ""
            LabelGappeisho.isHidden = true
            Gappeisho.isHidden = true
        }//if vPerformance == 2 || vChildPoint >= 10
        else if vShuyoinshi == 4 || vPerformance == 1 {
            
            if vChildPoint >= 7 && vChildPoint <= 9 {
                LabelAdvanced.text = "Advanced stage (C) ※ソラフェニブ"
                BCLCstage.text = "※Child Bではベネフィットとリスクから慎重に可否を検討"
                saveString = "Stage C"
                detailString += "Advanced stage (C) ※ソラフェニブ\n※Child Bではベネフィットとリスクから慎重に可否を検討"
            }
            else{
                LabelAdvanced.text = "Advanced stage (C) ソラフェニブ"
                BCLCstage.text = ""
                saveString = "Stage C"
                detailString += "Advanced stage (C) ソラフェニブ"
            }
            LabelMonmyakuatsu.isHidden = true
            Monmyakuatsu.isHidden = true
            LabelGappeisho.isHidden = true
            Gappeisho.isHidden = true
            if vPerformance == 1 {
                LabelShuyoinshi.isHidden = true
                LabelPI.isHidden = true
                Shuyoinshi.isHidden = true
            }//if vPerformance == 1)
        }//else if vShuyoinshi == 4 || vPerformance == 1
        else if vShuyoinshi == 3 {
            LabelMonmyakuatsu.isHidden = true
            Monmyakuatsu.isHidden = true
            LabelGappeisho.isHidden = true
            Gappeisho.isHidden = true
            LabelAdvanced.text = "Intermediate stage (B) TACE"
            BCLCstage.text = ""
            saveString = "Stage B"
            detailString += "腫瘍因子：多発\n\n"
            detailString += "Intermediate stage (B) TACE"
        }//else if vShuyoinshi == 3
        else if vShuyoinshi >= 1 || vChildPoint >= 7 {
            if vShuyoinshi <= 1 && vMonmyakuatsu == 0 {
                BCLCstage.text = "Early stage (A) 肝切除術"
                saveString = "Stage A"
                if vShuyoinshi == 0 {
                    detailString += "腫瘍因子：<2cm 単発\n"
                }//if vShuyoinshi == 0
                if vShuyoinshi == 1 {
                    detailString += "腫瘍因子：≧2cm, ≦3cm 単発\n"
                }//if vShuyoinshi == 1
                detailString += "門脈圧亢進やビリルビン上昇：なし\n\n"
                detailString += "Early stage (A) 肝切除術"
            }//if vShuyoinshi <= 1 && vMonmyakuatsu == 0
            if vShuyoinshi <= 1 && vMonmyakuatsu == 1 && vGappeisho == 0 {
                BCLCstage.text = "Early stage (A) 肝移植"
                saveString = "Stage A"
                if vShuyoinshi == 0 {
                    detailString += "腫瘍因子：<2cm 単発\n"
                }//if vShuyoinshi == 0
                if vShuyoinshi == 1 {
                    detailString += "腫瘍因子：≧2cm, ≦3cm 単発\n"
                }//if vShuyoinshi == 1
                detailString += "門脈圧亢進やビリルビン上昇：あり\n"
                detailString += "合併症：なし\n\n"
                detailString += "Early stage (A) 肝移植"
            }//if vShuyoinshi <= 1 && vMonmyakuatsu == 1 && vGappeisho == 0
            if vShuyoinshi <= 1 && vMonmyakuatsu == 1 && vGappeisho == 1 {
                BCLCstage.text = "Early stage (A) PEI/RFA"
                saveString = "Stage A"
                if vShuyoinshi == 0 {
                    detailString += "腫瘍因子：<2cm 単発\n"
                }//if vShuyoinshi == 0
                if vShuyoinshi == 1 {
                    detailString += "腫瘍因子：≧2cm, ≦3cm 単発\n"
                }//if vShuyoinshi == 1
                detailString += "門脈圧亢進やビリルビン上昇：あり\n"
                detailString += "合併症：あり\n\n"
                detailString += "Early stage (A) PEI/RFA"
            }//if vShuyoinshi <= 1 && vMonmyakuatsu == 1 && vGappeisho == 1
            if vShuyoinshi == 2 && vGappeisho == 0 {
                BCLCstage.text = "Early stage (A) 肝移植"
                saveString = "Stage A"
                detailString += "腫瘍因子：<3cm, 3個以内\n"
                if vMonmyakuatsu == 0 {
                    detailString += "門脈圧亢進やビリルビン上昇：なし\n"
                }//if vShuyoinshi == 0
                if vMonmyakuatsu == 1 {
                    detailString += "門脈圧亢進やビリルビン上昇：あり\n"
                }
                detailString += "合併症：なし\n\n"
                detailString += "Early stage (A) 肝移植"
            }//if vShuyoinshi == 2 && vGappeisho == 0
            if vShuyoinshi == 2 && vGappeisho == 1 {
                BCLCstage.text = "Early stage (A) PEI/RFA"
                saveString = "Stage A"
                detailString += "腫瘍因子：<3cm, 3個以内\n"
                if vMonmyakuatsu == 0 {
                    detailString += "門脈圧亢進やビリルビン上昇：なし\n"
                }//if vShuyoinshi == 0
                if vMonmyakuatsu == 1 {
                    detailString += "門脈圧亢進やビリルビン上昇：あり\n"
                }
                detailString += "合併症：あり\n\n"
                detailString += "Early stage (A) PEI/RFA"
            }//if vShuyoinshi == 2 && vGappeisho == 1
        }//else if vShuyoinshi >= 1 || vChildPoint >= 7
        else {
            if vMonmyakuatsu == 0 {
                BCLCstage.text = "Very early stage (0) 肝切除術"
                saveString = "Stage 0"
                detailString += "腫瘍因子：<2cm 単発\n"
                detailString += "門脈圧亢進やビリルビン上昇：なし\n\n"
                detailString += "Very early stage (0) 肝切除術"
            }//if vMonmyakuatsu == 0
            if vMonmyakuatsu == 1 && vGappeisho == 0 {
                BCLCstage.text = "Very early stage (0) 肝移植"
                saveString = "Stage 0"
                detailString += "腫瘍因子：<2cm 単発\n"
                detailString += "門脈圧亢進やビリルビン上昇：あり\n"
                detailString += "合併症：なし\n\n"
                detailString += "Very early stage (0) 肝移植"
            }//if vMonmyakuatsu == 1 && vGappeisho == 0
            if vMonmyakuatsu == 1 && vGappeisho == 1 {
                BCLCstage.text = "Very early stage (0) PEI/RFA"
                saveString = "Stage 0"
                detailString += "腫瘍因子：<2cm 単発\n"
                detailString += "門脈圧亢進やビリルビン上昇：あり\n"
                detailString += "合併症：あり\n\n"
                detailString += "Very early stage (0) PEI/RFA"
            }//if vMonmyakuatsu == 1 && vGappeisho == 1
        }//else
    }//func calc()
    
    @IBAction func myActionRUN(){
        calc()
    }//@IBAction func myActionRUN()
    
    @IBAction func myActionClear(){
        Performance.selectedSegmentIndex = 0
        Tbil.selectedSegmentIndex = 0
        Alb.selectedSegmentIndex = 0
        PT.selectedSegmentIndex = 0
        Ascites.selectedSegmentIndex = 0
        Encep.selectedSegmentIndex = 0
        Shuyoinshi.selectedSegmentIndex = 0
        Monmyakuatsu.selectedSegmentIndex = 0
        Gappeisho.selectedSegmentIndex = 0
        ChildClass.text = "A"
        ChildPoint.text = "5"
        BCLCstage.text = "Very early stage (0) 肝切除術"
        showInitialLabels()
        calc()
    }//@IBAction func myActionClear()
    
    @IBAction func myActionSave(){
        let titleString = "注釈入力"
        let messageString = "注釈（メモ、名前等）が入力できます\n（日付とstageは自動的に入力されます）"
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

}//class BCLCViewController: UIViewController
