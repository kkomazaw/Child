//
//  BileViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/02.
//  Copyright © 2019年 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit
import CoreData

class BileViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    let appName:AppName = .tandougan
    
    @IBOutlet var pdfView:PDFView!
    @IBOutlet var shintatsu:UIPickerView!
    @IBOutlet var siteSelector:UISegmentedControl!
    @IBOutlet var lymphSelector:UISegmentedControl!
    @IBOutlet var metaSelector:UISegmentedControl!
    @IBOutlet var tnmLabel:UILabel!
    @IBOutlet var stageLabel:UILabel!
    @IBOutlet var saveButton:UIBarButtonItem!
    @IBOutlet var hozonzumiButton:UIBarButtonItem!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = "Stage 0"
    var detailString = ""
    typealias SiteAndTvalue = (site: String, tValue: Array<String>)
    var siteAndTvalues = [SiteAndTvalue]()
    let siteFileNames = ["BpSite","BdSite","GbSite","ASite"]
    var twoDimShintatsu = [[String]]()
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
        for _ in 0 ... 3 {
            twoDimShintatsu.append([])
        }
        siteAndTvalues.append(("Bp:肝門部領域胆管癌",["Tis","T1a","T1b","T2a","T2b","T3","T4a","T4b"]))
        twoDimShintatsu[0] = [
            "Tis:carcinoma in situ",
            "T1a:癌の局在が粘膜層にとどまるもの",
            "T1b:癌の局在が線維筋層にとどまるもの",
            "T2a:胆管壁を超えるが他臓器への浸潤なし",
            "T2b:肝実質浸潤を認める",
            "T3:胆管浸潤優位側の門脈あるいは肝動脈浸潤",
            "T4a:浸潤が両側肝内胆管ニ次分枝に及ぶ",
            "T4b:門脈本幹あるいは左右分枝;左右肝動脈,固有•総肝動脈浸潤\n片側肝内胆管二次分枝に及び、対側門脈あるいは肝動脈に浸潤"]
        siteAndTvalues.append(("Bd:遠位胆管癌",["Tis","T1a","T1b","T2","T3a","T3b","T4"]))
        twoDimShintatsu[1] = [
            "Tis:carcinoma in situ",
            "T1a:癌の局在が粘膜層にとどまるもの",
            "T1b:癌の局在が線維筋層にとどまるもの",
            "T2:胆管壁を超えるが他臓器への浸潤なし",
            "T3a:胆嚢、肝臓、膵臓、十二指腸、他の周囲臓器浸潤",
            "T3b:門脈本幹、上腸間膜静脈、下大静脈等の血管浸潤",
            "T4:総肝動脈、腹腔動脈、上腸間膜動脈浸潤"]
        siteAndTvalues.append(("G•C:胆嚢癌",["Tis","T1a","T1b","T2","T3a","T3b","T4a","T4b"]))
        twoDimShintatsu[2] = [
            "Tis:carcinoma in situ",
            "T1a:粘膜固有層への浸潤",
            "T1b:固有筋層への浸潤",
            "T2:漿膜下層あるいは胆嚢床部筋層周囲の結合組織に浸潤",
            "T3a:漿膜浸潤、肝実質浸潤 および/または 一カ所の\n周囲臓器浸潤(胃、十二指腸、大腸、膵臓、大網)",
            "T3b:肝外胆管浸潤",
            "T4a:肝臓以外の二カ所以上の周囲臓器浸潤\n(肝外胆管、胃•十二指腸、大腸、膵臓、大網)",
            "T4b:門脈本幹あるいは総肝動脈•固有肝動脈浸潤"]
        siteAndTvalues.append(("A:乳頭部癌",["Tis","T1a","T1b","T2","T3a","T3b","T4"]))
        twoDimShintatsu[3] = [
            "Tis:carcinoma in situ",
            "T1a:乳頭部粘膜内にとどまる",
            "T1b:Oddi筋に達する",
            "T2:十二指腸浸潤",
            "T3a:5mm以内の膵実質浸潤",
            "T3b:5mmを越えた膵実質浸潤",
            "T4:膵を越える浸潤あるいは周囲臓器浸潤"]
        if let documentURL = Bundle.main.url(forResource: "BpSite", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
        myCalc()
    }//override func viewDidLoad()
    
    func myCalc(){
        let site = siteSelector.selectedSegmentIndex
        let vT = siteAndTvalues[site].tValue[selectedShintatsu]
        let vN = lymphSelector.selectedSegmentIndex
        let vM = metaSelector.selectedSegmentIndex
        stageLabel.text = "該当なし"
        switch site {
        case 0://肝門部領域
            if vT == "Tis" && vN == 0 && vM == 0 {
                stageLabel.text = "Stage 0"
            }
            if (vT == "T1a" || vT == "T1b") && vN == 0 && vM == 0 {
                stageLabel.text = "Stage I"
            }
            if (vT == "T2a" || vT == "T2b") && vN == 0 && vM == 0 {
                stageLabel.text = "Stage II"
            }
            if vT == "T3" && vN == 0 && vM == 0 {
                stageLabel.text = "Stage III A"
            }
            if (vT == "T1a" || vT == "T1b" || vT == "T2a" || vT == "T2b" || vT == "T3") && vN == 1 && vM == 0 {
                stageLabel.text = "Stage III B"
            }
            if (vT == "T4a" || vT == "T4b") && (vN == 0 || vN == 1) && vM == 0 {
                stageLabel.text = "Stage IV A"
            }
            if vM == 1 {
                stageLabel.text = "Stage IV B"
            }
        case 1://遠位胆管癌
            if vT == "Tis" && vN == 0 && vM == 0 {
                stageLabel.text = "Stage 0"
            }
            if (vT == "T1a" || vT == "T1b") && vN == 0 && vM == 0 {
                stageLabel.text = "Stage I A"
            }
            if vT == "T2" && vN == 0 && vM == 0 {
                stageLabel.text = "Stage I B"
            }
            if (vT == "T3a" || vT == "T3b") && vN == 0 && vM == 0 {
                stageLabel.text = "Stage II A"
            }
            if (vT == "T1a" || vT == "T1b" || vT == "T2" || vT == "T3a" || vT == "T3b") && vN == 1 && vM == 0 {
                stageLabel.text = "Stage II B"
            }
            if vT == "T4" && vM == 0 {
                stageLabel.text = "Stage III"
            }
            if vM == 1 {
                stageLabel.text = "Stage IV"
            }
        case 2://胆嚢癌
            if vT == "Tis" && vN == 0 && vM == 0 {
                stageLabel.text = "Stage 0"
            }
            if (vT == "T1a" || vT == "T1b") && vN == 0 && vM == 0 {
                stageLabel.text = "Stage I"
            }
            if vT == "T2" && vN == 0 && vM == 0 {
                stageLabel.text = "Stage II"
            }
            if (vT == "T3a" || vT == "T3b") && vN == 0 && vM == 0 {
                stageLabel.text = "Stage III A"
            }
            if (vT == "T1a" || vT == "T1b" || vT == "T2" || vT == "T3a" || vT == "T3b") && vN == 1 && vM == 0 {
                stageLabel.text = "Stage III B"
            }
            if (vT == "T4a" || vT == "T4b") && vM == 0{
                stageLabel.text = "Stage IV A"
            }
            if vM == 1 {
                stageLabel.text = "Stage IV B"
            }
        case 3://乳頭部癌
            if vT == "Tis" && vN == 0 && vM == 0 {
                stageLabel.text = "Stage 0"
            }
            if (vT == "T1a" || vT == "T1b") && vN == 0 && vM == 0 {
                stageLabel.text = "Stage I A"
            }
            if vT == "T2" && vN == 0 && vM == 0 {
                stageLabel.text = "Stage I B"
            }
            if (vT == "T3a" || vT == "T3b") && vN == 0 && vM == 0 {
                stageLabel.text = "Stage II A"
            }
            if (vT == "T1a" || vT == "T1b" || vT == "T2" || vT == "T3a" || vT == "T3b") && vN == 1 && vM == 0 {
                stageLabel.text = "Stage II B"
            }
            if vT == "T4" && vM == 0 {
                stageLabel.text = "Stage III"
            }
            if vM == 1 {
                stageLabel.text = "Stage IV"
            }
        default:
            break
        }
        tnmLabel.text = "\(vT) N\(vN) M\(vM)"
        //saveStringはSaveViewControllerのtableで表示される
        //detailStringはSaveDetailViewControllerのtextViewで表示される
        saveString = stageLabel.text!
        detailString = siteAndTvalues[site].site + "\n\n"
        detailString += twoDimShintatsu[site][selectedShintatsu] + "\n"
        if vN == 0 {
            detailString += "N0:領域リンパ節転移なし\n"
        }
        else {
            detailString += "N1:領域リンパ節転移あり\n"
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
        return twoDimShintatsu[siteSelector.selectedSegmentIndex].count
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
        pickerLabel?.text = twoDimShintatsu[siteSelector.selectedSegmentIndex][row]
        pickerLabel?.textColor = UIColor.black
        return pickerLabel!
    }//func pickerView(_ pickerView: UIPickerView, viewForRow
    
    @IBAction func lymphOrMetaSelectorChanged(){
        myCalc()
    }
    
    @IBAction func myActionSiteChanged(){
        if let documentURL = Bundle.main.url(forResource: siteFileNames[siteSelector.selectedSegmentIndex], withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
        shintatsu.reloadAllComponents()
        if selectedShintatsu >= twoDimShintatsu[siteSelector.selectedSegmentIndex].count {
            selectedShintatsu = twoDimShintatsu[siteSelector.selectedSegmentIndex].count - 1
        }//if selectedShintatsu >= twoDimShintatsu[siteSelector.selectedSegmentIndex].count
        myCalc()
    }//@IBAction func myActionSiteChanged()
    
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
    
}//class BileViewController
