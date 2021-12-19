//
//  CTCAEViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/04/02.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit

class CTCAEViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let appName:AppName = .ctcae
    
    @IBOutlet var myCollectionView:UICollectionView!
    @IBOutlet var maeButton:UIButton!
    @IBOutlet var ichiranButton:UIButton!
    @IBOutlet var mySelector:UISegmentedControl!
    @IBOutlet var myTableView:UITableView!
    
    var unfilteredNFLTeams:Array<String> = []
    var filteredNFLTeams:Array<String> = []
    let searchController = UISearchController(searchResultsController: nil)
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredNFLTeams = unfilteredNFLTeams.filter {$0.lowercased().contains(searchText.lowercased())
            }
            let orderSet = NSOrderedSet(array: filteredNFLTeams)
            filteredNFLTeams = orderSet.array as! [String]
        } else {
            filteredNFLTeams = unfilteredNFLTeams
        }
        myTableView.reloadData()
    }//func updateSearchResults
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNFLTeams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Name", for: indexPath)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel!.text = filteredNFLTeams[indexPath.row]
        cell.textLabel?.minimumScaleFactor = 0.5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendText = filteredNFLTeams[indexPath.row]
        performSegue(withIdentifier: "toSubView", sender: true)
    }
    
    let diseaseArray = ["血液•リンパ","心臓","先天性,家族性,遺伝性障害",
                        "耳•迷路","内分泌","眼",
                        "胃腸","一般•全身障害•投与部位の状態","肝胆道系",
                        "免疫系","感染症•寄生虫","障害•中毒•処置•術中合併症",
                        "臨床検査","代謝•電解質•栄養障害","筋骨格•結合組織障害",
                        "良性•悪性•詳細不明の新生物","神経系","妊娠•産褥",
                        "精神障害","腎•尿路","生殖系•乳房",
                        "呼吸器•胸郭および縦隔障害","皮膚•皮下組織","社会環境",
                        "外科および内科処置","血管障害"]
    
    var twoDimArray = [[String]]()
    var isSelected = false
    var isSubtitles = false
    var diseaseRow = 0
    var selectedSub = ""
    var sendText = ""
    typealias SubTitles = (title: String, subArray: Array<String>)
    var subtitles = [SubTitles]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 26
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CTCAECollectionViewCell
        cell.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        var myText = ""
        if !isSelected {
            myText = diseaseArray[indexPath.row]
        }
        if isSelected, !isSubtitles {
            if indexPath.row <= twoDimArray[diseaseRow].count - 1 {
                myText = twoDimArray[diseaseRow][indexPath.row]
            }
        }//if isSelected, !isSubtitles
        if isSubtitles {
            if let index = subtitles.firstIndex(where: {$0.title == selectedSub}) {
                let myArray = subtitles[index].subArray
                if indexPath.row <= myArray.count - 1 {
                    myText = myArray[indexPath.row]
                }
            }
        }//if isSubtitles
        cell.Label.text = myText
        cell.Label.textColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        if myText.isEmpty {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }//func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let myBoundSize = UIScreen.main.bounds.size.width
        let heightSize = UIScreen.main.bounds.size.height
        let cellSize = myBoundSize / 3.05
        return CGSize(width: cellSize, height: heightSize / 13.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSelected, !isSubtitles, indexPath.row >= twoDimArray[diseaseRow].count {
            return
        }
        if !isSelected, twoDimArray[indexPath.row][0] == "final" {
            sendText = diseaseArray[indexPath.row]
            performSegue(withIdentifier: "toSubView", sender: true)
            return
        }
        if !isSelected, twoDimArray[indexPath.row][0] != "final" {
            isSelected = true
            diseaseRow = indexPath.row
            maeButton.isHidden = true
            ichiranButton.isHidden = false
            self.navigationItem.title = diseaseArray[diseaseRow]
            myCollectionView.reloadData()
            return
        }
        if isSelected, !isSubtitles {
            let i = twoDimArray[diseaseRow][indexPath.row]
            if !i.contains(">") {
                sendText = i
                if i == "その他" {
                    sendText += "(\(diseaseArray[diseaseRow]))"
                }
                performSegue(withIdentifier: "toSubView", sender: true)
            }
            else {
                selectedSub = i
                isSubtitles = true
                self.navigationItem.title = i
                maeButton.isHidden = false
                ichiranButton.isHidden = false
                myCollectionView.reloadData()
                return
            }//else
        }//if isSelected, !isSubtitles
        if isSubtitles {
            if let index = subtitles.firstIndex(where: {$0.title == selectedSub}) {
                let myArray = subtitles[index].subArray
                if indexPath.row <= myArray.count - 1 {
                    sendText = myArray[indexPath.row]
                    performSegue(withIdentifier: "toSubView", sender: true)
                }
            }
        }//if isSubtitles
    }//func collectionView(_ collectionView: UICollectionView, didSelectItemAt
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "検索"
        myTableView.tableHeaderView = searchController.searchBar
        maeButton.isHidden = true
        ichiranButton.isHidden = true
        myTableView.isHidden = true
        myCollectionView.isHidden = false
        self.navigationItem.title = "一覧"
        for _ in 0 ... 25{
            twoDimArray.append([])
        }
        twoDimArray[0] = ["貧血","骨髄細胞減少","播種性血管内凝固症候群",
                          "好酸球増加症",
                          "発熱性好中球減少症","溶血","溶血性尿毒症症候群",
                          "白血球増加症","リンパ節痛","メトヘモグロビン血症",
                          "血栓性血小板減少性紫斑病","その他"]
        twoDimArray[1] = ["大動脈弁疾患","心静止",
                          "心停止","胸痛(心臓性)","伝導障害",
                          "チアノーゼ","心不全","左室収縮機能障害",
                          "僧帽弁疾患","心筋梗塞","心筋炎",
                          "動悸","心嚢液貯留","心膜タンポナーデ",
                          "心膜炎","肺動脈弁疾患","拘束性心筋症",
                          "右室機能不全","三尖弁疾患","不整脈>",
                          "その他"]
        subtitles.append(("不整脈>",
                          ["心房細動","心房粗動","完全房室ブロック",
                           "第一度房室ブロック","モービッツ2型房室ブロック","モービッツ1型房室ブロック",
                           "発作性心房頻脈","洞不全症候群","洞性徐脈",
                           "洞性頻脈","上室性頻脈","心室性不整脈",
                           "心室細動","心室性頻脈"]))
        twoDimArray[2] = ["final"]
        twoDimArray[3] = ["耳痛","外耳痛",
                          "聴覚障害•成人","聴覚障害•小児","中耳の炎症",
                          "耳鳴","回転性めまい","前庭障害",
                          "その他"]
        twoDimArray[4] = ["副腎機能不全","クッシング様症状","思春期遅発症",
                          "成長促進","副甲状腺機能亢進症","甲状腺機能亢進症",
                          "副甲状腺機能低下症","下垂体炎","下垂体機能低下症","甲状腺機能低下症","思春期早発症","テストステロン欠乏症",
                          "男性化","その他"]
        twoDimArray[5] = ["霧視","白内障",
                          "角膜潰瘍","眼乾燥","外眼筋不全麻痺",
                          "眼痛","眼瞼機能障害","光のちらつき",
                          "浮遊物","緑内障","角膜炎",
                          "夜盲","視神経障害","視神経乳頭浮腫","眼窩周囲浮腫",
                          "羞明","網膜剥離","網膜裂孔",
                          "網膜血管障害","網膜症","強膜障害",
                          "ぶどう膜炎","視覚低下","硝子体出血","流涙",
                          "その他"]
        twoDimArray[6] = ["歯科•口腔>","食道>","胃>",
                          "十二指腸>","小腸>","結腸•直腸>",
                          "肛門>","膵臓>","腹腔•腹膜>",
                          "腹部愁訴>","腹水","乳び性腹水","おくび","便秘",
                          "下痢","嚥下障害","腸炎",
                          "腸膀胱瘻","便失禁","イレウス","内臓動脈虚血",
                          "その他"]
        subtitles.append(("歯科•口腔>",
                          ["口唇炎","齲歯","口内乾燥",
                           "歯肉痛","口唇痛","口腔知覚不全",
                           "口腔内出血","口腔内痛","歯周病",
                           "唾液管の炎症","唾液腺瘻","歯の発育障害",
                           "歯の変色","歯痛","口腔粘膜炎",
                           "口腔瘻"]))
        subtitles.append(("食道>",
                          ["食道瘻","食道出血","食道壊死",
                           "食道閉塞症","食道痛","食道穿孔",
                           "食道狭窄","食道潰瘍","食道静脈瘤出血",
                           "食道炎","胃食道逆流性疾患","上部消化管出血"]))
        subtitles.append(("胃>",
                          ["胃瘻","胃出血","胃壊死",
                           "胃穿孔","胃狭窄","胃潰瘍",
                           "胃炎","胃腸管瘻","胃不全麻痺",
                           "胃痛","胃閉塞","消化不良",
                           "上部消化管出血"]))
        subtitles.append(("十二指腸>",
                          ["十二指腸瘻","十二指腸出血","十二指腸閉塞",
                           "十二指腸穿孔","十二指腸狭窄","十二指腸潰瘍",
                           "上部消化管出血"]))
        subtitles.append(("小腸>",
                          ["回腸瘻","回腸出血","回腸閉塞",
                           "回腸穿孔","回腸狭窄","回腸潰瘍",
                           "空腸瘻","空腸出血","空腸閉塞",
                           "空腸穿孔","空腸狭窄","空腸潰瘍",
                           "小腸粘膜炎","小腸閉塞","小腸穿孔",
                           "小腸狭窄","小腸潰瘍","吸収不良",
                           "鼓腸"]))
        subtitles.append(("結腸•直腸>",
                          ["盲腸出血","大腸炎","結腸瘻",
                           "結腸出血","結腸閉塞","結腸穿孔",
                           "結腸狭窄","結腸潰瘍","直腸炎","直腸裂",
                           "直腸瘻","直腸出血","直腸粘膜炎",
                           "直腸壊死","直腸閉塞","直腸痛",
                           "直腸穿孔","直腸狭窄","直腸潰瘍",
                           "直腸炎","下部消化管出血"]))
        subtitles.append(("肛門>",
                          ["裂肛","痔瘻","痔出血","痔核",
                           "肛門壊死","肛門痛","肛門狭窄",
                           "肛門潰瘍","肛門出血","肛門粘膜炎"]))
        subtitles.append(("膵臓>",
                          ["膵管狭窄","膵瘻","膵臓出血",
                           "膵壊死","膵炎"]))
        subtitles.append(("腹腔•腹膜>",
                          ["腹腔内出血","腹膜壊死","後腹膜出血"]))
        subtitles.append(("腹部愁訴>",
                          ["腹部膨満","腹痛","腹部膨満感","おくび",
                           "消化不良","鼓腸","消化器痛",
                           "悪心","嘔吐","食道痛",
                           "胃痛","直腸痛","肛門痛"]))
        twoDimArray[7] = ["悪寒","新生児死亡","死亡NOS","疾患進行",
                          "顔面浮腫","四肢浮腫","体幹浮腫",
                          "顔面痛","疲労","発熱",
                          "インフルエンザ様症状","歩行障害","全身性浮腫","低体温",
                          "注入部位血管外漏出","注射部位反応",
                          "限局性浮腫","倦怠感",
                          "多臓器不全","頚部浮腫","非心臓性胸痛",
                          "疼痛","突然死NOS","ワクチン接種部位リンパ節腫脹","その他"]
        twoDimArray[8] = ["胆管狭窄","胆管瘻","バッドキアリ症候群","胆嚢炎",
                          "胆嚢瘻","胆嚢壊死","胆嚢閉塞",
                          "胆嚢痛","胆嚢穿孔","肝不全",
                          "肝出血","肝壊死","肝臓痛",
                          "胆管穿孔","門脈圧亢進症","門脈血栓症","類洞閉塞症候群",
                          "その他"]
        twoDimArray[9] = ["アレルギー反応","アナフィラキシー","自己免疫障害",
                          "サイトカイン放出症候群","血清病","その他"]
        twoDimArray[10] = ["消化器系>","神経系>","呼吸器系>", "心血管系>",
                           "腎•泌尿器系>","婦人科系>","眼科系>",
                           "耳鼻咽喉科系>","爪•皮膚科系>","筋骨格系>",
                           "菌血症•敗血症•真菌血症>","ウイルス再活性化>",
                           "乳房感染","カテーテル関連感染",
                           "医療機器関連感染",
                           "口唇感染","リンパ節感染",
                           "縦隔感染","粘膜感染","骨盤内感染",
                           "軟部組織感染","ストーマ部感染","カンジダ症","ウイルス血症",
                           "創傷感染","その他"]
        subtitles.append(("消化器系>",
                          ["腹部感染","肛門直腸感染","虫垂炎",
                           "穿孔性虫垂炎","胆道感染","盲腸感染",
                           "十二指腸感染","感染性小腸結腸炎","食道感染",
                           "胆嚢感染","歯肉感染","肝感染","B型肝炎再活性化",
                           "ウイルス性肝炎","膵感染","腹膜感染",
                           "小腸感染","歯感染","脾感染"]))
        subtitles.append(("神経系>",
                          ["脳神経感染","感染性脳炎","感染性脳脊髄炎","脊髄炎",
                           "髄膜炎","末梢神経感染"]))
        subtitles.append(("呼吸器系>",
                          ["気管支感染","肺感染","気管炎",
                           "上気道感染"]))
        subtitles.append(("心血管系>",
                          ["感染性動脈炎","感染性心内膜炎","胸膜感染","感染性静脈炎"]))
        subtitles.append(("腎•泌尿器系>",
                          ["膀胱感染","腎感染","陰茎感染",
                           "前立腺感染","陰嚢感染","尿道感染",
                           "尿路感染"]))
        subtitles.append(("婦人科系>",
                          ["感染性子宮頚管炎","卵巣感染","子宮感染",
                           "腟感染","外陰部感染"]))
        subtitles.append(("眼科系>",
                          ["結膜炎","感染性結膜炎","角膜感染","眼内炎",
                           "眼感染","眼窩周囲感染"]))
        subtitles.append(("耳鼻咽喉科系>",
                          ["外耳炎","中耳炎","咽頭炎",
                           "喉頭炎","感染性鼻炎","唾液腺感染",
                           "副鼻腔炎"]))
        subtitles.append(("爪•皮膚科系>",
                          ["爪感染","爪囲炎","毛包炎","丘疹膿疱性皮疹",
                           "膿疱性皮疹","皮膚感染","帯状疱疹"]))
        subtitles.append(("筋骨格系>",
                          ["感染性筋炎","関節の感染","骨感染"]))
        subtitles.append(("菌血症•敗血症•真菌血症>",
                          ["菌血症","敗血症","真菌血症"]))
        subtitles.append(("ウイルス再活性化>",
                          ["サイトメガロウイルス感染再燃","エプスタイン・バーウイルス感染再燃","B型肝炎再活性化","単純ヘルペス再燃","帯状疱疹"]))
        twoDimArray[11] = ["血管損傷>","術中損傷>","ウロストミー関連>",
                           "腸管ストーマ関連>","骨折>","吻合部漏出>","注入に伴う反応",
                           "挫傷","熱傷","放射線性皮膚炎",
                           "転倒","卵管穿孔","術後出血",
                           "術後胸部処置合併症","放射線照射リコール反応","漿液腫",
                           "吻合部潰瘍","気管出血","気管閉塞",
                           "気管切開部位出血","子宮穿孔","ワクチン接種合併症","血管確保合併症",
                           "創合併症","創離開","その他"]
        subtitles.append(("血管損傷>",
                          ["大動脈損傷","動脈損傷","頚動脈損傷",
                           "下大静脈損傷","頚静脈損傷","上大静脈損傷",
                           "静脈損傷"]))
        subtitles.append(("術中損傷>",
                          ["術中動脈損傷","術中乳房損傷","術中心臓損傷",
                           "術中耳部損傷","術中内分泌系損傷","術中消化管損傷",
                           "術中頭頚部損傷","術中出血","術中肝胆道系損傷",
                           "術中筋骨格系損傷","術中神経系損傷","術中眼損傷",
                           "術中腎損傷","術中生殖器系損傷","術中呼吸器系損傷",
                           "術中脾臓損傷","術中尿路損傷",
                           "術中静脈損傷"]))
        subtitles.append(("ウロストミー関連>",
                          ["ウロストミー部脱出","ウロストミー部漏出","ウロストミー部閉塞",
                           "ウロストミー部出血","ウロストミー部狭窄"]))
        subtitles.append(("腸管ストーマ関連>",
                          ["消化管ストーマ壊死","消化管ストーマ狭窄","腸管ストーマ部漏出",
                           "腸管ストーマ閉塞","腸管ストーマ部出血","腸管ストーマ脱出"]))
        subtitles.append(("骨折>",
                          ["足関節部骨折","骨折","股関節部骨折",
                           "脊椎骨折","手首関節骨折"]))
        subtitles.append(("吻合部漏出>",
                          ["胆管吻合部漏出","膀胱吻合部漏出","食道吻合部漏出",
                           "卵管吻合部漏出","胃吻合部漏出","胃腸吻合部漏出",
                           "腎吻合部漏出","大腸吻合部漏出","膵吻合部漏出",
                           "直腸吻合部漏出","小腸吻合部漏出","精索吻合部漏出",
                           "尿管吻合部漏出","子宮吻合部漏出","腟吻合部漏出",
                           "精管吻合部漏出","咽頭吻合部漏出"]))
        twoDimArray[12] = ["血算>","生化学>","下垂体ホルモン>",
                           "呼吸機能>","活性化部分トロンボプラスチン時間延長","心筋トロポニンI増加",
                           "心筋トロポニンT増加","血中重炭酸塩減少","CD4リンパ球減少","駆出率減少",
                           "QTc延長","心電図異常T波","フィブリノゲン減少","ハプトグロビン減少",
                           "INR増加","尿量減少","体重増加",
                           "体重減少","その他"]
        subtitles.append(("血算>",
                          ["ヘモグロビン増加","リンパ球数減少","リンパ球数増加",
                           "好中球数減少","白血球減少","血小板数減少"]))
        subtitles.append(("生化学>",
                          ["AST増加","ALT増加","ALP増加","血中乳酸脱水素酵素増加",
                           "γ-GTP増加","血中ビリルビン増加","コレステロール増加",
                           "CPK増加","クレアチニン増加","リパーゼ増加",
                           "血清アミラーゼ増加","膵酵素減少"]))
        subtitles.append(("下垂体ホルモン>",
                          ["血中抗利尿ホルモン検査異常","血中コルチコトロピン減少","血中ゴナドトロピン異常","甲状腺刺激ホルモン増加",
                           "血中プロラクチン異常","成長ホルモン異常"]))
        subtitles.append(("呼吸機能>",
                          ["一酸化炭素拡散能減少","努力呼気量減少","肺活量異常"]))
        twoDimArray[13] = ["アシドーシス","アルコール不耐性","アルカローシス",
                           "食欲不振","脱水","ブドウ糖不耐性",
                           "高カルシウム血症","高血糖","高カリウム血症","高脂血症",
                           "高マグネシウム血症","高ナトリウム血症","高リン酸塩血症","高トリグリセリド血症",
                           "高尿酸血症","低アルブミン血症","低カルシウム血症",
                           "低血糖症","低カリウム血症","低マグネシウム血症",
                           "低ナトリウム血症","低リン酸血症","鉄過剰",
                           "腫瘍崩壊症候群","その他"]
        twoDimArray[14] = ["筋力低下>","可動域低下>","骨•軟部組織壊死>",
                           "疼痛(筋骨格)>","関節炎","外骨腫",
                           "深部結合組織線維化","成長抑制","関節滲出液",
                           "脊柱後弯症","脊柱前弯症","筋痙攣","筋骨格変形",
                           "筋炎","骨粗鬆症","側弯症","横紋筋融解症","肩回旋筋腱板損傷",
                           "表在軟部組織線維化","開口障害","肢長不一致",
                           "その他"]
        subtitles.append(("筋力低下>",
                          ["全身筋力低下","下肢筋力低下",
                           "体幹筋力低下","上肢筋力低下"]))
        subtitles.append(("可動域低下>",
                          ["関節可動域低下","頚椎関節可動域低下","腰椎関節可動域低下"]))
        subtitles.append(("骨•軟部組織壊死>",
                          ["胸壁壊死","腹部軟部組織壊死","頭部軟部組織壊死","頚部軟部組織壊死","骨壊死",
                           "骨盤軟部組織壊死","下肢軟部組織壊死","上肢軟部組織壊死",
                           "顎骨壊死","無腐性壊死"]))
        subtitles.append(("疼痛(筋骨格)>",
                          ["関節痛","背部痛","骨痛",
                           "殿部痛","胸壁痛","側腹部痛",
                           "筋肉痛","頚部痛","四肢痛"]))
        twoDimArray[15] = ["癌化学療法に続発した白血病","骨髄異形成症候群","皮膚乳頭腫","治療関連続発性悪性疾患",
                           "腫瘍出血","腫瘍疼痛","その他"]
        twoDimArray[16] = ["脳神経障害>","意識障害>","脳血管障害>",
                           "炎症>","疼痛(神経系)>","運動障害•麻痺>",
                           "感覚障害>","脳症>","失声•失語•構語障害>",
                           "嗜眠•傾眠•過眠症>","健忘•記憶•認知•集中力障害>","脊髄>","アカシジア",
                           "腕神経叢障害","中枢神経系壊死",
                           "浮動性めまい","脳浮腫","錐体外路障害",
                           "水頭症","髄膜症","痙攣発作",
                           "痙直","振戦","血管迷走神経性反応",
                           "眼振","その他"]
        subtitles.append(("脳神経障害>",
                          ["嗅神経障害","視神経障害","動眼神経障害",
                           "滑車神経障害","三叉神経障害","外転神経障害",
                           "顔面神経障害","聴神経病変NOS","舌咽神経障害",
                           "迷走神経障害","副神経障害","舌下神経障害"]))
        subtitles.append(("意識障害>",
                          ["意識レベルの低下","失神寸前の状態","失神",
                           "傾眠"]))
        subtitles.append(("脳血管障害>",
                          ["頭蓋内出血","脳血管虚血","一過性脳虚血発作",
                           "脳卒中"]))
        subtitles.append(("炎症>",
                          ["くも膜炎","脊髄炎","神経根炎"]))
        subtitles.append(("疼痛(神経系)>",
                          ["頭痛","幻痛",
                           "神経痛"]))
        subtitles.append(("運動障害•麻痺>",
                          ["運動失調","顔面筋脱力","不随意運動","左側筋力低下","右側筋力低下","ギラン・バレー症候群","重症筋無力症","腱反射減退",
                           "末梢性運動ニューロパチー","錐体路症候群","反回神経麻痺"]))
        subtitles.append(("感覚障害>",
                          ["異常感覚","味覚異常","錯感覚","無嗅覚",
                           "末梢性感覚ニューロパチー","幻痛"]))
        subtitles.append(("脳症>",
                          ["脳症","白質脳症","可逆性後白質脳症症候群"]))
        subtitles.append(("失声•失語•構語障害>",
                          ["失声症","不全失語症","構語障害"]))
        subtitles.append(("嗜眠•傾眠•過眠症>",
                          ["嗜眠","傾眠","過眠症"]))
        subtitles.append(("健忘•記憶•認知•集中力障害>",
                          ["健忘","記憶障害","認知障害",
                           "集中力障害"]))
        subtitles.append(("脊髄>",
                          ["脳脊髄液漏","脊髄圧迫"]))
        twoDimArray[17] = ["胎児発育遅延","妊娠損失","早産",
                           "その他"]
        twoDimArray[18] = ["激越","無オルガズム症","不安",
                           "錯乱","オルガズム遅延","譫妄",
                           "妄想","うつ病","多幸症",
                           "幻覚","不眠症","易刺激性","リビドー減退",
                           "リビドー亢進","躁病","人格変化",
                           "精神病","落ち着きのなさ","自殺念慮",
                           "自殺企図","その他"]
        twoDimArray[19] = ["急性腎不全","膀胱穿孔","膀胱痙縮",
                           "慢性腎臓病","非感染性膀胱炎","排尿困難","糖尿","血尿",
                           "ヘモグロビン尿","ネフローゼ症候群","蛋白尿","腎結石",
                           "腎仙痛","腎出血","尿瘻",
                           "頻尿","尿失禁","尿閉",
                           "尿路閉塞","尿路痛","尿意切迫",
                           "尿変色","その他"]
        twoDimArray[20] = ["乳房>","子宮•腟>","卵巣•卵管>",
                           "月経>","精子•精巣>","前立腺>",
                           "性交困難","射精障害","勃起不全",
                           "後天性女性化","性器浮腫","女性化乳房",
                           "骨盤底筋力低下","骨盤痛","陰茎痛",
                           "会陰痛","陰嚢痛","その他"]
        subtitles.append(("乳房>",
                          ["乳房萎縮","乳房痛","乳汁分泌障害",
                           "乳頭変形"]))
        subtitles.append(("子宮•腟>",
                          ["子宮出血","子宮瘻","子宮閉塞",
                           "子宮痛","腟瘻","腟出血",
                           "腟の炎症","腟閉塞","腟痛",
                           "腟穿孔","腟狭窄",
                           "腟分泌物","腟乾燥"]))
        subtitles.append(("卵巣•卵管>",
                          ["卵管閉塞","卵管留血症",
                           "卵巣出血","卵巣破裂","排卵痛"]))
        subtitles.append(("月経>",
                          ["無月経","月経困難症","不規則月経","月経過多",
                           "排卵痛","早発閉経"]))
        subtitles.append(("精子•精巣>",
                          ["無精子症","精子減少症","精索出血",
                           "精索閉塞","精巣障害","精巣出血",
                           "精巣痛"]))
        subtitles.append(("前立腺>",
                          ["前立腺出血","前立腺閉塞","前立腺痛"]))
        twoDimArray[21] = ["鼻>","咽頭•喉頭>","気管支>",
                           "肺>","呼吸障害>","誤嚥",
                           "乳び胸","咳嗽","しゃっくり",
                           "嗄声","低酸素症","縦隔出血",
                           "胸水","胸腔内出血","胸膜痛",
                           "気胸","湿性咳嗽","レチノイン酸症候群",
                           "副鼻腔障害","くしゃみ","音声変調",
                           "その他"]
        subtitles.append(("鼻>",
                          ["アレルギー性鼻炎","鼻出血","鼻閉",
                           "後鼻漏","鼻漏","副鼻腔痛"]))
        subtitles.append(("咽頭•喉頭>",
                          ["喉頭浮腫","喉頭瘻","喉頭出血",
                           "喉頭の炎症","喉頭粘膜炎","喉頭閉塞",
                           "喉頭狭窄","咽喉頭知覚不全","喉頭痙攣","口腔咽頭痛",
                           "咽頭瘻","咽頭出血","咽頭粘膜炎",
                           "咽頭壊死","咽頭狭窄","咽喉頭疼痛",
                           "咽喉痛","睡眠時無呼吸","上気道性喘鳴"]))
        subtitles.append(("気管支>",
                          ["気管支瘻","気管支閉塞","気管支狭窄",
                           "気管支胸膜瘻","気管支肺出血","気管支痙攣",
                           "上気道性喘鳴","気管瘻","気管粘膜炎",
                           "気管狭窄","喘鳴"]))
        subtitles.append(("肺>",
                          ["成人呼吸窮迫症候群","無気肺","気管支肺出血",
                           "肺臓炎","肺水腫","肺線維症",
                           "肺瘻","肺高血圧症"]))
        subtitles.append(("呼吸障害>",
                          ["無呼吸","呼吸困難","喉頭閉塞",
                           "喉頭狭窄","喉頭浮腫","咽頭狭窄",
                           "呼吸不全","睡眠時無呼吸","気管狭窄",
                           "喘鳴","成人呼吸窮迫症候群","上気道性喘鳴"]))
        twoDimArray[22] = ["爪>","湿疹•蕁麻疹•皮疹>","脱毛•多毛•毛髪異常>",
                           "紅斑•紫斑•紅皮症>","多汗症•乏汗症>","体臭","皮膚乾燥",
                           "脂肪萎縮症","過角化",
                           "脂肪肥大症","皮膚疼痛","手足症候群",
                           "光線過敏症","そう痒症",
                           "頭皮痛","皮膚萎縮","皮膚色素過剰",
                           "皮膚色素減少","皮膚硬結","皮膚潰瘍形成",
                           "スティーヴンス•ジョンソン症候群","皮下気腫","毛細血管拡張症","中毒性表皮壊死融解症",
                           "水疱性皮膚炎","その他"]
        subtitles.append(("爪>",
                          ["爪変色","爪脱落","爪線状隆起","爪の変化"]))
        subtitles.append(("湿疹•蕁麻疹•皮疹>",
                          ["湿疹","蕁麻疹","ざ瘡様皮疹","斑状丘疹状皮疹"]))
        subtitles.append(("脱毛•多毛•毛髪異常>",
                          ["脱毛症","男性型多毛症","多毛症","毛髪変色","毛質異常"]))
        subtitles.append(("紅斑•紫斑•紅皮症>",
                          ["多形紅斑","紫斑","紅皮症"]))
        subtitles.append(("多汗症•乏汗症>",
                          ["多汗症","乏汗症"]))
        twoDimArray[23] = ["その他"]
        twoDimArray[24] = ["final"]
        twoDimArray[25] = ["動脈血栓塞栓症","毛細血管漏出症候群","潮紅","血腫",
                           "ほてり","高血圧","低血圧",
                           "リンパ漏","リンパ浮腫","リンパ嚢腫",
                           "末梢性虚血","静脈炎","表在性血栓性静脈炎",
                           "上大静脈症候群","血栓塞栓症","血管炎",
                           "その他"]
        for i in 0 ..< twoDimArray.count{
            for j in 0 ..< twoDimArray[i].count{
                if !twoDimArray[i][j].contains(">"){
                    var k = twoDimArray[i][j]
                    if k == "その他" {
                        k = "その他(\(diseaseArray[i]))"
                    }
                    if k == "final" {
                        k = diseaseArray[i]
                    }
                    unfilteredNFLTeams.append(k)
                }
                else {
                    if let index = subtitles.firstIndex(where: {$0.title == twoDimArray[i][j]}) {
                        for l in subtitles[index].subArray {
                            unfilteredNFLTeams.append(l)
                        }//for l in subtitles[index].subArray
                    }//if let index = subtitles.firstIndex
                }//else
            }//for j in 0 ..< twoDimArray[i].count
        }//for i in 0 ..< twoDimArray.count
        filteredNFLTeams = unfilteredNFLTeams
    }//override func viewDidLoad()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSubView" {
            let toSubView = segue.destination as! CTCAESubViewController
                toSubView.detailText = sendText
        }//if segue.identifier == "toSubView"
        if segue.identifier != "toSubView" {
            let sendText = segue.destination as! SaveViewController
            sendText.myText = appName.rawValue
        }//if segue.identifier == "ctcaeSave"
    }//override func prepare(for segue
    
    @IBAction func fromDetailToHome(_ Segue:UIStoryboardSegue){
        initialView()
    }
    
    func initialView(){
        isSelected = false
        isSubtitles = false
        diseaseRow = 0
        selectedSub = ""
        sendText = ""
        self.navigationItem.title = "一覧"
        maeButton.isHidden = true
        ichiranButton.isHidden = true
        myCollectionView.reloadData()
    }
    
    @IBAction func ichiranButtonPushed(){
        initialView()
    }
    
    @IBAction func maeButtonPushed(){
        isSelected = true
        isSubtitles = false
        self.navigationItem.title = diseaseArray[diseaseRow]
        maeButton.isHidden = true
        myCollectionView.reloadData()
    }
    
    @IBAction func fromDetailToPrior(_ Segue:UIStoryboardSegue){
        isSelected = true
        myCollectionView.reloadData()
    }
    
    @IBAction func selectorChanged(){
        switch mySelector.selectedSegmentIndex {
        case 0:
            myTableView.isHidden = true
            self.searchController.searchBar.isHidden = true
            myCollectionView.isHidden = false
            initialView()
        case 1:
            myTableView.isHidden = false
            self.searchController.searchBar.isHidden = false
            myCollectionView.isHidden = true
            myTableView.reloadData()
            self.navigationItem.title = "検索•入力"
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPathForSelectedRow = myTableView.indexPathForSelectedRow {
            myTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
}
