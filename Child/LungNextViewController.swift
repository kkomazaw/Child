//
//  LungNextViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/05.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit
import CoreData

class LungNextViewController: UIViewController {
    
    let appName:AppName = .haigan
    
    @IBOutlet var pdfView:PDFView!
    @IBOutlet var NodeSegment:UISegmentedControl!
    @IBOutlet var MetaSegment:UISegmentedControl!
    @IBOutlet var tnmLabel:UILabel!
    @IBOutlet var stageLabel:UILabel!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    enum Tvalue:String {
        case TX = "TX"
        case Tis = "Tis"
        case T1mi = "T1mi"
        case T1a = "T1a"
        case T1b = "T1b"
        case T1c = "T1c"
        case T2a = "T2a"
        case T2b = "T2b"
        case T3 = "T3"
        case T4 = "T4"
    }
    
    enum Nvalue:String {
        case N0 = "N0"
        case N1 = "N1"
        case N2 = "N2"
        case N3 = "N3"
    }
    
    enum Mvalue:String {
        case M0 = "M0"
        case M1a = "M1a"
        case M1b = "M1b"
        case M1c = "M1c"
    }
    
    let tArray:Array<Tvalue> = [.TX, .Tis, .T1mi, .T1a, .T1b, .T1c, .T2a, .T2b, .T3, .T4]
    let nArray:Array<Nvalue> = [.N0, .N1, .N2, .N3]
    let mArray:Array<Mvalue> = [.M0, .M1a, .M1b, .M1c]
    
    var vT:Tvalue = .TX
    var vN:Nvalue = .N0
    var vM:Mvalue = .M0
    
    let tString = ["TX:原発腫瘍の存在が判定できない。あるいは、喀痰または気管支洗浄液細胞診でのみ陽性で画像診断や気管支鏡では観察できない",
                   "Tis:上皮内癌",
                   "T1mi:微小浸潤型:部分充実型を示し, 充実成分径 ≦ 0.5cm, 全体径 ≦ 3cm",
                   "T1a:充実部≦1cm, Tis•T1miに非該当",
                   "T1b:充実成分径>1cm, ≦2cm",
                   "T1c:充実成分径>2cm, ≦3cm",
                   "T2a:>3cm, ≦4㎝",
                   "T2b:>4cm, ≦5㎝",
                   "T3:充実成分径>5cmでかつ≦7cm，または充実成分径≦5cmでも以下のいずれかであるもの •壁側胸膜, 胸壁, 横隔神経, 心膜のいずれかに直接浸潤 •同一葉内の不連続な副腫瘍結節",
                   "T4:充実成分径>7cm, または大きさを問わず横隔膜, 縦隔, 心臓, 大血管, 気管, 反回神経, 食道, 椎体, 気管分岐部への浸潤, あるいは同側の異なった肺葉内の副腫瘍結節"]
    let nString = ["N0:リンパ節転移を認めない",
                   "N1:同側の1群リンパ節転移",
                   "N2:同側の2群リンパ節転移",
                   "N3:同側の3群リンパ節転移もしくは対側のリンパ節転移"]
    let mString = ["M0:遠隔転移なし",
                   "M1a:対側肺の副腫瘍結節、胸膜結節、悪性胸水•心嚢水",
                   "M1b:肺以外の一臓器への単発遠隔転移がある",
                   "M1c:肺以外の一臓器または多臓器への多発遠隔転移がある"]
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = "St. 0"
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
        if let documentURL = Bundle.main.url(forResource: "LungLN", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }
        }//if let documentURL = Bundle.main.url
        NodeSegment.selectedSegmentIndex = lungN
        MetaSegment.selectedSegmentIndex = lungM
        calculateStage()
    }//override func viewDidLoad()
    
    func calculateStage(){
        lungN = NodeSegment.selectedSegmentIndex
        lungM = MetaSegment.selectedSegmentIndex
        vT = tArray[lungT]
        vN = nArray[lungN]
        vM = mArray[lungM]
        stageLabel.text = "該当なし"
        if vT == .Tis && vN == .N0 && vM == .M0 {
            stageLabel.text = "St. 0"
        }
        if (vT == .T1mi || vT == .T1a) && vN == .N0 && vM == .M0 {
            stageLabel.text = "St. IA1"
        }
        if vT == .T1b && vN == .N0 && vM == .M0 {
            stageLabel.text = "St. IA2"
        }
        if vT == .T1c && vN == .N0 && vM == .M0 {
            stageLabel.text = "St. IA3"
        }
        if vT == .T2a && vN == .N0 && vM == .M0 {
            stageLabel.text = "St. IB"
        }
        if vT == .T2b && vN == .N0 && vM == .M0 {
            stageLabel.text = "St. IIA"
        }
        if vT == .T3 && vN == .N0 && vM == .M0 {
            stageLabel.text = "St. IIB"
        }
        if vT == .T4 && vN == .N0 && vM == .M0 {
            stageLabel.text = "St. IIIA"
        }
        if (vT == .T1a || vT == .T1b || vT == .T1c || vT == .T2a || vT == .T2b) && vN == .N1 && vM == .M0 {
            stageLabel.text = "St. IIB"
        }
        if (vT == .T3 || vT == .T4) && vN == .N1 && vM == .M0 {
            stageLabel.text = "St. IIIA"
        }
        if (vT == .T1a || vT == .T1b || vT == .T1c || vT == .T2a || vT == .T2b) && vN == .N2 && vM == .M0 {
            stageLabel.text = "St. IIIA"
        }
        if (vT == .T3 || vT == .T4) && vN == .N2 && vM == .M0 {
            stageLabel.text = "St. IIIB"
        }
        if (vT == .T1a || vT == .T1b || vT == .T1c || vT == .T2a || vT == .T2b) && vN == .N3 && vM == .M0 {
            stageLabel.text = "St. IIIB"
        }
        if (vT == .T3 || vT == .T4) && vN == .N3 && vM == .M0 {
            stageLabel.text = "St. IIIC"
        }
        if vM == .M1a || vM == .M1b {
            stageLabel.text = "St. IVA"
        }
        if vM == .M1c {
            stageLabel.text = "St. IVB"
        }
        tnmLabel.text = "\(vT.rawValue)\(vN.rawValue)\(vM.rawValue)"
        
        //saveStringはSaveViewControllerのtableで表示される
        //detailStringはSaveDetailViewControllerのtextViewで表示される
        saveString = stageLabel.text!
        detailString = "\(tString[lungT])\n\(nString[lungN])\n\(mString[lungM])\n\n"
        detailString += "\(tnmLabel.text!) \(stageLabel.text!)"
    }//func calculateStage()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "haigan2Save" {
            let sendText = segue.destination as! SaveViewController
            sendText.myText = appName.rawValue
        }
    }//override func prepare(for segue
    
    @IBAction func segmentChanged(){
        calculateStage()
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
            let id = self.appName.rawValue + "2Save"
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
    
    @IBAction func myActionHozonzumi(){
        performSegue(withIdentifier: "haigan2Save", sender: true)
    }

}//class LungNextViewController: UIViewController
