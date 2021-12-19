//
//  HomeTableViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/02/17.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    typealias TitleID = (title: String,id: String)
    var titleArray = [TitleID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleArray = [("肝硬変重症度Child分類","child"),
                      ("肝癌進行度分類","kangan"),
                      ("食道癌進行度分類","shokudou"),
                      ("胃癌進行度分類","igan"),
                      ("大腸癌進行度分類","daichougan"),
                      ("胆道癌進行度分類","tandougan"),
                      ("膵癌進行度分類","suigan"),
                      ("乳癌進行度分類","nyugan"),
                      ("肺癌進行度分類","haigan"),
                      ("リンパ節の名称","lymph"),
                      ("MELDスコア","meld"),
                      ("肝障害度 Liver Damage","liverdamage"),
                      ("AIH scoring 1999","aih1999"),
                      ("simplified AIH scoring","simpleAIH"),
                      ("急性膵炎重症度 2008","suien"),
                      ("PBC予後予測","pbc"),
                      ("JIS score","jis"),
                      ("CLIP score","clip"),
                      ("Milan criteria","milan"),
                      ("CTCAE v5.0 日本語版","ctcae"),
                      ("JAS (Alcoholic Hepatitis)","jas"),
                      ("薬物性肝障害診断基準","yakubutsu"),
                      ("FIB-4 index","fib"),
                      ("NAFIC score","nafic"),
                      ("BCLC staging system","bclc"),
                      ("肝癌治療アルゴリズム","hccalgo"),
                      ("ALBI","albi")]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titleArray[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: titleArray[indexPath.row].id, sender: true)
    }
    
}
