//
//  HealthStoreManager.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/9/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import Foundation
import HealthKit

protocol HealthStoreManagerInjectable { }

extension HealthStoreManagerInjectable {
    var healthStoreManager:HealthStoreManagerProtocol { get {return HealthAppDemoDependencies.healthStoreManager}}
}

protocol HealthStoreManagerProtocol {
    func requestForAllClinicalRecordsAuthorization(completion:((Error?) -> Void)?)
    func getRecordForType(type: HKClinicalTypeIdentifier, recordReadCompletionHandler:@escaping ([HKClinicalRecord]?) -> Void)
    func isAuthorizedForClinicalRecords(forType:HKClinicalTypeIdentifier) -> (HKAuthorizationRequestStatus?, HKAuthorizationStatus?)
    func getRequestStatusForAllClinicalRecords(completion: @escaping (HKAuthorizationRequestStatus, Error?) -> Void)
}

class HealthStoreManager:HealthStoreManagerProtocol {
    
    let healthStore = HKHealthStore()
    
    func requestForAllClinicalRecordsAuthorization(completion:((Error?) -> Void)?) {
        guard let allergiesType = HKObjectType.clinicalType(forIdentifier: .allergyRecord),
            let medicationsType = HKObjectType.clinicalType(forIdentifier: .medicationRecord),
            let conditionType = HKObjectType.clinicalType(forIdentifier: .conditionRecord),
            let immunizationType = HKObjectType.clinicalType(forIdentifier: .immunizationRecord),
            let labResultType = HKObjectType.clinicalType(forIdentifier: .labResultRecord),
            let procedureType = HKObjectType.clinicalType(forIdentifier: .procedureRecord),
            let vitalSignType = HKObjectType.clinicalType(forIdentifier: .vitalSignRecord) else {
                fatalError("*** Unable to create the requested types ***")
        }
        
        // Clinical types are read-only.
        healthStore.requestAuthorization(toShare: nil, read: [allergiesType, medicationsType, conditionType, immunizationType, labResultType, procedureType, vitalSignType]) { (success, error) in
            
            guard success else {
                // Handle errors here.
                completion?(HealthStoreManagerError(indescription: "Can not access Clinical Records"))
                return
            }
            
            completion?(nil)
        }
    }
    
    func getRecordForType(type: HKClinicalTypeIdentifier, recordReadCompletionHandler:@escaping ([HKClinicalRecord]?) -> Void) {
        
        guard let healthRecordType = HKObjectType.clinicalType(forIdentifier: type) else {
            fatalError("*** Unable to create the allergy type ***")
        }
        
        let healthRecordQuery = HKSampleQuery(sampleType: healthRecordType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            
            guard let actualSamples = samples else {
                // Handle the error here.
                print("*** An error occurred: \(error?.localizedDescription ?? "nil") ***")
                recordReadCompletionHandler(nil)
                return
            }
            
            let healthRecordSamples = actualSamples as? [HKClinicalRecord]
            recordReadCompletionHandler(healthRecordSamples)
        }
        healthStore.execute(healthRecordQuery)
    }
    
    func isAuthorizedForClinicalRecords(forType:HKClinicalTypeIdentifier) -> (HKAuthorizationRequestStatus?, HKAuthorizationStatus?) {
        guard let inType = HKObjectType.clinicalType(forIdentifier: forType) else {
                return (HKAuthorizationRequestStatus.unknown, HKAuthorizationStatus.notDetermined)
        }
        return (nil, healthStore.authorizationStatus(for: inType))
    }
    
    func getRequestStatusForAllClinicalRecords(completion: @escaping (HKAuthorizationRequestStatus, Error?) -> Void) {
        guard let allergiesType = HKObjectType.clinicalType(forIdentifier: .allergyRecord),
            let medicationsType = HKObjectType.clinicalType(forIdentifier: .medicationRecord),
            let conditionType = HKObjectType.clinicalType(forIdentifier: .conditionRecord),
            let immunizationType = HKObjectType.clinicalType(forIdentifier: .immunizationRecord),
            let labResultType = HKObjectType.clinicalType(forIdentifier: .labResultRecord),
            let procedureType = HKObjectType.clinicalType(forIdentifier: .procedureRecord),
            let vitalSignType = HKObjectType.clinicalType(forIdentifier: .vitalSignRecord) else {
                completion(.unknown, HealthStoreManagerError(indescription: "Currently not having access to Clinical Records."))
                return
        }
        
        // Clinical types are read-only.
        healthStore.getRequestStatusForAuthorization(toShare: [], read: [allergiesType, medicationsType, conditionType, immunizationType, labResultType, procedureType, vitalSignType]) { (inStatus, inError) in
            completion(inStatus, inError)
        }
    }
}

class HealthStoreManagerError:Error {
    let description:String
    
    init(indescription: String) {
        description = indescription
    }
}
