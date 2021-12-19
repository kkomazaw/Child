//
//  HCCAlgoViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/06/16.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class HCCAlgoViewController: UIViewController {
    
    let appName:AppName = .hccalgo
    
    @IBOutlet var Tbil: UISegmentedControl!
    @IBOutlet var Alb: UISegmentedControl!
    @IBOutlet var PT: UISegmentedControl!
    @IBOutlet var Ascites: UISegmentedControl!
    @IBOutlet var Encep: UISegmentedControl!
    @IBOutlet var ChildClass: UILabel!
    @IBOutlet var ChildPoint: UILabel!
    @IBOutlet var KangaiTeni:UISegmentedControl!
    @IBOutlet var MyakkanSinshu:UISegmentedControl!
    @IBOutlet var Shuyousu:UISegmentedControl!
    @IBOutlet var Shuyoukei:UISegmentedControl!
    @IBOutlet var TumorNumber:UISegmentedControl!
    @IBOutlet var TumorSize:UISegmentedControl!
    @IBOutlet var Metastasis:UISegmentedControl!
    @IBOutlet var VascularInvasion:UISegmentedControl!
    @IBOutlet var TiryohoLabel:UILabel!
    @IBOutlet var KaisetsuLabel:UILabel!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = ""
    var detailString = ""
    
    func calc() {
        hideMilan()
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
            showMilan()
        }
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
        if KangaiTeni.selectedSegmentIndex == 0 && vChildPoint <= 9 {
            if MyakkanSinshu.selectedSegmentIndex == 0 {
                if Shuyousu.selectedSegmentIndex == 0 {
                    if Shuyoukei.selectedSegmentIndex == 0 {
                        TiryohoLabel.text = "切除\n焼灼"
                        KaisetsuLabel.text = "*1 肝切除の場合は肝障害度による評価を推奨\n*2 腫瘍数1個なら①切除、②焼灼"
                        saveString = "切除•焼灼"
                        detailString += "肝外転移：なし\n"
                        detailString += "脈管侵襲：なし\n"
                        detailString += "腫瘍数：1~3個\n"
                        detailString += "腫瘍径：3cm以内\n\n"
                        detailString += "治療法\n切除\n焼灼\n"
                        detailString += "*1 肝切除の場合は肝障害度による評価を推奨\n*2 腫瘍数1個なら①切除、②焼灼"
                    }//if Shuyoukei.selectedSegmentIndex == 0
                    if Shuyoukei.selectedSegmentIndex == 1 {
                        TiryohoLabel.text = "切除\n塞栓"
                        KaisetsuLabel.text = "*1 肝切除の場合は肝障害度による評価を推奨"
                        saveString = "切除•塞栓"
                        detailString += "肝外転移：なし\n"
                        detailString += "脈管侵襲：なし\n"
                        detailString += "腫瘍数：1~3個\n"
                        detailString += "腫瘍径：3cm超\n\n"
                        detailString += "治療法\n切除\n塞栓\n"
                        detailString += "*1 肝切除の場合は肝障害度による評価を推奨"
                    }//if Shuyoukei.selectedSegmentIndex == 1
                }//if Shuyousu.selectedSegmentIndex == 0
                if Shuyousu.selectedSegmentIndex == 1 {
                    Shuyoukei.isHidden = true
                    TiryohoLabel.text = "塞栓\n動注/分子標的薬"
                    KaisetsuLabel.text = ""
                    saveString = "塞栓•動注•分子薬"
                    detailString += "肝外転移：なし\n"
                    detailString += "脈管侵襲：なし\n"
                    detailString += "腫瘍数：4個以上\n\n"
                    detailString += "治療法\n塞栓\n動注/分子標的薬"
                }//if Shuyousu.selectedSegmentIndex == 1
            }//if MyakkanSinshu.selectedSegmentIndex == 0
            if MyakkanSinshu.selectedSegmentIndex == 1 {
                Shuyousu.isHidden = true
                Shuyoukei.isHidden = true
                TiryohoLabel.text = "塞栓/切除/\n動注/分子標的薬"
                KaisetsuLabel.text = "*1 肝切除の場合は肝障害度による評価を推奨"
                saveString = "塞栓•切除•動注•分子"
                detailString += "肝外転移：なし\n"
                detailString += "脈管侵襲：あり\n\n"
                detailString += "治療法\n塞栓/切除/\n動注/分子標的薬\n"
                detailString += "*1 肝切除の場合は肝障害度による評価を推奨"
            }//if MyakkanSinshu.selectedSegmentIndex == 1
        }//if KangaiTeni.selectedSegmentIndex == 0 && vChildPoint <= 9
        if KangaiTeni.selectedSegmentIndex == 1 && vChildPoint <= 9 {
            MyakkanSinshu.isHidden = true
            Shuyousu.isHidden = true
            Shuyoukei.isHidden = true
            TiryohoLabel.text = "分子標的薬"
            KaisetsuLabel.text = "*3 Child-Pugh分類 Aのみ"
            saveString = "分子標的薬"
            detailString += "肝外転移：あり\n\n"
            detailString += "治療法\n分子標的薬\n"
            detailString += "*3 Child-Pugh分類 Aのみ"
        }//if KangaiTeni.selectedSegmentIndex == 1 && vChildPoint <= 9
        if vChildPoint >= 10 {
            let vTumorNumber = TumorNumber.selectedSegmentIndex
            let vTumorSize = TumorSize.selectedSegmentIndex
            let vMetastasis = Metastasis.selectedSegmentIndex
            let vVascularInvasion = VascularInvasion.selectedSegmentIndex
            if vTumorNumber == 0 {
                detailString += "腫瘍の数：単発\n"
            }
            if vTumorNumber == 1 {
                detailString += "腫瘍の数：2-3個\n"
            }
            if vTumorNumber == 2 {
                detailString += "腫瘍の数：4個以上\n"
            }
            if vTumorSize == 0 {
                detailString += "最大腫瘍径：3cm以下\n"
            }
            if vTumorSize == 1 {
                detailString += "最大腫瘍径：5cm以下\n"
            }
            if vTumorSize == 2 {
                detailString += "最大腫瘍径：5cm超\n"
            }
            if vMetastasis == 0 {
                detailString += "肝外転移なし\n"
            }
            else {
                detailString += "肝外転移あり\n"
            }
            if vVascularInvasion == 0 {
                detailString += "肝内血管浸潤なし\n"
            }
            else {
                detailString += "肝内血管浸潤あり\n"
            }
            if vTumorNumber == 0 && vTumorSize <= 1 && vMetastasis == 0 && vVascularInvasion == 0 {
                TiryohoLabel.text = "移植"
                KaisetsuLabel.text = "ミラノ基準内\n*4 患者年齢は65歳以下"
                saveString = "移植"
                detailString += "ミラノ基準内\n\n"
                detailString += "治療法\n移植\n"
                detailString += "*4 患者年齢は65歳以下"
            }
            else if vTumorNumber == 1 && vTumorSize == 0 && vMetastasis == 0 && vVascularInvasion == 0 {
                TiryohoLabel.text = "移植"
                KaisetsuLabel.text = "ミラノ基準内\n*4 患者年齢は65歳以下"
                saveString = "移植"
                detailString += "ミラノ基準内\n\n"
                detailString += "治療法\n移植\n"
                detailString += "*4 患者年齢は65歳以下"
            }
            else {
                TiryohoLabel.text = "緩和"
                KaisetsuLabel.text = "ミラノ基準外、移植不能"
                saveString = "緩和"
                detailString += "ミラノ基準外、移植不能\n\n"
                detailString += "治療法\n緩和"
            }
        }//if vChildPoint >= 10
    }//func calc()
    
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
        hideMilan()
        calc()
    }//override func viewDidLoad()
    
    @IBAction func myActionRUN() {
        calc()
    }
    
    @IBAction func myActionReset() {
        Tbil.selectedSegmentIndex = 0
        Alb.selectedSegmentIndex = 0
        PT.selectedSegmentIndex = 0
        Ascites.selectedSegmentIndex = 0
        Encep.selectedSegmentIndex = 0
        KangaiTeni.selectedSegmentIndex = 0
        MyakkanSinshu.selectedSegmentIndex = 0
        Shuyousu.selectedSegmentIndex = 0
        Shuyoukei.selectedSegmentIndex = 0
        TumorNumber.selectedSegmentIndex = 0
        TumorSize.selectedSegmentIndex = 0
        Metastasis.selectedSegmentIndex = 0
        VascularInvasion.selectedSegmentIndex = 0
        calc()
    }//@IBAction func myActionReset()
    
    func showMilan() {
        KangaiTeni.isHidden = true
        MyakkanSinshu.isHidden = true
        Shuyousu.isHidden = true
        Shuyoukei.isHidden = true
        TumorNumber.isHidden = false
        TumorSize.isHidden = false
        Metastasis.isHidden = false
        VascularInvasion.isHidden = false
    }//func showMilan()
    
    func hideMilan() {
        KangaiTeni.isHidden = false
        MyakkanSinshu.isHidden = false
        Shuyousu.isHidden = false
        Shuyoukei.isHidden = false
        TumorNumber.isHidden = true
        TumorSize.isHidden = true
        Metastasis.isHidden = true
        VascularInvasion.isHidden = true
    }//func hideMilan()
    
    @IBAction func myActionSave(){
        let titleString = "注釈入力"
        let messageString = "注釈（メモ、名前等）が入力できます\n（日付と治療法は自動的に入力されます）"
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

}//class HCCAlgoViewController: UIViewController
