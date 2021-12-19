//
//  EsoLowerLargeViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/02/28.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit

class EsoLowerLargeViewController: UIViewController {
    
    var vSenkyobui:Int!
    
    let LNResourceArray = ["CELL","UTLL","MTLL","LTLL","AELL"]
    
    let senkyobuiArray = ["Ce:頸部食道","Ut:胸部上部食道","Mt:胸部中部食道","Lt:胸部下部食道","Ae:腹部食道"]
    
    @IBOutlet var pdfView:PDFView!
    @IBOutlet var LNView:PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = senkyobuiArray[vSenkyobui]
        if let documentURL = Bundle.main.url(forResource: "LNLowerLarge", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                LNView.document = document
                LNView.displayMode = .singlePage
                LNView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
        if let documentURL = Bundle.main.url(forResource: LNResourceArray[vSenkyobui], withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }//if let document = PDFDocument
        }//if let documentURL = Bundle.main.url
    }//override func viewDidLoad()
}//class EsoLowerLargeViewController: UIViewController
