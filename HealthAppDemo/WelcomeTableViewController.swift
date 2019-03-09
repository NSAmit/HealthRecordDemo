//
//  WelcomeTableViewController.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 12/2/18.
//  Copyright © 2018 Amit C Rote. All rights reserved.
//

import UIKit
import HealthKit

class WelcomeTableViewController: UITableViewController {

    let healthStore = HKHealthStore()
    var allergyRecord:[String:Any]?
    var medicationRecord:[String:Any]?
    var conditionRecord:[String:Any]?
    var immunizationRecord:[String:Any]?
    var labResultRecord:[String:Any]?
    var procedureTypeRecord:[String:Any]?
    var vitalSignTypeRecord:[String:Any]?
    var tableViewModel:[String:Any] = [String:Any]()
    var currentSelectedRecordValue:String?
    var currentSelectedRecordKey:String?
    
    let allergyRecordKey = "Allergy Record"
    let medicationRecordKey = "Medication Record"
    let conditionRecordKey = "Condition Record"
    let immunizationRecordKey = "Immunization Record"
    let labResultRecordKey = "Lab Result Record"
    let procedureTypeRecordKey = "Procedure Record"
    let vitalSignTypeRecordKey = "Clinical Vitals Record"
    
//    let tableViewKeyModel = [allergyRecordKey, medicationRecordKey, conditionRecordKey, immunizationRecordKey, labResultRecordKey, procedureTypeRecordKey, vitalSignTypeRecordKey]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onAccessButton(_ sender: UIButton) {
        guard let allergiesType = HKObjectType.clinicalType(forIdentifier: .allergyRecord),
            let medicationsType = HKObjectType.clinicalType(forIdentifier: .medicationRecord),
            let conditionType = HKObjectType.clinicalType(forIdentifier: .conditionRecord),
            let immunizationType = HKObjectType.clinicalType(forIdentifier: .immunizationRecord),
            let labResultType = HKObjectType.clinicalType(forIdentifier: .labResultRecord),
            let procedureType = HKObjectType.clinicalType(forIdentifier: .procedureRecord),
            let vitalSignType = HKObjectType.clinicalType(forIdentifier: .vitalSignRecord),
            let sleepData = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)  else {
                fatalError("*** Unable to create the requested types ***")
        }
        
        // Clinical types are read-only.
        healthStore.requestAuthorization(toShare: nil, read: [allergiesType, medicationsType, conditionType, immunizationType, labResultType, procedureType, vitalSignType, sleepData]) { (success, error) in
            
            guard success else {
                // Handle errors here.
                fatalError("*** An error occurred while requesting authorization: \(error!.localizedDescription) ***")
            }
            
            // You can start accessing clinical record data.
            self.getHealthRecords()
        }
    }
    
    func getHealthRecords() {
        // Get all records
        getRecordForType(type: .allergyRecord) { (isSuccess) in
            isSuccess ? self.tableViewModel[self.allergyRecordKey] = self.allergyRecord : print("Error in Reading Records")
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        getRecordForType(type: .conditionRecord) { (isSuccess) in
            isSuccess ? self.tableViewModel[self.conditionRecordKey] = self.conditionRecord : print("Error in Reading Records")
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }        }
        getRecordForType(type: .immunizationRecord){ (isSuccess) in
            isSuccess ? self.tableViewModel[self.immunizationRecordKey] = self.immunizationRecord : print("Error in Reading Records")
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }        }
        getRecordForType(type: .labResultRecord){ (isSuccess) in
            isSuccess ? self.tableViewModel[self.labResultRecordKey] = self.labResultRecord : print("Error in Reading Records")
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }        }
        getRecordForType(type: .medicationRecord){ (isSuccess) in
            isSuccess ? self.tableViewModel[self.medicationRecordKey] = self.medicationRecord : print("Error in Reading Records")
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }        }
        getRecordForType(type: .procedureRecord){ (isSuccess) in
            isSuccess ? self.tableViewModel[self.procedureTypeRecordKey] = self.procedureTypeRecord : print("Error in Reading Records")
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }        }
        getRecordForType(type: .vitalSignRecord){ (isSuccess) in
            isSuccess ? self.tableViewModel[self.vitalSignTypeRecordKey] = self.vitalSignTypeRecord  : print("Error in Reading Records")
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }        }
    }
    
    func getRecordForType(type: HKClinicalTypeIdentifier, recordReadCompletionHandler:@escaping (Bool) -> Void) {
        
        guard let healthRecordType = HKObjectType.clinicalType(forIdentifier: type) else {
            fatalError("*** Unable to create the allergy type ***")
        }
        
        let healthRecordQuery = HKSampleQuery(sampleType: healthRecordType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) {[weak self] (query, samples, error) in
            
            guard let actualSamples = samples else {
                // Handle the error here.
                print("*** An error occurred: \(error?.localizedDescription ?? "nil") ***")
                recordReadCompletionHandler(false)
                return
            }
            
            let healthRecordSamples = actualSamples as? [HKClinicalRecord]
            let recordData = self?.convertJsonStringToDictionary(inData: healthRecordSamples?.first?.fhirResource?.data)
            
            switch type.rawValue {
            case HKClinicalTypeIdentifier.allergyRecord.rawValue:
                self?.allergyRecord = recordData
            case HKClinicalTypeIdentifier.conditionRecord.rawValue:
                self?.conditionRecord = recordData
            case HKClinicalTypeIdentifier.immunizationRecord.rawValue:
                self?.immunizationRecord = recordData
            case HKClinicalTypeIdentifier.labResultRecord.rawValue:
                self?.labResultRecord = recordData
            case HKClinicalTypeIdentifier.medicationRecord.rawValue:
                self?.medicationRecord = recordData
            case HKClinicalTypeIdentifier.procedureRecord.rawValue:
                self?.procedureTypeRecord = recordData
            default:
                print(recordData.debugDescription)
            }
            recordReadCompletionHandler(true)
        }
        healthStore.execute(healthRecordQuery)
    }
    
    func convertJsonStringToDictionary(inData: Data?) -> [String: Any]? {
        if let data = inData {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.tableViewModel.keys.count > 0) ? self.tableViewModel.keys.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = Array(self.tableViewModel.keys)[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentSelectedRecordKey = Array(self.tableViewModel.keys)[indexPath.row]
        self.currentSelectedRecordValue = self.tableViewModel[self.currentSelectedRecordKey ?? "Sample"].debugDescription
        self.performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetails":
            if  let destinationVC = segue.destination as? RecordDetailsViewController {
                destinationVC.descriptionToDisplay = currentSelectedRecordValue
                destinationVC.titleText = self.currentSelectedRecordKey
            }
        default:
            break
        }
    }
}
