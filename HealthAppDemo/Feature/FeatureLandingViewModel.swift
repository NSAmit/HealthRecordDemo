//
//  FeatureLandingViewModel.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/9/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import Foundation
import HealthKit

class FeatureLandingViewModel: HealthStoreManagerInjectable {
    var currentFeature:SupportedFeatures?
    var recordTypesModel:[HealthRecordModel]? {
        get {
            guard let featureType = currentFeature?.id else { return nil }
            switch featureType {
            case .healthRecords:
                var returnRecordTypes = [HealthRecordModel]()
                let allergyStatus = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .allergyRecord)
                if let status = allergyStatus.1, status != .notDetermined {
                    returnRecordTypes.append(HealthRecordModel(inType: .allergyRecord, inStatus: status, inDisplayString: "Allergy"))
                }
                let conditionStatus = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .conditionRecord)
                if let status = conditionStatus.1, status != .notDetermined {
                    returnRecordTypes.append(HealthRecordModel(inType: .conditionRecord, inStatus: status, inDisplayString: "Conditions"))
                }
                let immunizationStatus = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .immunizationRecord)
                if let status = immunizationStatus.1, status != .notDetermined {
                    returnRecordTypes.append(HealthRecordModel(inType: .immunizationRecord, inStatus: status, inDisplayString: "Immunizations"))
                }
                let labresultStatus = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .labResultRecord)
                if let status = labresultStatus.1, status != .notDetermined {
                    returnRecordTypes.append(HealthRecordModel(inType: .labResultRecord, inStatus: status, inDisplayString: "Lab Results"))
                }
                let medicationStatus = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .medicationRecord)
                if let status = medicationStatus.1, status != .notDetermined {
                    returnRecordTypes.append(HealthRecordModel(inType: .medicationRecord, inStatus: status, inDisplayString: "Medications"))
                }
                let procedureStatus = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .procedureRecord)
                if let status = procedureStatus.1, status != .notDetermined {
                    returnRecordTypes.append(HealthRecordModel(inType: .procedureRecord, inStatus: status, inDisplayString: "Procedures"))
                }
                let vitalSignStatus = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .vitalSignRecord)
                if let status = vitalSignStatus.1, status != .notDetermined {
                    returnRecordTypes.append(HealthRecordModel(inType: .vitalSignRecord, inStatus: status, inDisplayString: "Clinical Vitals"))
                }
                return returnRecordTypes
            default:
                return nil
            }
        }
    }
}
