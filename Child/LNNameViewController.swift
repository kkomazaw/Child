//
//  LNNameViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/06.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit

class LNNameViewController: UIViewController {
    
    @IBOutlet var pdfView:PDFView!
    @IBOutlet var myToolBar:UIToolbar!
    
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
        if let documentURL = Bundle.main.url(forResource: "LNname", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }
        }//if let documentURL = Bundle.main.url
    }//override func viewDidLoad()
    
    @IBAction func toUpperLarge(){
        performSegue(withIdentifier: "toUpperLargeLN", sender: true)
    }
    
    @IBAction func toLowerLarge(){
        performSegue(withIdentifier: "toLowerLargeLN", sender: true)
    }
    
}
