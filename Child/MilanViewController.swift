//
//  MilanViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/13.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class MilanViewController: UIViewController {
    
    let appName:AppName = .milan
    
    @IBOutlet var TumorNumber:UISegmentedControl!
    @IBOutlet var TumorSize:UISegmentedControl!
    @IBOutlet var Metastasis:UISegmentedControl!
    @IBOutlet var VascularInvasion:UISegmentedControl!
    @IBOutlet var TekigoKijunnai:UILabel!
    @IBOutlet var Tekigokijungai:UILabel!
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
        Tekigokijungai.isHidden = true
        calc()
    }
    
    func calc() {
        let vTumorNumber = TumorNumber.selectedSegmentIndex
        let vTumorSize = TumorSize.selectedSegmentIndex
        let vMetastasis = Metastasis.selectedSegmentIndex
        let vVascularInvasion = VascularInvasion.selectedSegmentIndex
        if vTumorNumber == 0 && vTumorSize <= 1 && vMetastasis == 0 && vVascularInvasion == 0 {
            Tekigokijungai.isHidden = true
            TekigoKijunnai.isHidden = false
        }
        else if vTumorNumber == 1 && vTumorSize == 0 && vMetastasis == 0 && vVascularInvasion == 0 {
            Tekigokijungai.isHidden = true
            TekigoKijunnai.isHidden = false
        }
        else {
            Tekigokijungai.isHidden = false
            TekigoKijunnai.isHidden = true
        }
        if Tekigokijungai.isHidden == true {
            saveString = "基準内"
        }
        else {
            saveString = "基準外"
        }
        if vTumorNumber == 0 {
            detailString = "腫瘍の数：単発\n"
        }
        if vTumorNumber == 1 {
            detailString = "腫瘍の数：2-3個\n"
        }
        if vTumorNumber == 2 {
            detailString = "腫瘍の数：4個以上\n"
        }
        if vTumorSize == 0 {
            detailString += "最大腫瘍径：3cm以下\n"
        }
        if vTumorSize == 1 {
            detailString += "最大腫瘍径：5cm以下\n"
        }
        if vTumorSize == 2 {
            detailString += "最大腫瘍径：5cm超\n"
        }
        if vMetastasis == 0 {
            detailString += "肝外転移なし\n"
        }
        else {
            detailString += "肝外転移あり\n"
        }
        if vVascularInvasion == 0 {
            detailString += "肝内血管浸潤なし\n\n"
        }
        else {
            detailString += "肝内血管浸潤あり\n\n"
        }
        detailString += "ミラノ基準：\(saveString)"
    }//func calc()
    
    @IBAction func myActionRUN(){
        calc()
    }//@IBAction func myActionRUN()
    
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
    
}//class MilanViewController: UIViewController
