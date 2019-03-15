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
    
    func getFormatedDictionaryFromHealthRecord(inHKHealthData: [HKClinicalRecord]?) -> [Any?]? {
        var returnDict = [Any?]()
        
        guard let inParam = inHKHealthData else {
            return nil
        }
        for each in inParam {
            print("Each HKClinicalRecord:HKSample -> Sample Type is --\(each.sampleType)\n")
            print("Each HKClinicalRecord:HKSample -> Start Date is --\(each.startDate)\n")
            print("Each HKClinicalRecord:HKSample -> Ende Date is --\(each.endDate)\n")
            print("Each HKClinicalRecord -> Display Name is --\(each.displayName)\n")
            print("Each HKClinicalRecord -> Clinical Type is --\(each.clinicalType.debugDescription)\n")
            print("Each HKClinicalRecord is --\(each.debugDescription)\n\n")
            print("Each HKClinicalRecord meta data is --\(each.metadata ?? [:])\n\n")
            if let fhir = each.fhirResource {
                print("Each fhirResource is --\(fhir.debugDescription)")
                print("Each fhir->Resource Type is -- \(fhir.resourceType.rawValue)")
                print("Each fhir->Identifier is -- \(fhir.identifier)")
                print("Each fhir->Source URL is -- \(fhir.sourceURL?.absoluteString ?? "")\n\n")
            }
            
            if let data = each.fhirResource?.data {
                
                let decoder = JSONDecoder()
                
                switch each.clinicalType.identifier {
                case HKClinicalTypeIdentifier.allergyRecord.rawValue:
                    let record = try? decoder.decode(Allergy.self, from: data)
                    returnDict.append(record)
                case HKClinicalTypeIdentifier.conditionRecord.rawValue:
                    let record = try? decoder.decode(Condition.self, from: data)
                    returnDict.append(record)
                case HKClinicalTypeIdentifier.immunizationRecord.rawValue:
                    let record = try? decoder.decode(Immunization.self, from: data)
                    returnDict.append(record)
                case HKClinicalTypeIdentifier.labResultRecord.rawValue:
                    let record = try? decoder.decode(LabResult.self, from: data)
                    returnDict.append(record)
                case HKClinicalTypeIdentifier.medicationRecord.rawValue:
                    let record = try? decoder.decode(Medication.self, from: data)
                    returnDict.append(record)
                case HKClinicalTypeIdentifier.procedureRecord.rawValue:
                    let record = try? decoder.decode(Procedure.self, from: data)
                    returnDict.append(record)
                case HKClinicalTypeIdentifier.vitalSignRecord.rawValue:
                    let record = try? decoder.decode(VitalSign.self, from: data)
                    returnDict.append(record)
                default:
                    break
                }
                if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Each fhirResource's data is --\n\(jsonData)")
                }
            }
        }
        return returnDict
    }
    
}
