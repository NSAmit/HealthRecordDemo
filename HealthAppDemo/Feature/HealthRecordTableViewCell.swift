//
//  HealthRecordTableViewCell.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/10/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import UIKit
import HealthKit

class HealthRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var cellModel:HealthRecordModel? {
        didSet {
            guard let model = cellModel, let type = cellModel?.type, let displayText = cellModel?.displayString else {
                self.iconImageView?.image = UIImage(named: "notavailable")
                self.titleLabel?.text = "Unknown"
                return
            }
            self.titleLabel?.text = displayText
            switch model.authorizationStatus {
            case .notDetermined:
                self.statusLabel?.text = ""
            case .sharingAuthorized:
                self.statusLabel?.text = ""
            case .sharingDenied:
                self.statusLabel?.text = "Denied"
            }
            switch type {
            case HKClinicalTypeIdentifier.allergyRecord:
                self.iconImageView?.image = UIImage(named: "allergy")
                break
            case HKClinicalTypeIdentifier.conditionRecord:
                self.iconImageView?.image = UIImage(named: "conditions")
                break
            case HKClinicalTypeIdentifier.immunizationRecord:
                self.iconImageView?.image = UIImage(named: "immunizations")
                break
            case HKClinicalTypeIdentifier.labResultRecord:
                self.iconImageView?.image = UIImage(named: "labresults")
                break
            case HKClinicalTypeIdentifier.medicationRecord:
                self.iconImageView?.image = UIImage(named: "medications")
                break
            case HKClinicalTypeIdentifier.procedureRecord:
                self.iconImageView?.image = UIImage(named: "procedures")
                break
            case HKClinicalTypeIdentifier.vitalSignRecord:
                self.iconImageView?.image = UIImage(named: "vitals")
                break
            default:
                break
            }
        }
    }
}
