//
//  LNUpperLargeViewController.swift
//  Child
//
//  Created by Matsui Keiji on 2019/03/06.
//  Copyright © 2019 Matsui Keiji. All rights reserved.
//

import UIKit
import PDFKit

class LNUpperLargeViewController: UIViewController {

    @IBOutlet var pdfView:PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let documentURL = Bundle.main.url(forResource: "LNUpperFigure", withExtension: "pdf") {
            if let document = PDFDocument(url: documentURL) {
                pdfView.document = document
                pdfView.displayMode = .singlePage
                pdfView.autoScales = true
            }
        }//if let documentURL = Bundle.main.url
    }//override func viewDidLoad()
}
