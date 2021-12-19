//
//  BreastViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/03.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit
import CoreData

class BreastViewController: UIViewController {
    
    let appName:AppName = .nyugan
    
    @IBOutlet var pdfView:PDFView!
    @IBOutlet var genpatsu:UISegmentedControl!
    @IBOutlet var kyohekikotei:UISegmentedControl!
    @IBOutlet var hifufushu:UISegmentedControl!
    @IBOutlet var enshosei:UISegmentedControl!
    @IBOutlet var ekikakadoButton:UIButton!
    @IBOutlet var ekikakoteiButton:UIButton!
    @IBOutlet var kyokotsuboButton:UIButton!
    @IBOutlet var sakotsukaButton:UIButton!
    @IBOutlet var sakotsujoButton:UIButton!
    @IBOutlet var meta:UISegmentedControl!
    @IBOutlet var tnmLabel:UILabel!
    @IBOutlet var stageLabel:UILabel!
    @IBOutlet var ekikakadoCheck:UILabel!
    @IBOutlet var ekikakoteiCheck:UILabel!
    @IBOutlet var kyokotsuboCheck:UILabel!
    @IBOutlet var sakotsukaCheck:UILabel!
    @IBOutlet var sakotsujoCheck:UILabel!
    @IBOutlet var hishinjunLabel:UILabel!
    @IBOutlet var genpatsuLabel:UILabel!
    @IBOutlet var kyohekikoteiLabel:UILabel!
    @IBOutlet var hifunofushuLabel:UILabel!
    @IBOutlet var enshoseiLabel:UILabel!
    @IBOutlet var shozokurinpaLabel:UILabel!
    @IBOutlet var enkakuteniLabel:UILabel!
    @IBOutlet var saveButton:UIBarButtonItem!
    @IBOutlet var hozonzumiButton:UIBarButtonItem!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var isEkikakado = false
    var isEkikakotei = false
    var isKyokotsubo = false
    var isSakotsuka = false
    var isSakotsujo = false
    
    let tumorSizeArray = ["原発巣を認めず",
                          "非浸潤癌あるいはPaget病",
                          "2cm以下",
                          "2cmをこえ、5cm以下",
                          "5cmをこえる"]
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = "Stage 0"
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
        hishinjunLabel.isHidden = true
        if let documentURL = Bundle.main.url(forResource: "BreastLN", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }
        }//if let documentURL
        showAll()
        checkAllCheck()
        calculate()
    }//override func viewDidLoad()
    
    func showAll(){
        genpatsuLabel.isHidden = false
        genpatsu.isHidden = false
        kyohekikoteiLabel.isHidden = false
        kyohekikotei.isHidden = false
        hifunofushuLabel.isHidden = false
        hifufushu.isHidden = false
        enshoseiLabel.isHidden = false
        enshosei.isHidden = false
        shozokurinpaLabel.isHidden = false
        ekikakadoButton.isHidden = false
        ekikakoteiButton.isHidden = false
        kyokotsuboButton.isHidden = false
        sakotsukaButton.isHidden = false
        sakotsujoButton.isHidden = false
        enkakuteniLabel.isHidden = false
        meta.isHidden = false
        hishinjunLabel.isHidden = true
        pdfView.isHidden = false
        checkAllCheck()
    }//func showAll()
    
    func hideAll(){
        kyohekikoteiLabel.isHidden = true
        kyohekikotei.isHidden = true
        hifunofushuLabel.isHidden = true
        hifufushu.isHidden = true
        enshoseiLabel.isHidden = true
        enshosei.isHidden = true
        shozokurinpaLabel.isHidden = true
        ekikakadoButton.isHidden = true
        ekikakoteiButton.isHidden = true
        kyokotsuboButton.isHidden = true
        sakotsukaButton.isHidden = true
        sakotsujoButton.isHidden = true
        enkakuteniLabel.isHidden = true
        meta.isHidden = true
        hishinjunLabel.isHidden = false
        pdfView.isHidden = true
        hideAllCheck()
    }
    
    func hideAllCheck(){
        ekikakadoCheck.isHidden = true
        ekikakoteiCheck.isHidden = true
        kyokotsuboCheck.isHidden = true
        sakotsukaCheck.isHidden = true
        sakotsujoCheck.isHidden = true
    }//func hideAllCheck()
    
    func checkAllCheck(){
        if isEkikakado {
            ekikakadoCheck.isHidden = false
        }
        else{
            ekikakadoCheck.isHidden = true
        }
        if isEkikakotei {
            ekikakoteiCheck.isHidden = false
        }
        else{
            ekikakoteiCheck.isHidden = true
        }
        if isKyokotsubo {
            kyokotsuboCheck.isHidden = false
        }
        else{
            kyokotsuboCheck.isHidden = true
        }
        if isSakotsuka {
            sakotsukaCheck.isHidden = false
        }
        else{
            sakotsukaCheck.isHidden = true
        }
        if isSakotsujo {
            sakotsujoCheck.isHidden = false
        }
        else{
            sakotsujoCheck.isHidden = true
        }
    }//func checkAllCheck()
    
    @IBAction func selectorChanged(){
        calculate()
    }
    
    @IBAction func ekikakadoAction(){
        isEkikakado.toggle()
        checkAllCheck()
        calculate()
    }
    
    @IBAction func ekikakoteiAction(){
        isEkikakotei.toggle()
        checkAllCheck()
        calculate()
    }
    
    @IBAction func kyokotsuboAction(){
        isKyokotsubo.toggle()
        checkAllCheck()
        calculate()
    }
    
    @IBAction func sakotsukaAction(){
        isSakotsuka.toggle()
        checkAllCheck()
        calculate()
    }
    
    @IBAction func sakotsujoAction(){
        isSakotsujo.toggle()
        checkAllCheck()
        calculate()
    }
    
    func calculate(){
        let vGenpatsu = genpatsu.selectedSegmentIndex
        let vKyohekikotei = kyohekikotei.selectedSegmentIndex
        let vHifufushu = hifufushu.selectedSegmentIndex
        let vEnshosei = enshosei.selectedSegmentIndex
        var vT = 0
        var tString = "T0"
        if vGenpatsu == 0 && vKyohekikotei == 0 && vHifufushu == 0 && vEnshosei == 0 {
            vT = 0
            tString = "T0"
        }
        if vGenpatsu == 1{
            vT = -1
            tString = "Tis"
        }
        if vGenpatsu == 2 && vKyohekikotei == 0 && vHifufushu == 0 && vEnshosei == 0 {
            vT = 1
            tString = "T1"
        }
        if vGenpatsu == 3 && vKyohekikotei == 0 && vHifufushu == 0 && vEnshosei == 0 {
            vT = 2
            tString = "T2"
        }
        if vGenpatsu == 4 && vKyohekikotei == 0 && vHifufushu == 0 && vEnshosei == 0 {
            vT = 3
            tString = "T3"
        }
        if vKyohekikotei == 1 && vHifufushu == 0 && vEnshosei == 0 {
            vT = 4
            tString = "T4a"
        }
        if vKyohekikotei == 0 && vHifufushu == 1 && vEnshosei == 0 {
            vT = 5
            tString = "T4b"
        }
        if vKyohekikotei == 1 && vHifufushu == 1 && vEnshosei == 0 {
            vT = 6
            tString = "T4c"
        }
        if vEnshosei == 1 {
            vT = 7
            tString = "T4d"
        }
        var vN = 0
        var nString = "N0"
        if isEkikakado == false && isEkikakotei == false && isKyokotsubo == false && isSakotsuka == false && isSakotsujo == false{
            vN = 0
            nString = "N0"
        }
        if isEkikakado == true && isEkikakotei == false && isKyokotsubo == false && isSakotsuka == false && isSakotsujo == false{
            vN = 1
            nString = "N1"
        }
        if isEkikakotei == true && isKyokotsubo == false && isSakotsuka == false && isSakotsujo == false{
            vN = 2
            nString = "N2a"
        }
        if isEkikakado == false && isEkikakotei == false && isKyokotsubo == true && isSakotsuka == false && isSakotsujo == false{
            vN = 3
            nString = "N2b"
        }
        if isSakotsuka == true && isSakotsujo == false{
            vN = 4
            nString = "N3a"
        }
        if (isEkikakado == true || isEkikakotei == true) && isKyokotsubo == true && isSakotsujo == false {
            vN = 5
            nString = "N3b"
        }
        if isSakotsujo {
            vN = 6
            nString = "N3c"
        }
        let vM = meta.selectedSegmentIndex
        var mString = "M0"
        if vM == 1 {
            mString = "M1"
        }
        if vGenpatsu == 1 {
            vT = -1
            tnmLabel.text = "Tis N0 M0"
            stageLabel.text = "Stage 0"
            hideAll()
        }
        else{
            showAll()
            if vT == 0 && vN == 0 && vM == 0 {
                stageLabel.text = "該当なし"
            }
            if vT == 1 && vN == 0 && vM == 0 {
                stageLabel.text = "Stage I"
            }
            if vT == 0 && vN == 1 && vM == 0 {
                stageLabel.text = "Stage IIA"
            }
            if vT == 1 && vN == 1 && vM == 0 {
                stageLabel.text = "Stage IIA"
            }
            if vT == 2 && vN == 0 && vM == 0 {
                stageLabel.text = "Stage IIA"
            }
            if vT == 2 && vN == 1 && vM == 0 {
                stageLabel.text = "Stage IIB"
            }
            if vT == 3 && vN == 0 && vM == 0 {
                stageLabel.text = "Stage IIB"
            }
            if vT == 0 && (vN == 2 || vN == 3) && vM == 0 {
                stageLabel.text = "Stage IIIA"
            }
            if vT == 1 && (vN == 2 || vN == 3) && vM == 0 {
                stageLabel.text = "Stage IIIA"
            }
            if vT == 2 && (vN == 2 || vN == 3) && vM == 0 {
                stageLabel.text = "Stage IIIA"
            }
            if vT == 3 && (vN == 2 || vN == 3) && vM == 0 {
                stageLabel.text = "Stage IIIA"
            }
            if vT >= 4 && vN <= 3 && vM == 0 {
                stageLabel.text = "Stage IIIB"
            }
            if vN >= 4 && vM == 0 {
                stageLabel.text = "Stage IIIC"
            }
            if vM == 1 {
                stageLabel.text = "Stage IV"
            }
            tnmLabel.text = "\(tString) \(nString) \(mString)"
        }//else
        //saveStringはSaveViewControllerのtableで表示される
        //detailStringはSaveDetailViewControllerのtextViewで表示される
        saveString = stageLabel.text!
        detailString = tumorSizeArray[vGenpatsu] + "\n"
        if vKyohekikotei == 0 {
            detailString += "胸壁固定なし\n"
        }
        else {
            detailString += "胸壁固定あり\n"
        }
        if vHifufushu == 0 {
            detailString += "皮膚の浮腫、潰瘍、衛生皮膚結節なし\n"
        }
        else {
            detailString += "皮膚の浮腫、潰瘍、衛生皮膚結節あり\n"
        }
        if vEnshosei == 0 {
            detailString += "炎症性乳癌ではない\n"
        }
        else {
            detailString += "炎症性乳癌である\n"
        }
        if !isEkikakado && !isEkikakotei && !isKyokotsubo && !isSakotsuka && !isSakotsujo {
            detailString += "N0:所属リンパ節転移なし\n"
        }
        if isEkikakado {
            detailString += "可動性の同側腋窩リンパ節転移あり\n"
        }
        if isEkikakotei {
            detailString += "固定または癒着した同側腋窩リンパ節転移あり\n"
        }
        if isKyokotsubo {
            detailString += "同側内胸リンパ節転移あり\n"
        }
        if isSakotsuka {
            detailString += "同側鎖骨下リンパ節転移あり\n"
        }
        if isSakotsujo {
            detailString += "同側鎖骨上リンパ節転移あり\n"
        }
        if vM == 0 {
            detailString += "M0:遠隔転移なし\n\n"
        }
        else {
            detailString += "M1:遠隔転移あり\n\n"
        }
        detailString += "\(tnmLabel.text!) \(stageLabel.text!)"
        if vGenpatsu == 1 {
            detailString = "非浸潤癌あるいはPaget病(Tis N0 M0 Stage 0)"
        }
    }//func calculate()
    
   @IBAction func doReset(){
        isEkikakado = false
        isEkikakotei = false
        isKyokotsubo = false
        isSakotsuka = false
        isSakotsujo = false
        showAll()
        tnmLabel.text = "T0 N0 M0"
        stageLabel.text = "該当なし"
        genpatsu.selectedSegmentIndex = 0
        kyohekikotei.selectedSegmentIndex = 0
        hifufushu.selectedSegmentIndex = 0
        enshosei.selectedSegmentIndex = 0
        meta.selectedSegmentIndex = 0
        calculate()
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
    
}//class BreastViewController: UIViewController
