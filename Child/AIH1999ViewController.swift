//
//  AIH1999ViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/07.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class AIH1999ViewController: UIViewController {
    
    let appName:AppName = .aih1999
    
    @IBOutlet var ASTj:UITextField!
    @IBOutlet var ASTr:UITextField!
    @IBOutlet var ALPj:UITextField!
    @IBOutlet var ALPr:UITextField!
    @IBOutlet var IgGj:UITextField!
    @IBOutlet var IgGr:UITextField!
    @IBOutlet var Danjo:UISegmentedControl!
    @IBOutlet var Kanen:UISegmentedControl!
    @IBOutlet var AMA:UISegmentedControl!
    @IBOutlet var Fukuyaku:UISegmentedControl!
    @IBOutlet var Inshu:UISegmentedControl!
    @IBOutlet var Tajiko:UISegmentedControl!
    @IBOutlet var ANASMA:UISegmentedControl!
    @IBOutlet var tsugiButton:UIButton!
    @IBOutlet var Interhep:UISegmentedControl!
    @IBOutlet var Plasma:UISegmentedControl!
    @IBOutlet var Rozet:UISegmentedControl!
    @IBOutlet var Tankan:UISegmentedControl!
    @IBOutlet var Tabyoin:UISegmentedControl!
    @IBOutlet var Seiken:UISegmentedControl!
    @IBOutlet var pANCA:UISegmentedControl!
    @IBOutlet var HLADR:UISegmentedControl!
    @IBOutlet var Hanno:UISegmentedControl!
    @IBOutlet var Zengo:UISegmentedControl!
    @IBOutlet var Tensu:UILabel!
    @IBOutlet var AIHgishin:UILabel!
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
        ASTj.becomeFirstResponder()
    }
    
    func calculate(){
        let vASTj = Double(ASTj.text!) ?? 0.0
        let vASTr = Double(ASTr.text!) ?? 0.0
        let vALPj = Double(ALPj.text!) ?? 0.0
        let vALPr = Double(ALPr.text!) ?? 0.0
        var vRatioA = 0.0
        var vALPAST = 0
        if vASTj * vASTr * vALPj * vALPr != 0 {
            vRatioA = (vALPr / vALPj) / (vASTr / vASTj)
        }
        if vRatioA < 1.5 && vRatioA > 0 {
            vALPAST = 2
        }
        if vRatioA >= 1.5 && vRatioA <= 3.0 {
            vALPAST = 0
        }
        if vRatioA > 3.0 {
            vALPAST = -2
        }
        let vIgGj = Double(IgGj.text!) ?? 0.0
        let vIgGr = Double(IgGr.text!) ?? 0.0
        var vRatioI = 0.0
        if vIgGj * vIgGr != 0 {
            vRatioI = vIgGr / vIgGj
        }
        var vIRatio = 0
        if vRatioI > 2.0 {
            vIRatio = 3
        }
        if vRatioI <= 2.0 && vRatioI >= 1.5 {
            vIRatio = 2
        }
        if vRatioI < 1.5 && vRatioI >= 1.0 {
            vIRatio = 1
        }
        if vRatioI < 1.0 {
            vIRatio = 0
        }
        let vDanjo = (1 - Danjo.selectedSegmentIndex) * 2
        var vKanen = -3
        if Kanen.selectedSegmentIndex == 0 {
            vKanen = 3
        }
        let vAMA = AMA.selectedSegmentIndex * (-4)
        var vFukuyaku = -4
        if Fukuyaku.selectedSegmentIndex == 0 {
            vFukuyaku = 1
        }
        var vInshu = -2
        if Inshu.selectedSegmentIndex == 0 {
            vInshu = 2
        }
        let vTajiko = Tajiko.selectedSegmentIndex * 2
        let vANASMA = 3 - ANASMA.selectedSegmentIndex
        let vInterhep = Interhep.selectedSegmentIndex * 3
        let vPlasma = Plasma.selectedSegmentIndex
        let vRozet = Rozet.selectedSegmentIndex
        var vSeiken = Seiken.selectedSegmentIndex
        let vTankan = Tankan.selectedSegmentIndex * (-3)
        let vTabyoin = Tabyoin.selectedSegmentIndex * (-3)
        if vInterhep + vPlasma + vRozet > 0 || vTankan + vTabyoin < 0 {
            Seiken.selectedSegmentIndex = 1
            vSeiken = 1
        }
        var vSubete = 0
        if vInterhep + vPlasma + vRozet == 0 && vSeiken == 1 {
            vSubete = -5
        }
        var vpANCA = 0
        var vHLADR = 0
        if vANASMA == 0 {
            vpANCA = pANCA.selectedSegmentIndex * 2
            vHLADR = HLADR.selectedSegmentIndex
        }
        var vHanno = 0
        if Hanno.selectedSegmentIndex >= 1 {
            vHanno = Hanno.selectedSegmentIndex + 1
        }
        let vZengo = Zengo.selectedSegmentIndex
        let vTensu = vALPAST + vIRatio + vDanjo + vKanen + vAMA + vFukuyaku + vInshu + vTajiko + vANASMA + vInterhep + vPlasma + vRozet + vSubete + vTankan + vTabyoin + vpANCA + vHLADR + vHanno
        Tensu.text = "\(vTensu)点"
        if vZengo == 0 && vTensu <= 9 {
            AIHgishin.text = ""
        }
        if vZengo == 0 && vTensu >= 10 && vTensu <= 15 {
            AIHgishin.text = "AIH疑診"
        }
        if vZengo == 0 && vTensu >= 16 {
            AIHgishin.text = "AIH確診"
        }
        if vZengo == 1 && vTensu <= 11 {
            AIHgishin.text = ""
        }
        if vZengo == 1 && vTensu >= 12 && vTensu <= 17 {
            AIHgishin.text = "AIH疑診"
        }
        if vZengo == 1 && vTensu >= 18 {
            AIHgishin.text = "AIH確診"
        }
        saveString = "\(Tensu.text!) \(AIHgishin.text!)"
        detailString = "AST(ALT)上限 \(Int(vASTj))\n"
        detailString += "AST(ALT)実測 \(Int(vASTr))\n"
        detailString += "ALP上限 \(Int(vALPj))\n"
        detailString += "ALP実測 \(Int(vALPr))\n"
        detailString += "IgG上限 \(Int(vIgGj))\n"
        detailString += "IgG実測 \(Int(vIgGr))\n"
        if Danjo.selectedSegmentIndex == 0 {
            detailString += "性別:女性\n"
        }
        else {
            detailString += "性別:男性\n"
        }
        if Kanen.selectedSegmentIndex == 0 {
            detailString += "肝炎ウイルス:陰性\n"
        }
        else {
            detailString += "肝炎ウイルス:陽性\n"
        }
        if AMA.selectedSegmentIndex == 0 {
            detailString += "抗ミトコンドリア抗体:陰性\n"
        }
        else {
            detailString += "抗ミトコンドリア抗体:陽性\n"
        }
        if Fukuyaku.selectedSegmentIndex == 0 {
            detailString += "服薬歴なし\n"
        }
        else {
            detailString += "服薬歴あり\n"
        }
        if Inshu.selectedSegmentIndex == 0 {
            detailString += "飲酒量 25g/日以下\n"
        }
        else {
            detailString += "飲酒量 60g/日以上\n"
        }
        if Tajiko.selectedSegmentIndex == 0 {
            detailString += "他自己免疫疾患なし\n"
        }
        else {
            detailString += "他自己免疫疾患あり\n"
        }
        detailString += "ANA, SMAあるいはLKM-1 "
        switch ANASMA.selectedSegmentIndex {
        case 0:
            detailString += ">1:80\n"
        case 1:
            detailString += "1:80\n"
        case 2:
            detailString += "1:40\n"
        case 3:
            detailString += "<1:40\n"
        default:
            break
        }//switch ANASMA.selectedSegmentIndex
        if Interhep.selectedSegmentIndex == 0 {
            detailString += "interface肝炎なし\n"
        }
        else {
            detailString += "interface肝炎あり\n"
        }
        if Plasma.selectedSegmentIndex == 0 {
            detailString += "リンパ球形質細胞優位浸潤なし\n"
        }
        else {
            detailString += "リンパ球形質細胞優位浸潤あり\n"
        }
        if Rozet.selectedSegmentIndex == 0 {
            detailString += "肝細胞ロゼット形成なし\n"
        }
        else {
            detailString += "肝細胞ロゼット形成あり\n"
        }
        if Tankan.selectedSegmentIndex == 0 {
            detailString += "胆管病変なし\n"
        }
        else {
            detailString += "胆管病変あり\n"
        }
        if Tabyoin.selectedSegmentIndex == 0 {
            detailString += "他病因を示唆する組織所見なし\n"
        }
        else {
            detailString += "他病因を示唆する組織所見あり\n"
        }
        if Seiken.selectedSegmentIndex == 0 {
            detailString += "肝生検未施行\n"
        }
        else {
            detailString += "肝生検施行済み\n"
        }
        if pANCA.selectedSegmentIndex == 0 {
            detailString += "pANCA陰性\n"
        }
        else {
            detailString += "pANCA陽性\n"
        }
        if HLADR.selectedSegmentIndex == 0 {
            detailString += "HLADR 3/4 なし\n"
        }
        else {
            detailString += "HLADR 3/4 あり\n"
        }
        if Hanno.selectedSegmentIndex == 0 {
            detailString += "治療に対する反応なし\n"
        }
        if Hanno.selectedSegmentIndex == 1 {
            detailString += "治療に対する反応:著効\n"
        }
        if Hanno.selectedSegmentIndex == 2 {
            detailString += "治療に反応し、治療終了後再燃\n"
        }
        if Zengo.selectedSegmentIndex == 0 {
            detailString += "治療前"
        }
        else {
            detailString += "治療後"
        }
    }//func calculate()
    
    @IBAction func segmentChanged(){
        calculate()
    }
    
    @IBAction func myActionSeiken(){
        if Seiken.selectedSegmentIndex == 0 {
            Interhep.selectedSegmentIndex = 0
            Plasma.selectedSegmentIndex = 0
            Rozet.selectedSegmentIndex = 0
            Tankan.selectedSegmentIndex = 0
            Tabyoin.selectedSegmentIndex = 0
        }
        calculate()
    }
    
    @IBAction func myActionTsugi(){
        view.endEditing(true)
        calculate()
    }
    
    @IBAction func myActionClear(){
        ASTj.text = ""
        ASTr.text = ""
        ALPj.text = ""
        ALPr.text = ""
        IgGj.text = ""
        IgGr.text = ""
        Danjo.selectedSegmentIndex = 0
        Kanen.selectedSegmentIndex = 0
        AMA.selectedSegmentIndex = 0
        Fukuyaku.selectedSegmentIndex = 0
        Inshu.selectedSegmentIndex = 0
        Tajiko.selectedSegmentIndex = 0
        ANASMA.selectedSegmentIndex = 0
        Interhep.selectedSegmentIndex = 0
        Plasma.selectedSegmentIndex = 0
        Rozet.selectedSegmentIndex = 0
        Tankan.selectedSegmentIndex = 0
        Tabyoin.selectedSegmentIndex = 0
        Seiken.selectedSegmentIndex = 0
        pANCA.selectedSegmentIndex = 0
        HLADR.selectedSegmentIndex = 0
        Hanno.selectedSegmentIndex = 0
        Zengo.selectedSegmentIndex = 0
        Tensu.text = "0"
        ASTj.becomeFirstResponder()
    }//@IBAction func myActionClear()
    
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
    
}//class AIH1999ViewController: UIViewController
