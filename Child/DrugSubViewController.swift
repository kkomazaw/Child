//
//  DrugSubViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/04/07.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class DrugSubViewController: UIViewController {
    
    let appName:AppName = .yakubutsu
    
    @IBOutlet var YakubutsuIgainoGenin:UISegmentedControl!
    @IBOutlet var KakonoKanshogai:UISegmentedControl!
    @IBOutlet var Kosankyu:UISegmentedControl!
    @IBOutlet var DLST: UISegmentedControl!
    @IBOutlet var GuzenNoSaitoyoSegment:UISegmentedControl!
    @IBOutlet var GuzenNoSaitoyoLabel2:UILabel!
    @IBOutlet var GuzenNoSaitoyoLabel3:UILabel!
    @IBOutlet var GuzenNoSaitoyoLabel4:UILabel!
    @IBOutlet var Tensu:UILabel!
    @IBOutlet var Kanosei:UILabel!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = ""
    var detailString = ""
    
    let kansaiboLabel2 = "初回肝障害時と同条件で再投与, ALT増加するも正常域"
    let kansaiboLabel3 = "初回肝障害時の併用薬と共に再投与, ALT倍増"
    let kansaiboLabel4 = "単独再投与でALT倍増"
    let tandoKongoLabel2 = "初回肝障害時と同条件で再投与, ALP(T-bil)増加するも正常域"
    let tandoKongoLabel3 = "初回肝障害時の併用薬と共に再投与, ALP(T-bil)倍増"
    let tandoKongoLabel4 = "単独再投与でALP(T-bil)倍増"
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
        if flagOfLiverDamage == 1 {
            GuzenNoSaitoyoLabel2.text = "② \(kansaiboLabel2)"
            GuzenNoSaitoyoLabel3.text = "③ \(kansaiboLabel3)"
            GuzenNoSaitoyoLabel4.text = "④ \(kansaiboLabel4)"
        }
        if flagOfLiverDamage == 2 {
            GuzenNoSaitoyoLabel2.text = "② \(tandoKongoLabel2)"
            GuzenNoSaitoyoLabel3.text = "③ \(tandoKongoLabel3)"
            GuzenNoSaitoyoLabel4.text = "④ \(tandoKongoLabel4)"
        }
        YakubutsuIgainoGenin.selectedSegmentIndex = vYakubutsuIgainoGenin
        KakonoKanshogai.selectedSegmentIndex = vKakonoKanshogai
        Kosankyu.selectedSegmentIndex = vKosankyu
        DLST.selectedSegmentIndex = vDLST
        GuzenNoSaitoyoSegment.selectedSegmentIndex = vGuzenNoSaitoyo
        calc()
    }//override func viewDidLoad()
    
    func calc(){
        vYakubutsuIgainoGenin = YakubutsuIgainoGenin.selectedSegmentIndex
        vKakonoKanshogai = KakonoKanshogai.selectedSegmentIndex
        vKosankyu = Kosankyu.selectedSegmentIndex
        vDLST = DLST.selectedSegmentIndex
        vGuzenNoSaitoyo = GuzenNoSaitoyoSegment.selectedSegmentIndex
        detailString = zenhanText + "4.薬物以外の原因の有無\n"
        switch vYakubutsuIgainoGenin {
        case 0:
            myValue4 = -3
            detailString += " 薬物以外の原因が濃厚\n"
        case 1:
            myValue4 = -2
            detailString += " HAV, HBV, HCV, 胆道疾患, Alcohol, shock の除外が3つ以下\n"
        case 2:
            myValue4 = 0
            detailString += " HAV, HBV, HCV, 胆道疾患, Alcohol, shock のうち4つか5つが除外\n"
        case 3:
            myValue4 = 1
            detailString += " HAV, HBV, HCV, 胆道疾患, Alcohol, shock のすべて除外\n"
        case 4:
            myValue4 = 2
            detailString += " HAV, HBV, HCV, 胆道疾患, Alcohol, shock, CMV, EBV のすべて除外\n"
        default:
            break
        }//switch vYakubutsuIgainoGenin
        detailString += " ⇨ \(myValue4)点\n\n"
        myValue5 = vKakonoKanshogai
        if vKakonoKanshogai == 0 {
            detailString += "5.(同薬物で)過去に肝障害の報告なし\n"
        }
        if vKakonoKanshogai == 1 {
            detailString += "5.(同薬物で)過去に肝障害の報告あり\n"
        }
        detailString += " ⇨ \(myValue5)点\n\n"
        myValue6 = vKosankyu
        if vKosankyu == 0 {
            detailString += "6.好酸球増多(6%以上)なし\n"
        }
        if vKosankyu == 1 {
            detailString += "6.好酸球増多(6%以上)あり\n"
        }
        detailString += " ⇨ \(myValue6)点\n\n"
        myValue7 = vDLST
        if vDLST == 0 {
            detailString += "7.DLST 陰性か未施行\n"
        }
        if vDLST == 1 {
            detailString += "7.DLST 擬陽性\n"
        }
        if vDLST == 2 {
            detailString += "7.DLST 陽性\n"
        }
        detailString += " ⇨ \(myValue7)点\n\n"
        detailString += "8.偶然の再投与が行われたときの反応："
        switch vGuzenNoSaitoyo {
        case 0:
            myValue8 = 0
            detailString += "偶然の再投与なし、または判断不能\n"
        case 1:
            myValue8 = -2
            if flagOfLiverDamage == 1 {
                detailString += kansaiboLabel2 + "\n"
            }
            if flagOfLiverDamage == 2 {
                detailString += tandoKongoLabel2 + "\n"
            }
        case 2:
            myValue8 = 1
            if flagOfLiverDamage == 1 {
                detailString += kansaiboLabel3 + "\n"
            }
            if flagOfLiverDamage == 2 {
                detailString += tandoKongoLabel3 + "\n"
            }
        case 3:
            myValue8 = 3
            if flagOfLiverDamage == 1 {
                detailString += kansaiboLabel4 + "\n"
            }
            if flagOfLiverDamage == 2 {
                detailString += tandoKongoLabel4 + "\n"
            }
        default:
            break
        }//switch vGuzenNoSaitoyo
        detailString += " ⇨ \(myValue8)点\n\n"
        vTensu = myValue1 + myValue2 + myValue3 + myValue4 + myValue5 + myValue6 + myValue7 + myValue8
        Tensu.text = "\(vTensu)"
        if vTensu <= 2 {
            Kanosei.text = "可能性が低い"
        }
        if vTensu >= 3 && vTensu <= 4 {
            Kanosei.text = "可能性あり"
        }
        if vTensu >= 5 {
            Kanosei.text = "可能性が高い"
        }
        saveString = "\(vTensu)点 \(Kanosei.text!)"
        detailString += "合計：" + saveString
    }//func calc()
    
    @IBAction func segmentChanged(){
        calc()
    }
    
    @IBAction func myActionClear(){
        YakubutsuIgainoGenin.selectedSegmentIndex = 0
        KakonoKanshogai.selectedSegmentIndex = 0
        Kosankyu.selectedSegmentIndex = 0
        DLST.selectedSegmentIndex = 0
        GuzenNoSaitoyoSegment.selectedSegmentIndex = 0
        calc()
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
    
    @IBAction func hozonzumi() {
        performSegue(withIdentifier: "yakubutsuSave", sender: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yakubutsuSave" {
            let sendText = segue.destination as! SaveViewController
            sendText.myText = appName.rawValue
        }//if segue.identifier == "yakubutsuSave"
    }//override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    
}
