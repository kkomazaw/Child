//
//  KanganViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/02/17.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import CoreData

class KanganViewController: UIViewController {
    
    let appName:AppName = .kangan
    
    @IBOutlet var ganshu:UISegmentedControl!
    @IBOutlet var kazu:UISegmentedControl!
    @IBOutlet var okisa:UISegmentedControl!
    @IBOutlet var myakkan:UISegmentedControl!
    @IBOutlet var lymph:UISegmentedControl!
    @IBOutlet var meta:UISegmentedControl!
    @IBOutlet var tnmLabel:UILabel!
    @IBOutlet var saveButton:UIBarButtonItem!
    @IBOutlet var hozonzumiButton:UIBarButtonItem!
    @IBOutlet var myToolBar:UIToolbar!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var vGanshu = 0
    var vKazu = 0
    var vOkisa = 0
    var vMyakkan = 0
    var vT = 1
    var vN = 0
    var vM = 0
    var stage = "I"
    
    var saveString = ""
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
        subtitles.append(("数 ",["単発","多発"]))
        subtitles.append(("大きさ ",["2cm以下","2cm超"]))
        subtitles.append(("脈管侵襲 ",["なし","あり"]))
        subtitles.append(("リンパ節転移 ",["なし","あり"]))
        subtitles.append(("遠隔転移 ",["なし","あり"]))
        calc()
    }
    
    func calc(){
        vGanshu = ganshu.selectedSegmentIndex
        vKazu = kazu.selectedSegmentIndex
        vOkisa = okisa.selectedSegmentIndex
        vMyakkan = myakkan.selectedSegmentIndex
        
        vT = vKazu + vOkisa + vMyakkan + 1
        vN = lymph.selectedSegmentIndex
        vM = meta.selectedSegmentIndex
        
        stage = "I"
        if vT == 1 && vN == 0 && vM == 0{
            stage = "I"
        }
        if vT == 2 && vN == 0 && vM == 0{
            stage = "II"
        }
        if vT == 3 && vN == 0 && vM == 0{
            stage = "III"
        }
        if vT == 4 && vN == 0 && vM == 0{
            stage = "IV A"
        }
        if vN == 1 && vM == 0{
            stage = "IV A"
        }
        if vM == 1{
            stage = "IV B"
        }
        if vGanshu == 1 && vT == 4 && vN == 1 && vM == 0 {
            stage = "IV B"
        }
        tnmLabel.text = "T\(vT) N\(vN) M\(vM) stage \(stage)"
        saveString = "stage \(stage)"
        if vGanshu == 0 {
            detailString = "肝細胞癌\n\n"
        }
        else {
            detailString = "肝内胆管癌\n\n"
        }
        detailString += subtitles[0].title + subtitles[0].subArray[vKazu] + "\n"
        detailString += subtitles[1].title + subtitles[1].subArray[vOkisa] + "\n"
        detailString += subtitles[2].title + subtitles[2].subArray[vMyakkan] + "\n"
        detailString += subtitles[3].title + subtitles[3].subArray[vN] + "\n"
        detailString += subtitles[4].title + subtitles[4].subArray[vM] + "\n\n"
        detailString += tnmLabel.text!
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
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        // UIAlertControllerにtextFieldを追加
        alert.addTextField { (textField:UITextField!) -> Void in }
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}//class KanganViewController: UIViewController
