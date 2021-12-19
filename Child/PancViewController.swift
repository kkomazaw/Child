//
//  PancViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/03.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit
import CoreData

class PancViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let appName:AppName = .suigan
    
    @IBOutlet var pdfView:PDFView!
    @IBOutlet var shintatsu:UIPickerView!
    @IBOutlet var lymphSelector:UISegmentedControl!
    @IBOutlet var metaSelector:UISegmentedControl!
    @IBOutlet var tnmLabel:UILabel!
    @IBOutlet var stageLabel:UILabel!
    @IBOutlet var saveButton:UIBarButtonItem!
    @IBOutlet var hozonzumiButton:UIBarButtonItem!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    enum Shintatsu:String {
        case Tis = "Tis"
        case T1a = "T1a"
        case T1b = "T1b"
        case T1c = "T1c"
        case T2 = "T2"
        case T3 = "T3"
        case T4 = "T4"
    }
    
    let shintatsuArray = ["Tis:非浸潤癌",
                          "T1a:最大径が5mm以下の腫瘍(膵限局)",
                          "T1b:最大径が5mmをこえるが10mm以下(膵限局)",
                          "T1c:最大径が10mmをこえるが20mm以下(膵限局)",
                          "T2:腫瘍が膵臓に限局しており、最大径が20mmをこえる",
                          "T3:腫瘍の浸潤が膵をこえて進展するが、\n腹腔動脈もしくは上腸間膜動脈に及ばない",
                          "T4:腫瘍の浸潤が腹腔動脈もしくは上腸間膜動脈に及ぶ"]
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = "Stage 0"
    var detailString = ""
    var selectedShintatsu = 0
    
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
        if let documentURL = Bundle.main.url(forResource: "PKLN", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
        myCalc()
    }//override func viewDidLoad()
    
    func myCalc(){
        var vT:Shintatsu = .Tis
        let vN = lymphSelector.selectedSegmentIndex
        let vM = metaSelector.selectedSegmentIndex
        stageLabel.text = "該当なし"
        switch selectedShintatsu {
        case 0:
            vT = .Tis
        case 1:
            vT = .T1a
        case 2:
            vT = .T1b
        case 3:
            vT = .T1c
        case 4:
            vT = .T2
        case 5:
            vT = .T3
        case 6:
            vT = .T4
        default:
            break
        }//switch selectedShintatsu
        if vT == .Tis && vN == 0 && vM == 0 {
            stageLabel.text = "Stage 0"
        }
        if (vT == .T1a || vT == .T1b || vT == .T1c) && vN == 0 && vM == 0 {
            stageLabel.text = "Stage I A"
        }
        if vT == .T2 && vN == 0 && vM == 0 {
            stageLabel.text = "Stage I B"
        }
        if vT == .T3 && vN == 0 && vM == 0 {
            stageLabel.text = "Stage II A"
        }
        if (vT == .T1a || vT == .T1b || vT == .T1c || vT == .T2 || vT == .T3) && vN >= 1 && vM == 0 {
            stageLabel.text = "Stage II B"
        }
        if vT == .T4 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if vM == 1 {
            stageLabel.text = "Stage IV"
        }
        var nString = "N0"
        if vN == 1 {
            nString = "N1a"
        }
        if vN == 2 {
            nString = "N1b"
        }
        var mString = "M0"
        if vM == 1 {
            mString = "M1"
        }
        tnmLabel.text = "\(vT.rawValue) \(nString) \(mString)"
        //saveStringはSaveViewControllerのtableで表示される
        //detailStringはSaveDetailViewControllerのtextViewで表示される
        saveString = stageLabel.text!
        detailString = shintatsuArray[selectedShintatsu] + "\n"
        if vN == 0 {
            detailString += "N0:領域リンパ節転移なし\n"
        }
        if vN == 1 {
            detailString += "N1a:領域リンパ節に1~3個の転移\n"
        }
        if vN == 2 {
            detailString += "N1b:領域リンパ節に4個以上の転移\n"
        }
        if vM == 0 {
            detailString += "M0:遠隔転移なし\n\n"
        }
        else {
            detailString += "M1:領域外リンパ節転移もしくは遠隔転移あり\n\n"
        }
        detailString += "\(tnmLabel.text!) \(stageLabel.text!)"
    }//func myCalc()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shintatsuArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedShintatsu = row
        myCalc()
    }//func pickerView(_ pickerView: UIPickerView, didSelectRow
    
    func pickerView(_ pickerView: UIPickerView,
                    rowHeightForComponent component: Int) -> CGFloat {
        let heightSize = UIScreen.main.bounds.size.height
        return heightSize / 20
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "system", size: 50)
            pickerLabel?.textAlignment = .center
            pickerLabel?.numberOfLines = 2
            pickerLabel?.adjustsFontSizeToFitWidth = true
        }
        pickerLabel?.text = shintatsuArray[row]
        pickerLabel?.textColor = UIColor.black
        return pickerLabel!
    }//func pickerView(_ pickerView: UIPickerView, viewForRow
    
    @IBAction func lymphOrMetaSelectorChanged(){
        myCalc()
    }
    
    @IBAction func myActionSave(){
        let titleString = "注釈入力"
        let messageString = "注釈（メモ、名前等）が入力できます\n（日付とStageは自動的に入力されます）"
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
    
}//class PancViewController: UIViewController
