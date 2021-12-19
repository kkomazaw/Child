//
//  ColonViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/02/18.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit
import CoreData

class ColonViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let appName:AppName = .daichougan
    
    @IBOutlet var pdfView:PDFView!
    @IBOutlet var shintatsuView:PDFView!
    @IBOutlet var shintatsu:UIPickerView!
    @IBOutlet var lymph:UIPickerView!
    @IBOutlet var meta:UIPickerView!
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
        case Tis = "Tis"
        case T1a = "T1a"
        case T1b = "T1b"
        case T2 = "T2"
        case T3 = "T3"
        case T4a = "T4a"
        case T4b = "T4b"
    }
    
    enum Lymph:String {
        case N0 = "N0"
        case N1a = "N1a"
        case N1b = "N1b"
        case N2a = "N2a"
        case N2b = "N2b"
        case N3 = "N3"
    }
    
    enum Meta:String {
        case M0 = "M0"
        case M1a = "M1a"
        case M1b = "M1b"
        case M1c1 = "M1c1"
        case M1c2 = "M1c2"
    }
    
    var myShintatsu:Shintatsu = .T1a
    var myLymph:Lymph = .N0
    var myMeta:Meta = .M0
    
    var twoDimArray = [[String]]()
    var selectedPicker = [Int]()
    
    let shintatsuFileNames = ["colonM","colonSM1","colonSM2","colonMP","colonSS","colonSE","colonSI"]
    
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
        if let documentURL = Bundle.main.url(forResource: "colonM", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                shintatsuView.document = document
                shintatsuView.displayMode = .singlePage
                shintatsuView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
        if let documentURL = Bundle.main.url(forResource: "colonLN", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
        for _ in 0 ... 2 {
            twoDimArray.append([])
        }
        twoDimArray[0] = ["M","SM浅","SM深","MP","SS","SE","SI•AI"]
        twoDimArray[1] = ["なし",
                          "赤•青 1個",
                          "赤•青 2-3個",
                          "赤•青 4-6個",
                          "赤•青 7個以上",
                          "黄あり"]
        twoDimArray[2] = ["なし","1臓器","2臓器以上","腹膜転移のみ","腹膜+他臓器"]
        for _ in 0 ..< twoDimArray.count {
            selectedPicker.append(0)
        }
        subtitles.append(("壁深達度 ",["Tis (M):癌が粘膜内にとどまる","T1a (SM):癌が粘膜下層にとどまり、浸潤距離が1000μm未満である","T1b (SM):癌が粘膜下層にとどまり、浸潤距離が1000μm以上であるが固有筋層(MP)に及んでいない","T2 (MP):癌が固有筋層まで浸潤し、これを越えない","T3 (SS):癌が固有筋層を越えて浸潤している\n漿膜を有する部位では癌が漿膜下層にとどまる\n漿膜を有しない部位では癌が外膜までにとどまる","T4a (SE):癌が漿膜表面に接しているか、またはこれを破って腹腔に露出しているもの","T4b (SI•AI):癌が直接他臓器に浸潤している"]))
        subtitles.append(("リンパ節転移 ",["N0:領域リンパ節転移を認めない","N1a:腸管傍リンパ節と中間リンパ節の転移が1個","N1b:腸管傍リンパ節と中間リンパ節の転移が2-3個","N2a:腸管傍リンパ節と中間リンパ節の転移が4-6個","N2b:腸管傍リンパ節と中間リンパ節の転移が7個以上","N3:主リンパ節に転移を認める。下部直腸癌では主リンパ節あるいは側方リンパ節に転移を認める"]))
        subtitles.append(("遠隔臓器転移 ",["M0:遠隔臓器転移を認めない","M1a:1臓器に遠隔転移を認める","M1b:2臓器以上","M1c1:腹膜転移のみ","M1c2:腹膜転移と他臓器転移"]))
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
        let vTPicker = selectedPicker[0]
        let vNPicker = selectedPicker[1]
        let vMPicker = selectedPicker[2]
        switch vTPicker {
        case 0:
            myShintatsu = .Tis
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
        }//switch vTPicker
        switch vNPicker {
        case 0:
            myLymph = .N0
        case 1:
            myLymph = .N1a
        case 2:
            myLymph = .N1b
        case 3:
            myLymph = .N2a
        case 4:
            myLymph = .N2b
        case 5:
            myLymph = .N3
        default:
            break
        }//switch vNPicker
        switch vMPicker {
        case 0:
            myMeta = .M0
        case 1:
            myMeta = .M1a
        case 2:
            myMeta = .M1b
        case 3:
            myMeta = .M1c1
        case 4:
            myMeta = .M1c2
        default:
            break
        }
        tnmLabel.text = "\(myShintatsu) \(myLymph) \(myMeta)"
        if myShintatsu == .Tis && myLymph == .N0 && myMeta == .M0 {
            stageLabel.text = "Stage 0"
        }
        if (myShintatsu == .T1a || myShintatsu == .T1b) && myLymph == .N0 && myMeta == .M0 {
            stageLabel.text = "Stage I"
        }
        if (myShintatsu == .T1a || myShintatsu == .T1b) && (myLymph == .N1a || myLymph == .N1b || myLymph == .N2a) && myMeta == .M0 {
            stageLabel.text = "Stage IIIa"
        }
        if (myShintatsu == .T1a || myShintatsu == .T1b) && (myLymph == .N2b || myLymph == .N3) && myMeta == .M0 {
            stageLabel.text = "Stage IIIb"
        }
        if myShintatsu == .T2 && myLymph == .N0 && myMeta == .M0 {
            stageLabel.text = "Stage I"
        }
        if myShintatsu == .T2 && (myLymph == .N1a || myLymph == .N1b) && myMeta == .M0 {
            stageLabel.text = "Stage IIIa"
        }
        if myShintatsu == .T2 && (myLymph == .N2a || myLymph == .N2b || myLymph == .N3) && myMeta == .M0 {
            stageLabel.text = "Stage IIIb"
        }
        if myShintatsu == .T3 && myLymph == .N0 && myMeta == .M0 {
            stageLabel.text = "Stage IIa"
        }
        if myShintatsu == .T3 && (myLymph == .N1a || myLymph == .N1b || myLymph == .N2a) && myMeta == .M0 {
            stageLabel.text = "Stage IIIb"
        }
        if myShintatsu == .T3 && (myLymph == .N2b || myLymph == .N3) && myMeta == .M0 {
            stageLabel.text = "Stage IIIc"
        }
        if myShintatsu == .T4a && myLymph == .N0 && myMeta == .M0 {
            stageLabel.text = "Stage IIb"
        }
        if myShintatsu == .T4a && (myLymph == .N1a || myLymph == .N1b) && myMeta == .M0 {
            stageLabel.text = "Stage IIIb"
        }
        if myShintatsu == .T4a && (myLymph == .N2a || myLymph == .N2b || myLymph == .N3) && myMeta == .M0 {
            stageLabel.text = "Stage IIIc"
        }
        if myShintatsu == .T4b && myLymph == .N0 && myMeta == .M0 {
            stageLabel.text = "Stage IIc"
        }
        if myShintatsu == .T4b && (myLymph == .N1a || myLymph == .N1b || myLymph == .N2a || myLymph == .N2b || myLymph == .N3) && myMeta == .M0 {
            stageLabel.text = "Stage IIIc"
        }
        if myMeta == .M1a {
            stageLabel.text = "Stage IVa"
        }
        if myMeta == .M1b {
            stageLabel.text = "Stage IVb"
        }
        if myMeta == .M1c1 || myMeta == .M1c2 {
            stageLabel.text = "Stage IVc"
        }
        if myShintatsu == .Tis && (myLymph != .N0 || myMeta != .M0) {
            stageLabel.text = "該当なし"
        }
        //saveStringはSaveViewControllerのtableで表示される
        //detailStringはSaveDetailViewControllerのtextViewで表示される
        saveString = stageLabel.text!
        detailString = subtitles[0].title + subtitles[0].subArray[vTPicker] + "\n"
        detailString += subtitles[1].title + subtitles[1].subArray[vNPicker] + "\n"
        detailString += subtitles[2].title + subtitles[2].subArray[vMPicker] + "\n\n"
        detailString += "\(tnmLabel.text!) \(stageLabel.text!)"
    }//func myCalc()
    
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
    
}//class ColonViewController: UIViewController
