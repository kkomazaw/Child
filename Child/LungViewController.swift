//
//  LungViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/05.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class LungViewController: UIViewController {
    
    let appName:AppName = .haigan
    
    @IBOutlet var TXButton:UIButton!
    @IBOutlet var TisButton:UIButton!
    @IBOutlet var T1miButton:UIButton!
    @IBOutlet var T1aButton:UIButton!
    @IBOutlet var T1bButton:UIButton!
    @IBOutlet var T1cButton:UIButton!
    @IBOutlet var T2aButton:UIButton!
    @IBOutlet var T2bButton:UIButton!
    @IBOutlet var T3Button:UIButton!
    @IBOutlet var T4Button:UIButton!
    @IBOutlet var TXChecker:UILabel!
    @IBOutlet var TisChecker:UILabel!
    @IBOutlet var T1miChecker:UILabel!
    @IBOutlet var T1aChecker:UILabel!
    @IBOutlet var T1bChecker:UILabel!
    @IBOutlet var T1cChecker:UILabel!
    @IBOutlet var T2aChecker:UILabel!
    @IBOutlet var T2bChecker:UILabel!
    @IBOutlet var T3Checker:UILabel!
    @IBOutlet var T4Checker:UILabel!
    @IBOutlet var TsugiButton:UIButton!
    @IBOutlet var TisChushakuLabel:UILabel!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = "St. 0"
    var detailString = "Tis 上皮内癌\n\nTis N0 M0 stage 0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lungT = 0
        lungN = 0
        lungM = 0
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        if height > 800.0 && height < 1000.0{
            myToolBar.frame = CGRect(x: 0, y: height * 0.92, width: width, height: height * 0.055)
        }
        if height > 1000.0 {
            myToolBar.frame = CGRect(x: 0, y: height * 0.94, width: width, height: height * 0.05)
        }
        hideAllCheckers()
        TXChecker.isHidden = false
        myToolBar.isHidden = true
    }
    
    func hideAllCheckers(){
        TXChecker.isHidden = true
        TisChecker.isHidden = true
        T1miChecker.isHidden = true
        T1aChecker.isHidden = true
        T1bChecker.isHidden = true
        T1cChecker.isHidden = true
        T2aChecker.isHidden = true
        T2bChecker.isHidden = true
        T3Checker.isHidden = true
        T4Checker.isHidden = true
        TsugiButton.isHidden = false
        myToolBar.isHidden = true
        TisChushakuLabel.isHidden = true
    }
    
    @IBAction func TXButtonTapped(){
        hideAllCheckers()
        TXChecker.isHidden = false
        lungT = 0
    }
    
    @IBAction func TisButtonTapped(){
        hideAllCheckers()
        TisChecker.isHidden = false
        TsugiButton.isHidden = true
        TisChushakuLabel.isHidden = false
        myToolBar.isHidden = false
        lungT = 1
    }
    
    @IBAction func T1miButtonTapped(){
        hideAllCheckers()
        T1miChecker.isHidden = false
        lungT = 2
    }
    
    @IBAction func T1aButtonTapped(){
        hideAllCheckers()
        T1aChecker.isHidden = false
        lungT = 3
    }
    
    @IBAction func T1bButtonTapped(){
        hideAllCheckers()
        T1bChecker.isHidden = false
        lungT = 4
    }
    
    @IBAction func T1cButtonTapped(){
        hideAllCheckers()
        T1cChecker.isHidden = false
        lungT = 5
    }
    
    @IBAction func T2aButtonTapped(){
        hideAllCheckers()
        T2aChecker.isHidden = false
        lungT = 6
    }
    
    @IBAction func T2bButtonTapped(){
        hideAllCheckers()
        T2bChecker.isHidden = false
        lungT = 7
    }
    
    @IBAction func T3ButtonTapped(){
        hideAllCheckers()
        T3Checker.isHidden = false
        lungT = 8
    }
    
    @IBAction func T4ButtonTapped(){
        hideAllCheckers()
        T4Checker.isHidden = false
        lungT = 9
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
            let id = self.appName.rawValue + "1Save"
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
        if segue.identifier != "toLungNext" {
            let sendText = segue.destination as! SaveViewController
            sendText.myText = appName.rawValue
        }
    }//override func prepare(for segue
    
    @IBAction func TsugiButtonTapped(){
        performSegue(withIdentifier: "toLungNext", sender: true)
    }
    
    @IBAction func fromLungNextToHome(_ Segue:UIStoryboardSegue){
        
    }
    
}
