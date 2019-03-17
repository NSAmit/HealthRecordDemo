//
//  FeatureDetailsViewModel.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/13/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import Foundation
import HealthKit

class FeatureDetailsViewModel {
    
    func getFormatedDictionaryFromHealthRecord(inHKHealthData: [HKClinicalRecord]?) -> [HealthRecordObject?]? {
        var returnDict = [HealthRecordObject?]()
        
        guard let inParam = inHKHealthData else {
            return nil
        }
        for each in inParam {
            if let data = each.fhirResource?.data {
                
                let decoder = JSONDecoder()
                
                switch each.clinicalType.identifier {
                case HKClinicalTypeIdentifier.allergyRecord.rawValue:
                    guard let record = try? decoder.decode(Allergy.self, from: data) else {continue}
                    let healthRecordParent = HealthRecordObject(inFormattedData: record, inClinicalRecord: each)
                    returnDict.append(healthRecordParent)
                case HKClinicalTypeIdentifier.conditionRecord.rawValue:
                    guard let record = try? decoder.decode(Condition.self, from: data) else {continue}
                    let healthRecordParent = HealthRecordObject(inFormattedData: record, inClinicalRecord: each)
                    returnDict.append(healthRecordParent)
                case HKClinicalTypeIdentifier.immunizationRecord.rawValue:
                    guard let record = try? decoder.decode(Immunization.self, from: data) else {continue}
                    let healthRecordParent = HealthRecordObject(inFormattedData: record, inClinicalRecord: each)
                    returnDict.append(healthRecordParent)
                case HKClinicalTypeIdentifier.labResultRecord.rawValue:
                    guard let record = try? decoder.decode(LabResult.self, from: data) else {continue}
                    let healthRecordParent = HealthRecordObject(inFormattedData: record, inClinicalRecord: each)
                    returnDict.append(healthRecordParent)
                case HKClinicalTypeIdentifier.medicationRecord.rawValue:
                    guard let record = try? decoder.decode(Medication.self, from: data) else {continue}
                    let healthRecordParent = HealthRecordObject(inFormattedData: record, inClinicalRecord: each)
                    returnDict.append(healthRecordParent)
                case HKClinicalTypeIdentifier.procedureRecord.rawValue:
                    guard let record = try? decoder.decode(Procedure.self, from: data) else {continue}
                    let healthRecordParent = HealthRecordObject(inFormattedData: record, inClinicalRecord: each)
                    returnDict.append(healthRecordParent)
                case HKClinicalTypeIdentifier.vitalSignRecord.rawValue:
                    guard let record = try? decoder.decode(VitalSign.self, from: data) else {continue}
                    let healthRecordParent = HealthRecordObject(inFormattedData: record, inClinicalRecord: each)
                    returnDict.append(healthRecordParent)
                default:
                    break
                }
            }
        }
        return returnDict
    }
}
