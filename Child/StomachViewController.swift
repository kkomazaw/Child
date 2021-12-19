//
//  StomachViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/02/17.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit
import CoreData

class StomachViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let appName:AppName = .igan
    
    @IBOutlet var rinshoOrByori:UISegmentedControl!
    @IBOutlet var pdfView:PDFView!
    @IBOutlet var shintatsuView:PDFView!
    @IBOutlet var shintatsu:UIPickerView!
    @IBOutlet var lymph:UIPickerView!
    @IBOutlet var meta:UISegmentedControl!
    @IBOutlet var tnmLabel:UILabel!
    @IBOutlet var stageLabel:UILabel!
    @IBOutlet var saveButton:UIBarButtonItem!
    @IBOutlet var hozonzumiButton:UIBarButtonItem!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = "Stage I"
    var detailString = ""
    typealias SubTitles = (title: String, subArray: Array<String>)
    var subtitles = [SubTitles]()
    
    enum Shintatsu:String {
        case T1a = "T1a"
        case T1b = "T1b"
        case T2 = "T2"
        case T3 = "T3"
        case T4a = "T4a"
        case T4b = "T4b"
    }
    
    enum ByoriLymph:String {
        case N0 = "N0"
        case N1 = "N1"
        case N2 = "N2"
        case N3a = "N3a"
        case N3b = "N3b"
    }
    
    var isRinsho = true
    
    var myShintatsu:Shintatsu = .T1a
    var myByoriLymph:ByoriLymph = .N0
    let lymphRinshoRows = ["0","1~2個","3~6個","7個以上"]
    let lymphRinshoDetails = ["N0:領域リンパ節に転移を認めない", "N1:領域リンパ節に1~2個の転移を認める","N2:領域リンパ節に3~6個の転移を認める","N3:領域リンパ節に7個以上の転移を認める"]
    let lymphByoriRows = ["0","1~2個","3~6個","7~15個","16以上"]
    let lymphByoriDetails = ["N0:領域リンパ節に転移を認めない", "N1:領域リンパ節に1~2個の転移を認める","N2:領域リンパ節に3~6個の転移を認める","N3a:領域リンパ節に7~15個の転移を認める","N3b:領域リンパ節に16個以上の転移を認める"]
    
    var twoDimArray = [[String]]()
    var selectedPicker = [Int]()
    
    let shintatsuFileNames = ["stomachM","stomachSM","stomachMP","stomachSS","stomachSE","stomachSI"]
    
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
        if let documentURL = Bundle.main.url(forResource: "stomachM", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                shintatsuView.document = document
                shintatsuView.displayMode = .singlePage
                shintatsuView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
        if let documentURL = Bundle.main.url(forResource: "stomachLN", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
        for _ in 0 ... 1 {
            twoDimArray.append([])
        }
        twoDimArray[0] = ["M","SM","MP","SS","SE","SI"]
        twoDimArray[1] = lymphRinshoRows
        selectedPicker = [0,0]
        subtitles.append(("壁深達度 ",["T1a (M):癌が粘膜内にとどまる","T1b (SM):癌が粘膜下層にとどまる","T2 (MP):癌が粘膜下組織を超えているが、固有筋層にとどまる","T3 (SS):癌が固有筋層を超えているが、漿膜下組織にとどまる","T4a (SE):癌が漿膜表面に接しているか、またはこれを破って腹腔に露出","T4b (SI):癌が直接他臓器まで及ぶ"]))
        subtitles.append(("リンパ節転移 ",lymphRinshoDetails))
        subtitles.append(("遠隔臓器転移 ",["M0:遠隔臓器転移を認めない","M1:遠隔臓器転移を認める"]))
        myCalc()
    }//override func viewDidLoad()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return twoDimArray[pickerView.tag].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return twoDimArray[pickerView.tag][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPicker[pickerView.tag] = row
        if pickerView.tag == 0 {
            if let documentURL = Bundle.main.url(forResource: shintatsuFileNames[row], withExtension: "pdf") {
                if let document = PDFDocument(url: documentURL) {
                    shintatsuView.document = document
                }//if let document = PDFDocument
            }//if let documentURL = Bundle.main.url
        }//if pickerView.tag == 0
        myCalc()
    }//func pickerView
    
    func myCalc(){
        let vShintatsu = selectedPicker[0]
        switch vShintatsu {
        case 0:
            myShintatsu = .T1a
        case 1:
            myShintatsu = .T1b
        case 2:
            myShintatsu = .T2
        case 3:
            myShintatsu = .T3
        case 4:
            myShintatsu = .T4a
        case 5:
            myShintatsu = .T4b
        default:
            break
        }//switch vShintatsu
        let vN = selectedPicker[1]
        let vM = meta.selectedSegmentIndex
        switch isRinsho {
        case true:
            if (myShintatsu == .T1a || myShintatsu == .T1b || myShintatsu == .T2) && vN == 0 && vM == 0 {
                stageLabel.text = "Stage I"
            }
            if (myShintatsu == .T1a || myShintatsu == .T1b || myShintatsu == .T2) && vN != 0 && vM == 0 {
                stageLabel.text = "Stage II A"
            }
            if (myShintatsu == .T3 || myShintatsu == .T4a) && vN == 0 && vM == 0 {
                stageLabel.text = "Stage II B"
            }
            if (myShintatsu == .T3 || myShintatsu == .T4a) && vN != 0 && vM == 0 {
                stageLabel.text = "Stage III"
            }
            if myShintatsu == .T4b && vM == 0 {
                stageLabel.text = "Stage IV A"
            }
            if vM == 1 {
                stageLabel.text = "Stage IV B"
            }
            if myShintatsu == .T1a || myShintatsu == .T1b {
                tnmLabel.text = "cT1 N\(vN) M\(vM)"
            }
            else {
                tnmLabel.text = "c\(myShintatsu.rawValue) N\(vN) M\(vM)"
            }
        case false:
            switch vN {
            case 0:
                myByoriLymph = .N0
            case 1:
                myByoriLymph = .N1
            case 2:
                myByoriLymph = .N2
            case 3:
                myByoriLymph = .N3a
            case 4:
                myByoriLymph = .N3b
            default:
                break
            }//switch vN
            if (myShintatsu == .T1a || myShintatsu == .T1b) && myByoriLymph == .N0 && vM == 0 {
                stageLabel.text = "Stage I A"
            }
            if (myShintatsu == .T1a || myShintatsu == .T1b) && myByoriLymph == .N1 && vM == 0 {
                stageLabel.text = "Stage I B"
            }
            if (myShintatsu == .T1a || myShintatsu == .T1b) && myByoriLymph == .N2 && vM == 0 {
                stageLabel.text = "Stage II A"
            }
            if (myShintatsu == .T1a || myShintatsu == .T1b) && myByoriLymph == .N3a && vM == 0 {
                stageLabel.text = "Stage II B"
            }
            if (myShintatsu == .T1a || myShintatsu == .T1b) && myByoriLymph == .N3b && vM == 0 {
                stageLabel.text = "Stage III B"
            }
            if myShintatsu == .T2 && myByoriLymph == .N0 && vM == 0 {
                stageLabel.text = "Stage I B"
            }
            if myShintatsu == .T2 && myByoriLymph == .N1 && vM == 0 {
                stageLabel.text = "Stage II A"
            }
            if myShintatsu == .T2 && myByoriLymph == .N2 && vM == 0 {
                stageLabel.text = "Stage II B"
            }
            if myShintatsu == .T2 && myByoriLymph == .N3a && vM == 0 {
                stageLabel.text = "Stage III A"
            }
            if myShintatsu == .T2 && myByoriLymph == .N3b && vM == 0 {
                stageLabel.text = "Stage III B"
            }
            if myShintatsu == .T3 && myByoriLymph == .N0 && vM == 0 {
                stageLabel.text = "Stage II A"
            }
            if myShintatsu == .T3 && myByoriLymph == .N1 && vM == 0 {
                stageLabel.text = "Stage II B"
            }
            if myShintatsu == .T3 && myByoriLymph == .N2 && vM == 0 {
                stageLabel.text = "Stage III A"
            }
            if myShintatsu == .T3 && myByoriLymph == .N3a && vM == 0 {
                stageLabel.text = "Stage III B"
            }
            if myShintatsu == .T3 && myByoriLymph == .N3b && vM == 0 {
                stageLabel.text = "Stage III C"
            }
            if myShintatsu == .T4a && myByoriLymph == .N0 && vM == 0 {
                stageLabel.text = "Stage II B"
            }
            if myShintatsu == .T4a && myByoriLymph == .N1 && vM == 0 {
                stageLabel.text = "Stage III A"
            }
            if myShintatsu == .T4a && myByoriLymph == .N2 && vM == 0 {
                stageLabel.text = "Stage III A"
            }
            if myShintatsu == .T4a && myByoriLymph == .N3a && vM == 0 {
                stageLabel.text = "Stage III B"
            }
            if myShintatsu == .T4a && myByoriLymph == .N3b && vM == 0 {
                stageLabel.text = "Stage III C"
            }
            if myShintatsu == .T4b && myByoriLymph == .N0 && vM == 0 {
                stageLabel.text = "Stage III A"
            }
            if myShintatsu == .T4b && myByoriLymph == .N1 && vM == 0 {
                stageLabel.text = "Stage III B"
            }
            if myShintatsu == .T4b && myByoriLymph == .N2 && vM == 0 {
                stageLabel.text = "Stage III B"
            }
            if myShintatsu == .T4b && myByoriLymph == .N3a && vM == 0 {
                stageLabel.text = "Stage III C"
            }
            if myShintatsu == .T4b && myByoriLymph == .N3b && vM == 0 {
                stageLabel.text = "Stage III C"
            }
            if vM == 1 {
                stageLabel.text = "Stage IV"
            }
            tnmLabel.text = "p\(myShintatsu) \(myByoriLymph) M\(vM)"
        }//switch isRinsho
        //saveStringはSaveViewControllerのtableで表示される
        //detailStringはSaveDetailViewControllerのtextViewで表示される
        var rinshoOrByoriPrefix = "c"
        if !isRinsho {rinshoOrByoriPrefix = "p"}
        saveString = "\(rinshoOrByoriPrefix)\(stageLabel.text!)"
        if isRinsho {
            detailString = "臨床分類\n\n"
        }
        else {
            detailString = "病理分類\n\n"
        }
        detailString += subtitles[0].title + subtitles[0].subArray[vShintatsu] + "\n"
        detailString += subtitles[1].title + subtitles[1].subArray[vN] + "\n"
        detailString += subtitles[2].title + subtitles[2].subArray[vM] + "\n\n"
        detailString += "\(tnmLabel.text!) \(stageLabel.text!)"
    }//func myCalc()
    
    @IBAction func myActionRUN(){
        myCalc()
    }//@IBAction func myActionRUN()
    
    @IBAction func myActionRinshoOrByori(){
        isRinsho.toggle()
        switch isRinsho {
        case true:
            twoDimArray[1] = lymphRinshoRows
            if selectedPicker[1] == 4 {
                selectedPicker[1] = 3
            }
            subtitles[1].subArray = lymphRinshoDetails
        case false:
            twoDimArray[1] = lymphByoriRows
            subtitles[1].subArray = lymphByoriDetails
        }//switch isRinsho
        lymph.reloadAllComponents()
        myCalc()
    }//@IBAction func myActionRinshoOrByori()
    
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

}//class StomachViewController: UIViewController
