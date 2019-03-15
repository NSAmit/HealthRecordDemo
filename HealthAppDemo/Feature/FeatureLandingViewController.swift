//
//  FeatureLandingViewController.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/9/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import UIKit
import HealthKit

class FeatureLandingViewController: UIViewController {

    @IBOutlet weak var topParentView: UIView!
    @IBOutlet weak var topParentStackView: UIStackView!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var actionStatusButton: UIButton!
    var currentFeatures:SupportedFeatures?
    let viewModel = FeatureLandingViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func actionStatusButtonClick(_ sender: UIButton) {
        healthStoreManager.requestForAllClinicalRecordsAuthorization { (inError) in
            if let error = inError {
                DispatchQueue.main.async {
                    self.statusLabel?.text = error.localizedDescription
                    self.actionStatusButton?.setTitle("Retry", for: .normal)
                    self.actionStatusButton?.isEnabled = true
                    self.actionStatusButton?.isHidden = false
                }
            } else {
                // Access has been authorized
                // Let's update the label and button
                DispatchQueue.main.async {
                    self.setupInitialState()
                }
            }
        }
    }
    
    func setup(){
        guard let feature = currentFeatures  else { return }
        self.title = feature.title
        tableView?.tableFooterView = UIView()
        viewModel.currentFeature = feature
        setupInitialState()
    }
}

extension FeatureLandingViewController:HealthStoreManagerInjectable {
    func setupInitialState(){
        tableView?.reloadData()
        guard let feature = self.viewModel.currentFeature else { return }
        
        switch feature.id {
        case .healthRecords:
            healthStoreManager.getRequestStatusForAllClinicalRecords {[weak self] (inStatus, inError) in
                guard let strongself = self else { return }
                DispatchQueue.main.async {
                    strongself.setButtonStatusBasedOn(authStatus: inStatus, inError: inError)
                }
            }
        default:
            self.statusLabel?.text = "Coming Soon"
            self.actionStatusButton.isEnabled = false
        }
    }
    
    func setButtonStatusBasedOn(authStatus: HKAuthorizationRequestStatus?, inError:Error? = nil){
        guard let inStatus = authStatus else {
            self.statusLabel?.text = inError?.localizedDescription ?? "Unknown Error!"
            self.actionStatusButton?.isEnabled = false
            self.actionStatusButton?.isHidden = true
            return
        }
        switch inStatus {
        case .shouldRequest :
            self.statusLabel?.text = "Please authorize access to read recent Health Records. \nThank You!"
            self.actionStatusButton?.setTitle("Authorize", for: .normal)
            self.actionStatusButton?.isEnabled = true
            self.actionStatusButton?.isHidden = false
        case .unnecessary:
            self.statusLabel?.text = "Thanks for giving access to read the Health Records. \nAppreciate it. \n\nNow, select the record type for details."
            self.actionStatusButton?.setTitle("Refresh", for: .normal)
            self.actionStatusButton?.isEnabled = false
            self.actionStatusButton?.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.animateAndHideTopView()
            })
            
        case .unknown:
            self.statusLabel?.text = "Some error in determining the Health Record feature for now. \nApologies."
            self.actionStatusButton?.isEnabled = false
            self.actionStatusButton?.isHidden = true
        }
    }
    
    func animateAndHideTopView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.topParentView.alpha = 0.0
        }, completion: { isComplete in
            self.tableViewTopConstraint.constant = -(self.topParentView.frame.height - 5.0)
        })
    }
}

extension FeatureLandingViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recordTypesModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "healthRecordCell") as? HealthRecordTableViewCell, let model = viewModel.recordTypesModel?[indexPath.row] {
            cell.cellModel = model
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? HealthRecordTableViewCell, let type = cell.cellModel?.type {
            healthStoreManager.getRecordForType(type: type) { inHKClinicalRecords in
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showRecordDetails", sender: inHKClinicalRecords)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identity = segue.identifier, identity == "showRecordDetails" {
            guard let params = sender as? [HKClinicalRecord] else { return }
            if let targetVC = segue.destination as? FeatureDetailsViewController {
                targetVC.recordDetails = params
            }
        }
    }
}

extension FeatureLandingViewController {
    
    func getOverAllStatus() -> HKAuthorizationStatus {
        
        return HKAuthorizationStatus.sharingDenied
    }
}

extension FeatureLandingViewController {
    func debugAuthStatuses() {
        healthStoreManager.getRequestStatusForIndividualClinicalRecords(ofType: .allergyRecord) { (inStatus, inError) in
            let status = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .allergyRecord)
            print("HKAuthorizationStatus for Allergy Record is Status = \(status.1!.rawValue)")
        }
        healthStoreManager.getRequestStatusForIndividualClinicalRecords(ofType: .conditionRecord) { (inStatus, inError) in
            let status = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .conditionRecord)
            print("HKAuthorizationStatus for Condition Record is Status = \(status.1!.rawValue)")
        }
        healthStoreManager.getRequestStatusForIndividualClinicalRecords(ofType: .immunizationRecord) { (inStatus, inError) in
            let status = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .immunizationRecord)
            print("HKAuthorizationStatus for Immunization Record is Status = \(status.1!.rawValue)")
        }
        healthStoreManager.getRequestStatusForIndividualClinicalRecords(ofType: .labResultRecord) { (inStatus, inError) in
            let status = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .labResultRecord)
            print("HKAuthorizationStatus for Lab Result Record is Status = \(status.1!.rawValue)")
        }
        healthStoreManager.getRequestStatusForIndividualClinicalRecords(ofType: .medicationRecord) { (inStatus, inError) in
            let status = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .medicationRecord)
            print("HKAuthorizationStatus for Medication Record is Status = \(status.1!.rawValue)")
        }
        healthStoreManager.getRequestStatusForIndividualClinicalRecords(ofType: .procedureRecord) { (inStatus, inError) in
            let status = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .procedureRecord)
            print("HKAuthorizationStatus for Procedure Record is Status = \(status.1!.rawValue)")
        }
        healthStoreManager.getRequestStatusForIndividualClinicalRecords(ofType: .vitalSignRecord) { (inStatus, inError) in
            let status = self.healthStoreManager.isAuthorizedForClinicalRecords(forType: .vitalSignRecord)
            print("HKAuthorizationStatus for VitalSign Record is Status = \(status.1!.rawValue)")
        }
    }
}
