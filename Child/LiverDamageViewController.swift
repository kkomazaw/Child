//
//  LiverDamageViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/06.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class LiverDamageViewController: UIViewController {
    
    let appName:AppName = .liverdamage
    
    @IBOutlet var Ascites:UISegmentedControl!
    @IBOutlet var Tb:UISegmentedControl!
    @IBOutlet var Alb:UISegmentedControl!
    @IBOutlet var ICG:UISegmentedControl!
    @IBOutlet var PT:UISegmentedControl!
    @IBOutlet var LDamage:UILabel!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let ascitesString = ["腹水なし","腹水あるが、治療の効果あり","腹水あり、治療の効果少ない"]
    let bilString = ["血清ビリルビン値 2.0mg/dl未満","血清ビリルビン値 2.0mg/dl以上、3.0mg/dl以下","血清ビリルビン値 >3.0mg/dl"]
    let albString = ["血清アルブミン値 >3.5g/dl","血清アルブミン値 3.0g/dl以上、3.5g/dl以下","血清アルブミン値 3.0g/dl未満"]
    let icgString = ["ICG R15: 15%未満","ICG R15: 15%以上、40%以下","ICG R15: >40%"]
    let ptString = ["PT活性値 >80%","PT活性値 50%以上、80%以下","PT活性値 50%未満"]
    
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = "肝障害度 A"
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
        calc()
    }
    
    func calc(){
        var vA1 = 0, vA2 = 0 , vA3 = 0, vA4 = 0, vA5 = 0
        var vB1 = 0, vB2 = 0 , vB3 = 0, vB4 = 0, vB5 = 0
        var vC1 = 0, vC2 = 0 , vC3 = 0, vC4 = 0, vC5 = 0
        switch Ascites.selectedSegmentIndex {
        case 0:
            vA1 = 1
            vB1 = 0
            vC1 = 0
        case 1:
            vA1 = 0
            vB1 = 1
            vC1 = 0
        case 2:
            vA1 = 0
            vB1 = 0
            vC1 = 1
        default:
            break
        }//switch Ascites.selectedSegmentIndex
        switch Tb.selectedSegmentIndex {
        case 0:
            vA2 = 1
            vB2 = 0
            vC2 = 0
        case 1:
            vA2 = 0
            vB2 = 1
            vC2 = 0
        case 2:
            vA2 = 0
            vB2 = 0
            vC2 = 1
        default:
            break
        }//switch Tb.selectedSegmentIndex
        switch Alb.selectedSegmentIndex {
        case 0:
            vA3 = 1
            vB3 = 0
            vC3 = 0
        case 1:
            vA3 = 0
            vB3 = 1
            vC3 = 0
        case 2:
            vA3 = 0
            vB3 = 0
            vC3 = 1
        default:
            break
        }//switch Alb.selectedSegmentIndex
        switch ICG.selectedSegmentIndex {
        case 0:
            vA4 = 1
            vB4 = 0
            vC4 = 0
        case 1:
            vA4 = 0
            vB4 = 1
            vC4 = 0
        case 2:
            vA4 = 0
            vB4 = 0
            vC4 = 1
        default:
            break
        }//switch ICG.selectedSegmentIndex
        switch PT.selectedSegmentIndex {
        case 0:
            vA5 = 1
            vB5 = 0
            vC5 = 0
        case 1:
            vA5 = 0
            vB5 = 1
            vC5 = 0
        case 2:
            vA5 = 0
            vB5 = 0
            vC5 = 1
        default:
            break
        }//switch PT.selectedSegmentIndex
        let vAtotal = vA1 + vA2 + vA3 + vA4 + vA5
        let vBtotal = vB1 + vB2 + vB3 + vB4 + vB5
        let vCtotal = vC1 + vC2 + vC3 + vC4 + vC5
        LDamage.text = "肝障害度 A"
        if vCtotal >= 2 {
            LDamage.text = "肝障害度 C"
        }
        else if vBtotal >= 2 {
            LDamage.text = "肝障害度 B"
        }
        else if vAtotal == 3 && vBtotal == 1 && vCtotal == 1 {
            LDamage.text = "肝障害度 B"
        }
        //saveStringはSaveViewControllerのtableで表示される
        //detailStringはSaveDetailViewControllerのtextViewで表示される
        saveString = LDamage.text!
        detailString = ascitesString[Ascites.selectedSegmentIndex] + "\n"
        detailString += bilString[Tb.selectedSegmentIndex] + "\n"
        detailString += albString[Alb.selectedSegmentIndex] + "\n"
        detailString += icgString[ICG.selectedSegmentIndex] + "\n"
        detailString += ptString[PT.selectedSegmentIndex] + "\n\n"
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
    
}//class LiverDamageViewController: UIViewController
