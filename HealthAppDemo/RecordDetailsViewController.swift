//
//  RecordDetailsViewController.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 2/21/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import UIKit

class RecordDetailsViewController: UIViewController {

    @IBOutlet weak var detailDictionaryLabel: UILabel!
    var descriptionToDisplay:String?
    var titleText:String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailDictionaryLabel.text = descriptionToDisplay
        self.navigationItem.title = titleText ?? "Record Details"
    }
}
