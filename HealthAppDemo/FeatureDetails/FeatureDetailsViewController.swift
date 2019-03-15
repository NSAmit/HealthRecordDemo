//
//  FeatureDetailsViewController.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/12/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import UIKit
import HealthKit

class FeatureDetailsViewController: UIViewController {

    let viewModel = FeatureDetailsViewModel()
    @IBOutlet weak var tableView: UITableView!
    var recordDetails:[HKClinicalRecord]?
    var healthRecordDetailObjects:[HealthRecordObject?]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        healthRecordDetailObjects = viewModel.getFormatedDictionaryFromHealthRecord(inHKHealthData: recordDetails)
    }
}

extension FeatureDetailsViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return healthRecordDetailObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let displayTitle = healthRecordDetailObjects?[section]?.clinicalRecord.displayName {
            return getRequiredHeight(inDisplayText: displayTitle)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let displayTitle = healthRecordDetailObjects?[section]?.clinicalRecord.displayName {
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.width - 20, height: 300))
            label.numberOfLines = 0
            label.textColor = UIColor.darkText
            label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
            label.text = displayTitle
            label.sizeToFit()
            return label
        }
        return UIView(frame: CGRect.zero)
    }
    
    func getRequiredHeight(inDisplayText: String) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.width - 20, height: 300))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.darkText
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = inDisplayText
        label.sizeToFit()
        return label.frame.height + 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 //recordDetails?[section].fhirResource?.data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
