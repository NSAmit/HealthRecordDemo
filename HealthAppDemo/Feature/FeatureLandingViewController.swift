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
            self.statusLabel?.text = "Thanks for giving access to read the Health Records. \nAppreciate it. \n\nRefresh in case you want to update."
            self.actionStatusButton?.setTitle("Refresh", for: .normal)
            self.actionStatusButton?.isEnabled = true
            self.actionStatusButton?.isHidden = false
        case .unknown:
            self.statusLabel?.text = "Some error in determining the Health Record feature for now. \nApologies."
            self.actionStatusButton?.isEnabled = false
            self.actionStatusButton?.isHidden = true
        }
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
}

extension FeatureLandingViewController {
    
    func getOverAllStatus() -> HKAuthorizationStatus {
        
        return HKAuthorizationStatus.sharingDenied
    }
}
