//
//  ChildViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/02/17.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class ChildViewController: UIViewController {
    
    let appName:AppName = .child
    
    @IBOutlet var tbil:UISegmentedControl!
    @IBOutlet var alb:UISegmentedControl!
    @IBOutlet var PT:UISegmentedControl!
    @IBOutlet var ascites:UISegmentedControl!
    @IBOutlet var nosho:UISegmentedControl!
    @IBOutlet var childClass:UILabel!
    @IBOutlet var point:UILabel!
    @IBOutlet var saveButton:UIBarButtonItem!
    @IBOutlet var hozonzumiButton:UIBarButtonItem!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var vBil = 1
    var vAlb = 1
    var vPT = 1
    var vAscites = 1
    var vNosho = 1
    var vPoint = 5
    //saveStringはSaveViewControllerのtableで表示される
    //detailStringはSaveDetailViewControllerのtextViewで表示される
    var saveString = "A5"
    var detailString = ""
    typealias SubTitles = (title: String, subArray: Array<String>)
    var subtitles = [SubTitles]()
    
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
        subtitles.append(("総ビリルビン(mg/dl) ",["2.0未満","2.0-3.0","3.0超"]))
        subtitles.append(("アルブミン(g/dl) ",["3.5超","2.8-3.5","2.8未満"]))
        subtitles.append(("PT(%) ",["70超","40-70","40未満"]))
        subtitles.append(("腹水 ",["なし","少量","中等度"]))
        subtitles.append(("脳症 ",["なし","軽度","高度"]))
        calc()
    }
    
    func calc(){
        vBil = tbil.selectedSegmentIndex + 1
        vAlb = alb.selectedSegmentIndex + 1
        vPT = PT.selectedSegmentIndex + 1
        vAscites = ascites.selectedSegmentIndex + 1
        vNosho = nosho.selectedSegmentIndex + 1
        vPoint = vBil + vAlb + vPT + vAscites + vNosho
        switch vPoint {
        case 5 ... 6:
            childClass.text = "A"
        case 7 ... 9:
            childClass.text = "B"
        case 10 ... 15:
            childClass.text = "C"
        default:
            break
        }
        //saveStringはSaveViewControllerのtableで表示される
        //detailStringはSaveDetailViewControllerのtextViewで表示される
        saveString = childClass.text! + "\(vPoint)"
        detailString = subtitles[0].title + subtitles[0].subArray[vBil - 1] + "\n"
        detailString += subtitles[1].title + subtitles[1].subArray[vAlb - 1] + "\n"
        detailString += subtitles[2].title + subtitles[2].subArray[vPT - 1] + "\n"
        detailString += subtitles[3].title + subtitles[3].subArray[vAscites - 1] + "\n"
        detailString += subtitles[4].title + subtitles[4].subArray[vNosho - 1] + "\n\n"
        detailString += "Child \(childClass.text!) \(vPoint)点"
        point.text = String(vPoint)
    }//func calc()
    
    @IBAction func myActionRUN(){
        calc()
    }//@IBAction func myActionRUN()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sendText = segue.destination as! SaveViewController
        sendText.myText = appName.rawValue
    }
    
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
    
}//class ChildViewController: UIViewController
