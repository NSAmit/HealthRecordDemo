//
//  HealthRecordModels.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/14/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import Foundation
import HealthKit


struct Person:Codable {
    let display: String?
    let reference: String
}

struct CodeableConcept:Codable {
    let text:String
    let coding:[[String:String]]
}

// MARK: Medication
struct DosageInstruction: Codable {
    let text:String?
    let timing:[String:[String:String?]?]?
}

struct Medication:Codable {
    let dateWritten:String
    let status: String
    let note: String
    let id: String
    let medicationCodeableConcept: CodeableConcept
    let patient:Person
    let prescriber:Person
    let resourceType:String
    let dosageInstruction:[DosageInstruction]
}

// MARK: Allergy
struct Reaction:Codable {
    let onset:String?
    let manifestation:[[String: String]]
    let severity:String
}

struct Allergy: Codable {
    let id: String
    let resourceType:String
    let onset: String?
    let patient: Person
    let reaction: [Reaction]
    let recordedDate: String
    let substance: CodeableConcept
}

// MARK: Condition

struct Condition:Codable {
    let id: String
    let resourceType:String
    let asserter:Person
    let category:[String: [[String: String]]]
    let clinicalStatus: String
    let code: CodeableConcept
    let dateRecorded: String
    let verificationStatus: String
    let notes: String
    let onsetDateTime: String
}

// MARK: Immunization

struct Immunization:Codable {
    let id: String
    let resourceType:String
    let vaccineCode:CodeableConcept
    let encounter:[String: String]
    let requester:[String: String]
    let date: String
}

// MARK: LabResult

struct ReferenceRange:Codable {
    let low:ValueQuantity
    let high:ValueQuantity
    let text:String
}

struct ValueQuantity:Codable {
    let code:String
    let system:String
    let value:Double
    let unit:String
}

struct LabResult:Codable {
    let id: String
    let resourceType:String
    let category:CodeableConcept
    let issued:String
    let status:String
    let code:CodeableConcept
    let referenceRange:[ReferenceRange]
    let valueQuantity:ValueQuantity
}

// MARK: Procedure

struct Procedure:Codable {
    let id: String
    let resourceType:String
    let code:CodeableConcept
    let status:String
    let encounter:[String: String]
    let performedDateTime:String
    let performer:Person
}

// MARK: VitalSign

struct VitalSign:Codable {
    let id: String
    let resourceType:String
    let category:CodeableConcept
    let code:CodeableConcept
    let status:String
    let encounter:[String: String]
    let issued: String
    let valueQuantity:ValueQuantity
    let component:[[String: String?]?]?
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
