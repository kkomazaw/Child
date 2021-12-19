//
//  Panc2008ViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/09.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class Panc2008ViewController: UIViewController {
    
    let appName:AppName = .suien
    
    @IBOutlet var BE:UISegmentedControl!
    @IBOutlet var PaO2:UISegmentedControl!
    @IBOutlet var BUN:UISegmentedControl!
    @IBOutlet var LDH:UISegmentedControl!
    @IBOutlet var PLT:UISegmentedControl!
    @IBOutlet var Calci:UISegmentedControl!
    @IBOutlet var CRP15:UISegmentedControl!
    @IBOutlet var SIRS:UISegmentedControl!
    @IBOutlet var Age70:UISegmentedControl!
    @IBOutlet var ZoeiCT:UISegmentedControl!
    @IBOutlet var Furyo:UISegmentedControl!
    @IBOutlet var Yogoinshi:UILabel!
    @IBOutlet var CTgrade:UILabel!
    @IBOutlet var Jusho:UILabel!
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
    
    func calc(){
        let minusPlus = ["いいえ","はい"]
        let vBE = BE.selectedSegmentIndex
        let vPaO2 = PaO2.selectedSegmentIndex
        let vBUN = BUN.selectedSegmentIndex
        let vLDH = LDH.selectedSegmentIndex
        let vPLT = PLT.selectedSegmentIndex
        let vCalci = Calci.selectedSegmentIndex
        let vCRP15 = CRP15.selectedSegmentIndex
        let vSIRS = SIRS.selectedSegmentIndex
        let vAge70 = Age70.selectedSegmentIndex
        let vZoeiCT = ZoeiCT.selectedSegmentIndex
        let vFuryo = Furyo.selectedSegmentIndex
        let vYogoinshi = vBE + vPaO2 + vBUN + vLDH + vPLT + vCalci + vCRP15 + vSIRS + vAge70
        let vCTtensu = vZoeiCT + vFuryo
        var vCTgrade = 1
        if vCTtensu == 2 {
            vCTgrade = 2
        }
        if vCTtensu >= 3 {
            vCTgrade = 3
        }
        Yogoinshi.text = "\(vYogoinshi)"
        CTgrade.text = "\(vCTgrade)"
        Jusho.text = ""
        if vYogoinshi >= 3 || vCTgrade >= 2 {
            Jusho.text = "重症"
        }
        saveString = "予\(vYogoinshi) CT\(vCTgrade) \(Jusho.text!)"
        detailString = "① BE ≦ 3 or SBP ≦ 80: \(minusPlus[vBE])\n"
        detailString += "② PaO2 ≦ 60 or 人工呼吸: \(minusPlus[vPaO2])\n"
        detailString += "③ BUN ≧ 40 or Cr ≧ 2, 乏尿: \(minusPlus[vBUN])\n"
        detailString += "④ LDH ≧ 2倍: \(minusPlus[vLDH])\n"
        detailString += "⑤ 血小板 ≦ 10万: \(minusPlus[vPLT])\n"
        detailString += "⑥ Ca ≦ 7.5mg/dl: \(minusPlus[vCalci])\n"
        detailString += "⑦ CRP ≧ 15: \(minusPlus[vCRP15])\n"
        detailString += "⑧ SIRS項目 ≧ 3: \(minusPlus[vSIRS])\n"
        detailString += "⑨ 年齢 ≧ 70歳: \(minusPlus[vAge70])\n"
        detailString += "造影CT, 炎症の膵外進展度: "
        if vZoeiCT == 0 {
            detailString += "前腎傍腔\n"
        }
        if vZoeiCT == 1 {
            detailString += "血腸間膜根\n"
        }
        if vZoeiCT == 2 {
            detailString += "腎下極以遠\n"
        }
        detailString += "膵の造影不良域: "
        if vFuryo == 0 {
            detailString += "区域限局,または膵周辺のみ\n\n"
        }
        if vFuryo == 1 {
            detailString += "2区域に亘る\n\n"
        }
        if vFuryo == 2 {
            detailString += "2区域全体、またはそれ以上\n\n"
        }
        detailString += "予後因子 \(vYogoinshi)点 CT grade \(vCTgrade) \(Jusho.text!)"
    }//func calc()
    
    @IBAction func myActionRUN(){
        calc()
    }//@IBAction func myActionRUN()
    
    @IBAction func myActionReset(){
        BE.selectedSegmentIndex = 0
        PaO2.selectedSegmentIndex = 0
        BUN.selectedSegmentIndex = 0
        LDH.selectedSegmentIndex = 0
        PLT.selectedSegmentIndex = 0
        Calci.selectedSegmentIndex = 0
        CRP15.selectedSegmentIndex = 0
        SIRS.selectedSegmentIndex = 0
        Age70.selectedSegmentIndex = 0
        ZoeiCT.selectedSegmentIndex = 0
        Furyo.selectedSegmentIndex = 0
        Yogoinshi.text = "0"
        CTgrade.text = "1"
        Jusho.text = ""
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
    
}//class Panc2008ViewController: UIViewController
