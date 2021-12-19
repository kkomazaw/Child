//
//  EsoViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/02/17.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit
import CoreData

class EsoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let appName:AppName = .shokudou
    
    @IBOutlet var senkyobui:UIPickerView!
    @IBOutlet var shintatsu:UIPickerView!
    @IBOutlet var lymph:UIPickerView!
    @IBOutlet var meta:UISegmentedControl!
    @IBOutlet var tnmLabel:UILabel!
    @IBOutlet var stageLabel:UILabel!
    @IBOutlet var pdfView:PDFView!
    @IBOutlet var shintatsuView:PDFView!
    @IBOutlet var upperLargeButton:UIButton!
    @IBOutlet var lowerLargeButton:UIButton!
    @IBOutlet var saveButton:UIBarButtonItem!
    @IBOutlet var hozonzumiButton:UIBarButtonItem!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = "Stage 0"
    var detailString = ""
    typealias SubTitles = (title: String, subArray: Array<String>)
    var subtitles = [SubTitles]()
    
    enum Shintatsu:String {
        case T0 = "T0"
        case T1a = "T1a"
        case T1b = "T1b"
        case T2 = "T2"
        case T3 = "T3"
        case T4a = "T4a"
        case T4b = "T4b"
    }
    
    var myShintatsu:Shintatsu = .T0
    
    var twoDimArray = [[String]]()
    var selectedPicker = [Int]()
    var vSenkyobui = 0
    
    let SiteResourceArray = ["esoCE","esoUT","esoMT","esoLT","esoAE"]
    
    let shintatsuArray = ["T0","MM","SM","MP","AD","T4a","T4b"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        if height > 800.0 && height < 1000.0 {
            myToolBar.frame = CGRect(x: 0, y: height * 0.92, width: width, height: height * 0.055)
        }
        if height > 1000.0 {
            myToolBar.frame = CGRect(x: 0, y: height * 0.94, width: width, height: height * 0.05)
        }
        if let documentURL = Bundle.main.url(forResource: "esoCE", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
        if let documentURL = Bundle.main.url(forResource: "T0", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                shintatsuView.document = document
                shintatsuView.displayMode = .singlePage
                shintatsuView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
        for _ in 0 ... 2 {
            twoDimArray.append([])
        }
        twoDimArray[0] = ["Ce","Ut","Mt","Lt","Ae"]
        twoDimArray[1] = ["なし","1群","2群","3群","4群"]
        twoDimArray[2] = ["癌腫なし","MM","SM","MP","AD","AI: T4a","AI: T4b"]
        selectedPicker = [0,0,0]
        subtitles.append(("占拠部位 ",["Ce:頸部食道","Ut:胸部上部食道","Mt:胸部中部食道","Lt:胸部下部食道","Ae:腹部食道"]))
        subtitles.append(("壁深達度 ",["T0:原発巣としての癌種を認めない","T1a (MM):癌種が粘膜内にとどまる","T1b (SM):癌種が粘膜下層にとどまる","T2 (MP):癌種が固有筋層にとどまる","T3 (AD):癌種が食道外膜に浸潤している","T4a:胸膜、心膜、横隔膜、肺、胸管、奇静脈、神経浸潤","T4b:大動脈（大血管）、気管、気管支、肺動脈、肺静脈、椎体浸潤"]))
        subtitles.append(("リンパ節転移 ",["N0:リンパ節転移を認めない","N1:第1群リンパ節のみに転移を認める","N2:第2群リンパ節まで転移を認める","N3:第3群リンパ節まで転移を認める","N4:第3群リンパ節より遠位のリンパ節（第4群)に転移を認める"]))
        subtitles.append(("遠隔臓器転移 ",["M0:遠隔臓器転移を認めない","M1:遠隔臓器転移を認める"]))
        myCalc()
    }//override func viewDidLoad()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return twoDimArray[pickerView.tag].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return twoDimArray[pickerView.tag][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPicker[pickerView.tag] = row
        if pickerView.tag == 0 {
            if let documentURL = Bundle.main.url(forResource: SiteResourceArray[row], withExtension: "pdf") {
                if let document = PDFDocument(url: documentURL) {
                    pdfView.document = document
                }//if let document = PDFDocument
            }//if let documentURL = Bundle.main.url
        }//if pickerView.tag == 0
        if pickerView.tag == 2 {
            if let documentURL = Bundle.main.url(forResource: shintatsuArray[selectedPicker[2]], withExtension: "pdf") {
                if let document = PDFDocument(url: documentURL) {
                    shintatsuView.document = document
                }//if let document = PDFDocument
            }//if let documentURL = Bundle.main.url
        }//if pickerView.tag == 2
        myCalc()
    }//func pickerView
    
    func myCalc(){
        vSenkyobui = selectedPicker[0]
        let vShintatsu = selectedPicker[2]
        switch vShintatsu {
        case 0:
            myShintatsu = .T0
        case 1:
            myShintatsu = .T1a
        case 2:
            myShintatsu = .T1b
        case 3:
            myShintatsu = .T2
        case 4:
            myShintatsu = .T3
        case 5:
            myShintatsu = .T4a
        case 6:
            myShintatsu = .T4b
        default:
            break
        }
        let vN = selectedPicker[1]
        let vM = meta.selectedSegmentIndex
        tnmLabel.text = "\(myShintatsu.rawValue) N\(vN) M\(vM)"
        if (myShintatsu == .T0 || myShintatsu == .T1a) && vN == 0 && vM == 0 {
            stageLabel.text = "Stage 0"
        }
        if (myShintatsu == .T0 || myShintatsu == .T1a) && vN == 1 && vM == 0 {
            stageLabel.text = "Stage II"
        }
        if (myShintatsu == .T0 || myShintatsu == .T1a) && vN == 2 && vM == 0 {
            stageLabel.text = "Stage II"
        }
        if (myShintatsu == .T0 || myShintatsu == .T1a) && vN == 3 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if (myShintatsu == .T0 || myShintatsu == .T1a) && vN == 4 && vM == 0 {
            stageLabel.text = "Stage IVa"
        }
        if myShintatsu == .T1b && vN == 0 && vM == 0 {
            stageLabel.text = "Stage I"
        }
        if myShintatsu == .T1b && vN == 1 && vM == 0 {
            stageLabel.text = "Stage II"
        }
        if myShintatsu == .T1b && vN == 2 && vM == 0 {
            stageLabel.text = "Stage II"
        }
        if myShintatsu == .T1b && vN == 3 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if myShintatsu == .T1b && vN == 4 && vM == 0 {
            stageLabel.text = "Stage IVa"
        }
        if myShintatsu == .T2 && vN == 0 && vM == 0 {
            stageLabel.text = "Stage II"
        }
        if myShintatsu == .T2 && vN == 1 && vM == 0 {
            stageLabel.text = "Stage II"
        }
        if myShintatsu == .T2 && vN == 2 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if myShintatsu == .T2 && vN == 3 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if myShintatsu == .T2 && vN == 4 && vM == 0 {
            stageLabel.text = "Stage IVa"
        }
        if myShintatsu == .T3 && vN == 0 && vM == 0 {
            stageLabel.text = "Stage II"
        }
        if myShintatsu == .T3 && vN == 1 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if myShintatsu == .T3 && vN == 2 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if myShintatsu == .T3 && vN == 3 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if myShintatsu == .T3 && vN == 4 && vM == 0 {
            stageLabel.text = "Stage IVa"
        }
        if myShintatsu == .T4a && vN == 0 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if myShintatsu == .T4a && vN == 1 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if myShintatsu == .T4a && vN == 2 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if myShintatsu == .T4a && vN == 3 && vM == 0 {
            stageLabel.text = "Stage III"
        }
        if myShintatsu == .T4a && vN == 4 && vM == 0 {
            stageLabel.text = "Stage IVa"
        }
        if myShintatsu == .T4b && vM == 0 {
            stageLabel.text = "Stage IVa"
        }
        if vM == 1 {
            stageLabel.text = "Stage IVb"
        }
        //saveStringはSaveViewControllerのtableで表示される
        //detailStringはSaveDetailViewControllerのtextViewで表示される
        saveString = stageLabel.text!
        detailString = subtitles[0].title + subtitles[0].subArray[vSenkyobui] + "\n"
        detailString += subtitles[1].title + subtitles[1].subArray[vShintatsu] + "\n"
        detailString += subtitles[2].title + subtitles[2].subArray[vN] + "\n"
        detailString += subtitles[3].title + subtitles[3].subArray[vM] + "\n\n"
        detailString += tnmLabel.text! + " " + stageLabel.text!
    }
    
    @IBAction func myActionRUN(){
        myCalc()
    }//@IBAction func myActionRUN()
    
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
    
    @IBAction func myActionUpperLarge(){
        performSegue(withIdentifier: "toUpperLarge", sender: true)
    }
    
    @IBAction func myActionLowerLarge(){
        performSegue(withIdentifier: "toLowerLarge", sender: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUpperLarge" {
            let toUpperLarge = segue.destination as! EsoUpperLargeViewController
            toUpperLarge.vSenkyobui = vSenkyobui
        }//if segue.identifier == "toUpperLarge"
        if segue.identifier == "toLowerLarge" {
            let toLowerLarge = segue.destination as! EsoLowerLargeViewController
            toLowerLarge.vSenkyobui = vSenkyobui
        }//if segue.identifier == "toLowerLarge"
        if segue.identifier != "toUpperLarge" && segue.identifier != "toLowerLarge" {
            let sendText = segue.destination as! SaveViewController
            sendText.myText = appName.rawValue
        }
    }//override func prepare(for segue: UIStoryboardSegue, sender: Any?)

}//class EsoViewController: UIViewController
