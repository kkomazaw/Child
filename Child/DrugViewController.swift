//
//  DrugViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/04/07.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit

class DrugViewController: UIViewController {
    
    let appName:AppName = .yakubutsu
    
    @IBOutlet var ALTjissoku:UITextField!
    @IBOutlet var ALTseijo:UITextField!
    @IBOutlet var ALPjissoku:UITextField!
    @IBOutlet var ALPseijo:UITextField!
    @IBOutlet var TypeOfLiverDamage:UILabel!
    @IBOutlet var EnterButton:UIButton!
    @IBOutlet var ChusiOrToyochu:UISegmentedControl!
    @IBOutlet var ShokaiOrSaitoyo:UISegmentedControl!
    @IBOutlet var ToyochusiNissuLabel:UILabel!
    @IBOutlet var NissuSegment:UISegmentedControl!
    @IBOutlet var KeikaTitleLabel:UILabel!
    @IBOutlet var KeikaFiveSegment:UISegmentedControl!
    @IBOutlet var KeikaFourSegment:UISegmentedControl!
    @IBOutlet var KeikaLabel2:UILabel!
    @IBOutlet var KeikaLabel3:UILabel!
    @IBOutlet var KeikaLabel4:UILabel!
    @IBOutlet var KeikaLabel5:UILabel!
    @IBOutlet var KikenInshiLabel:UILabel!
    @IBOutlet var KikenInshiSegment:UISegmentedControl!
    @IBOutlet var kohanButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flagOfLiverDamage = 0
        myValue1 = 1
        myValue2 = 0
        myValue3 = 0
        myValue4 = 0
        myValue5 = 0
        myValue6 = 0
        myValue7 = 0
        myValue8 = 0
        vChusiOrToyochu = 0
        vShokaiOrSaitoyo = 0
        vNissuSegment = 0
        vKeikaSegment = 0
        vKikenInshiSegment = 0
        vYakubutsuIgainoGenin = 0
        vKakonoKanshogai = 0
        vKosankyu = 0
        vDLST = 0
        vGuzenNoSaitoyo = 0
        vTensu = 0
        zenhanText = ""
        KeikaFourSegment.isHidden = true
        TypeOfLiverDamage.text = ""
        ALTjissoku.becomeFirstResponder()
    }
    
    func Flag1DisplayKansaiboShogai(){
        KeikaTitleLabel.text = "2. 経過:投与中止後のALTのピーク値と正常上限との差"
        KeikaFiveSegment.isHidden = false
        KeikaFourSegment.isHidden = true
        KeikaLabel2.text = "② 30日後も50%未満の減少か再上昇"
        KeikaLabel3.text = "③ 不明または30日以内に50%未満の減少"
        KeikaLabel4.text = "④ 30日以内に50%以上の減少"
        KeikaLabel5.text = "⑤ 8日以内に50%以上の減少"
        KikenInshiLabel.text = "3. 危険因子（飲酒）"
        vChusiOrToyochu = ChusiOrToyochu.selectedSegmentIndex
        vShokaiOrSaitoyo = ShokaiOrSaitoyo.selectedSegmentIndex
        if vChusiOrToyochu == 1 {
            ToyochusiNissuLabel.text = "投与中止後の日数"
            NissuSegment.setTitle(">15日", forSegmentAt: 0)
            NissuSegment.setTitle("15日以内", forSegmentAt: 1)
        }//if vChusiOrToyochu == 1・・・中止後
        else{
            ToyochusiNissuLabel.text = "投与開始からの日数"
            if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 0 {
                NissuSegment.setTitle("<5日、>90日", forSegmentAt: 0)
                NissuSegment.setTitle("5~90日", forSegmentAt: 1)
            }//if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 0)
            if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 1 {
                NissuSegment.setTitle(">15日", forSegmentAt: 0)
                NissuSegment.setTitle("1~15日", forSegmentAt: 1)
            }//if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 1
        }//else・・・投与中
    }//func Flag1DisplayKansaiboShogai()
    
    func Flag2DisplayTanjuUttaiOrKongo(){
        KeikaTitleLabel.text = "2. 経過:投与中止後のALPのピーク値と正常上限との差"
        KeikaFiveSegment.isHidden = true
        KeikaFourSegment.isHidden = false
        KeikaLabel2.text = "② 不変、上昇、不明"
        KeikaLabel3.text = "③ 180日以内に50%未満の減少"
        KeikaLabel4.text = "④ 180日以内に50%以上の減少"
        KeikaLabel5.text = ""
        KikenInshiLabel.text = "3. 危険因子（飲酒または妊娠）"
        vChusiOrToyochu = ChusiOrToyochu.selectedSegmentIndex
        vShokaiOrSaitoyo = ShokaiOrSaitoyo.selectedSegmentIndex
        if vChusiOrToyochu == 1 {
            ToyochusiNissuLabel.text = "投与中止後の日数"
            NissuSegment.setTitle(">30日", forSegmentAt: 0)
            NissuSegment.setTitle("30日以内", forSegmentAt: 1)
        }//if vChusiOrToyochu == 1・・・中止後
        else{
            if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 0 {
                NissuSegment.setTitle("<5日、>90日", forSegmentAt: 0)
                NissuSegment.setTitle("5~90日", forSegmentAt: 1)
            }//if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 0
            if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 1 {
                NissuSegment.setTitle(">90日", forSegmentAt: 0)
                NissuSegment.setTitle("1~90日", forSegmentAt: 1)
            }//if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 1
        }//else・・・投与中
    }//func Flag2DisplayTanjuUttaiOrKongo()
    
    @IBAction func myActionEnter(){
        view.endEditing(true)
        flagOfLiverDamage = 0
        let vALTjissoku = Double(ALTjissoku.text!) ?? 0.0
        let vALTseijo = Double(ALTseijo.text!) ?? 0.0
        let vALPjissoku = Double(ALPjissoku.text!) ?? 0.0
        let vALPseijo = Double(ALPseijo.text!) ?? 0.0
        if vALTjissoku * vALTseijo * vALPjissoku * vALPseijo != 0 {
            let ALTALPratio = (vALTjissoku / vALTseijo) / (vALPjissoku / vALPseijo)
            if (vALTjissoku > vALTseijo * 2.0 && vALPjissoku <= vALPseijo) || ALTALPratio >= 5.0 {
                TypeOfLiverDamage.text = "肝細胞障害型"
                flagOfLiverDamage = 1
                Flag1DisplayKansaiboShogai()
            }//if vALTjissoku > vALTseijo * 2.0 && vALPjissoku <= vALPseijo
            if (vALTjissoku <= vALTseijo && vALPjissoku > vALPseijo * 2.0) || ALTALPratio <= 2 {
                TypeOfLiverDamage.text = "胆汁うっ滞型"
                flagOfLiverDamage = 2
                Flag2DisplayTanjuUttaiOrKongo()
            }//if vALTjissoku <= vALTseijo && vALPjissoku > vALPseijo * 2.0
            if (vALTjissoku > vALTseijo * 2.0 && vALPjissoku > vALPseijo) && (ALTALPratio > 2.0 && ALTALPratio < 5.0) {
                TypeOfLiverDamage.text = "混合型"
                flagOfLiverDamage = 2
                Flag2DisplayTanjuUttaiOrKongo()
            }//if vALTjissoku > vALTseijo * 2.0 && vALPjissoku > vALPseijo
        }//if vALTjissoku * vALTseijo * vALPjissoku * vALPseijo != 0
        if vALTjissoku <= vALTseijo * 2 && vALPjissoku <= vALPseijo {
            myAlert(messageString: "ALTが正常上限の2倍、もしくはALPが正常上限を越える症例が対象となります。")
        }//if vALTjissoku<vALTseijo*2 && vALPjissoku<vALPseijo
        else if flagOfLiverDamage == 0 {
            TypeOfLiverDamage.text = "いずれにも該当しない"
            myAlert(messageString: "いずれのタイプにも該当しません。数値を再入力して下さい。")
        }//else if flagOfLiverDamage==0
    }//@IBAction func myActionEnter()
    
    @IBAction func myActionKohan(){
        if flagOfLiverDamage == 0 {
            TypeOfLiverDamage.text = "いずれにも該当しない"
            myAlert(messageString: "いずれのタイプにも該当しません。数値を再入力して下さい。")
        }
        else{
            calc()
            performSegue(withIdentifier: "toDrugSubView", sender: true)
        }
    }//@IBAction func myActionKohan()
    
    func myAlert(messageString:String){
        let titleString = "数値再入力"
        let alert = UIAlertController(title:titleString,message: messageString,preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK",style: UIAlertAction.Style.default,handler:{(action:UIAlertAction!) -> Void in
        })
        alert.addAction(okAction)
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func calc(){
        zenhanText = TypeOfLiverDamage.text! + "\n"
        zenhanText += "ALT \(ALTjissoku.text!) (正常上限 \(ALTseijo.text!))\n"
        zenhanText += "ALP \(ALPjissoku.text!) (正常上限 \(ALPseijo.text!))\n\n"
        zenhanText += "1.発症までの期間\n"
        vChusiOrToyochu = ChusiOrToyochu.selectedSegmentIndex
        if vChusiOrToyochu == 0 {
            zenhanText += " 投与中の発症\n"
        }
        else {
            zenhanText += " 投与中止後の発症\n"
        }
        vShokaiOrSaitoyo = ShokaiOrSaitoyo.selectedSegmentIndex
        if vShokaiOrSaitoyo == 0 {
            zenhanText += " 初回投与\n"
        }
        else {
            zenhanText += " 再投与\n"
        }
        if vChusiOrToyochu == 1 {
            ToyochusiNissuLabel.text = "投与中止後の日数"
            if flagOfLiverDamage == 1 {
                NissuSegment.setTitle(">15日", forSegmentAt: 0)
                NissuSegment.setTitle("15日以内", forSegmentAt: 1)
            }//if flagOfLiverDamage == 1
            if flagOfLiverDamage == 2 {
                NissuSegment.setTitle(">30日", forSegmentAt: 0)
                NissuSegment.setTitle("30日以内", forSegmentAt: 1)
            }//if flagOfLiverDamage == 2
        }//if vChusiOrToyochu == 1 ・・・中止後
        else {
            ToyochusiNissuLabel.text = "投与開始からの日数"
            if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 0 {
                NissuSegment.setTitle("<5日、>90日", forSegmentAt: 0)
                NissuSegment.setTitle("5~90日", forSegmentAt: 1)
            }//if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 0
            if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 1 {
                NissuSegment.setTitle(">15日", forSegmentAt: 0)
                NissuSegment.setTitle("1~15日", forSegmentAt: 1)
            }//if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 1
            if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 0 {
                NissuSegment.setTitle("<5日、>90日", forSegmentAt: 0)
                NissuSegment.setTitle("5~90日", forSegmentAt: 1)
            }//if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 0
            if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 1 {
                NissuSegment.setTitle(">90日", forSegmentAt: 0)
                NissuSegment.setTitle("1~90日", forSegmentAt: 1)
            }//if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 1
        }//else・・・投与中
        zenhanText += ToyochusiNissuLabel.text! + " "
        vNissuSegment = NissuSegment.selectedSegmentIndex
        if vChusiOrToyochu == 1 {
            if flagOfLiverDamage == 1 {
                if vNissuSegment == 0 {
                    zenhanText += " 投与中止後の日数 >15日\n"
                }
                if vNissuSegment == 1 {
                    zenhanText += " 投与中止後の日数 15日以内\n"
                }
            }//if flagOfLiverDamage == 1
            if flagOfLiverDamage == 2 {
                if vNissuSegment == 0 {
                    zenhanText += " 投与中止後の日数 >30日\n"
                }
                if vNissuSegment == 1 {
                    zenhanText += " 投与中止後の日数 30日以内\n"
                }
            }//if flagOfLiverDamage == 2
        }//if vChusiOrToyochu == 1 ・・・中止後
        else {
            if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 0 {
                if vNissuSegment == 0 {
                    zenhanText += " 投与開始からの日数 <5日、>90日\n"
                }
                if vNissuSegment == 1 {
                    zenhanText += " 投与開始からの日数 5~90日\n"
                }
            }//if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 0
            if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 1 {
                if vNissuSegment == 0 {
                    zenhanText += " 投与開始からの日数 >15日\n"
                }
                if vNissuSegment == 1 {
                    zenhanText += " 投与開始からの日数 1~15日\n"
                }
            }//if flagOfLiverDamage == 1 && vShokaiOrSaitoyo == 1
            if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 0 {
                if vNissuSegment == 0 {
                    zenhanText += " 投与開始からの日数 <5日、>90日\n"
                }
                if vNissuSegment == 1 {
                    zenhanText += " 投与開始からの日数 5~90日\n"
                }
            }//if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 0
            if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 1 {
                if vNissuSegment == 0 {
                    zenhanText += " 投与開始からの日数 >90日\n"
                }
                if vNissuSegment == 1 {
                    zenhanText += " 投与開始からの日数 1~90日\n"
                }
            }//if flagOfLiverDamage == 2 && vShokaiOrSaitoyo == 1
        }//else・・・投与中
        if vChusiOrToyochu == 1 {
            myValue1 = vNissuSegment
        }
        else {
            myValue1 = vNissuSegment + 1
        }
        zenhanText += " ⇨ \(myValue1)点\n\n"
        if flagOfLiverDamage == 1 {
            vKeikaSegment = KeikaFiveSegment.selectedSegmentIndex
        }
        if flagOfLiverDamage == 2 {
            vKeikaSegment = KeikaFourSegment.selectedSegmentIndex
        }
        switch flagOfLiverDamage {
        case 0:
            break
        case 1://肝細胞障害型
            zenhanText += "2.経過:投与中止後のALTのピーク値と正常上限との差："
            switch vKeikaSegment {
            case 0:
                myValue2 = 0
                zenhanText += "投与続行および不明\n"
            case 1:
                myValue2 = -2
                zenhanText += "30日後も50%未満の減少か再上昇\n"
            case 2:
                myValue2 = 0
                zenhanText += "不明または30日以内に50%未満の減少\n"
            case 3:
                myValue2 = 2
                zenhanText += "30日以内に50%以上の減少\n"
            case 4:
                myValue2 = 3
                zenhanText += "8日以内に50%以上の減少\n"
            default:
                break
            }//switch vKeikaSegment
        case 2://胆汁うっ滞型または混合型
            zenhanText += "2.経過:投与中止後のALPのピーク値と正常上限との差："
            switch vKeikaSegment {
            case 0:
                myValue2 = 0
                zenhanText += "投与続行および不明\n"
            case 1:
                myValue2 = 0
                zenhanText += "不変、上昇、不明\n"
            case 2:
                myValue2 = 1
                zenhanText += "180日以内に50%未満の減少\n"
            case 3:
                myValue2 = 2
                zenhanText += "180日以内に50%以上の減少\n"
            default:
                break
            }//switch vKeikaSegment
        default:
            break
        }//switch flagOfLiverDamage
        zenhanText += " ⇨ \(myValue2)点\n\n"
        vKikenInshiSegment = KikenInshiSegment.selectedSegmentIndex
        myValue3 = vKikenInshiSegment
        if flagOfLiverDamage == 1 && vKikenInshiSegment == 0 {
            zenhanText += "3.危険因子（飲酒）なし\n"
        }
        if flagOfLiverDamage == 1 && vKikenInshiSegment == 1 {
            zenhanText += "3.危険因子（飲酒）あり\n"
        }
        if flagOfLiverDamage == 2 && vKikenInshiSegment == 0 {
            zenhanText += "3. 危険因子（飲酒または妊娠）なし\n"
        }
        if flagOfLiverDamage == 2 && vKikenInshiSegment == 1 {
            zenhanText += "3. 危険因子（飲酒または妊娠）あり\n"
        }
        zenhanText += " ⇨ \(myValue3)点\n\n"
    }//func calc()
    
    @IBAction func myActionChangeSegment(){
        calc()
    }
    
    @IBAction func myActionClear(){
        Flag1DisplayKansaiboShogai()
        ALTjissoku.becomeFirstResponder()
        ALTjissoku.text = ""
        ALTseijo.text = ""
        ALPjissoku.text = ""
        ALPseijo.text = ""
        TypeOfLiverDamage.text = ""
        ToyochusiNissuLabel.text = "投与開始からの日数"
        flagOfLiverDamage = 0
        ChusiOrToyochu.selectedSegmentIndex = 0
        ShokaiOrSaitoyo.selectedSegmentIndex = 0
        NissuSegment.selectedSegmentIndex = 0
        KeikaFiveSegment.selectedSegmentIndex = 0
        KikenInshiSegment.selectedSegmentIndex = 0
        vYakubutsuIgainoGenin = 0
        vKakonoKanshogai = 0
        vKosankyu = 0
        vDLST = 0
        vGuzenNoSaitoyo = 0
        zenhanText = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "toDrugSubView" {
            let sendText = segue.destination as! SaveViewController
            sendText.myText = appName.rawValue
        }//if segue.identifier != "toDrugSubView"
    }//override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    
    @IBAction func fromDrugSubToHome(_ Segue:UIStoryboardSegue){
        
    }

}
