//
//  HealthRecordModels.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/14/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import Foundation
import HealthKit

// MARK: Medication

struct Patient:Codable {
    var display: String?
    var reference: String?
}

struct Prescriber:Codable {
    var display: String?
    var reference: String?
}

struct MedicationCodeableConcept:Codable {
    var text:String?
    var coding:[[String:String?]?]?
}

struct DosageInstruction: Codable {
    var text:String?
    var timing:[String:[String:String?]?]?
}

struct Medication:Codable {
    var dateWritten:String?
    var status: String?
    var note: String?
    var id: String?
    var medicationCodeableConcept: MedicationCodeableConcept?
    var patient:Patient?
    var prescriber:Prescriber?
    var resourceType:String?
    var dosageInstruction:[DosageInstruction?]?
}

// MARK: Allergy

struct Reaction:Codable {
    var onset:String?
    var manifestation:[[String: String?]?]?
    var severity:String?
}

struct Allergy: Codable {
    var id: String?
    var onset: String?
    var patient: Patient?
    var reaction: [Reaction?]?
    var recordedDate: String?
    var resourceType:String?
    var substance: MedicationCodeableConcept?
}

// MARK: Condition

struct Asserter:Codable {
    var display: String?
    var reference: String?
}

struct Condition:Codable {
    var id: String?
    var resourceType:String?
    var asserter:Asserter?
    var category:[String: [[String: String?]]?]?
    var clinicalStatus: String?
    var code: MedicationCodeableConcept?
    var dateRecorded: String?
    var verificationStatus: String?
    var notes: String?
    var onsetDateTime: String?
}

// MARK: Immunization

struct Immunization:Codable {
    var id: String?
    var resourceType:String?
    var vaccineCode:MedicationCodeableConcept?
    var encounter:[String: String?]?
    var requester:[String: String?]?
    var date: String?
}

// MARK: LabResult

struct ReferenceRange:Codable {
    var low:ValueQuantity?
    var high:ValueQuantity?
    var text:String?
}

struct ValueQuantity:Codable {
    var code:String?
    var system:String?
    var value:Double?
    var unit:String?
}

struct LabResult:Codable {
    var id: String?
    var resourceType:String?
    var category:MedicationCodeableConcept?
    var issued:String?
    var status:String?
    var code:MedicationCodeableConcept?
    var referenceRange:[ReferenceRange?]?
    var valueQuantity:ValueQuantity?
}

// MARK: Procedure

struct Procedure:Codable {
    var id: String?
    var resourceType:String?
    var code:MedicationCodeableConcept?
    var status:String?
    var encounter:[String: String?]?
    var performedDateTime:String?
//    var performer:[[String: Any?]?]?
}

// MARK: VitalSign

struct VitalSign:Codable {
    var id: String?
    var resourceType:String?
    var category:MedicationCodeableConcept?
    var code:MedicationCodeableConcept?
    var status:String?
    var encounter:[String: String?]?
    var issued: String?
    var valueQuantity:ValueQuantity?
    var component:[[String: String?]?]?
}

// MARK: Health Record

class HealthRecordObject {
    let clinicalRecord:HKClinicalRecord
    let formattedData:Any
    let numberOfLabels:Int
    private let currentMirror:Mirror
    
    init(inFormattedData:Any, inClinicalRecord:HKClinicalRecord) {
        self.formattedData = inFormattedData
        self.clinicalRecord = inClinicalRecord
        self.currentMirror = Mirror(reflecting: inFormattedData)
        self.numberOfLabels = self.currentMirror.children.count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLabelValueAtIndex(inIndex: Int) -> (label:String?, value:Any) {
        for (index,child) in self.currentMirror.children.enumerated() {
            if index == inIndex {
                return (child.label, child.value)
            }
        }
        return (nil, "")
    }
}
