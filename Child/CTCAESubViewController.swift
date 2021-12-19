//
//  CTCAESubViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/04/02.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class CTCAESubViewController: UIViewController {
    
    let appName:AppName = .ctcae
    
    var detailText:String!
    
    @IBOutlet var myTextView:UITextView!
    @IBOutlet var gradeSelector:UISegmentedControl!
    @IBOutlet var maeBarButton:UIBarButtonItem!
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
        if let path = Bundle.main.path(forResource: detailText, ofType: "txt") {
            do {
                let content = try String(contentsOfFile: path)
                myTextView.text = content
            } catch  {
                myTextView.text = "ファイルの内容取得に失敗"
            }
        }else {
            myTextView.text = "指定されたファイルが見つかりません"
        }
        if detailText == "先天性,家族性,遺伝性障害" || detailText == "外科および内科処置" {
            self.maeBarButton.isEnabled = false
            self.maeBarButton.tintColor = UIColor.clear
        }
        else {
            self.maeBarButton.isEnabled = true
            self.maeBarButton.tintColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        }
        calc()
    }//override func viewDidLoad()
    
    func calc() {
        saveString = "\(detailText!) Gr.\(gradeSelector.selectedSegmentIndex + 1)"
        detailString = myTextView.text
    }
    
    @IBAction func selectorChanged() {
        calc()
    }
    
    @IBAction func myActionSave(){
        let titleString = "注釈入力"
        let messageString = "注釈（メモ、名前等）が入力できます\n（日付とGradeは自動的に入力されます）"
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
    
    @IBAction func hozonzumi(){
        let id = self.appName.rawValue + "Save"
        self.performSegue(withIdentifier: id, sender: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ctcaeSave" {
            let sendText = segue.destination as! SaveViewController
            sendText.myText = appName.rawValue
        }//if segue.identifier == "ctcaeSave"
    }//override func prepare(for segue
    
}//class CTCAESubViewController: UIViewController
