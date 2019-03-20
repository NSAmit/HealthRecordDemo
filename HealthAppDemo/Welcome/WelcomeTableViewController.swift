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
    
    let viewModel = WelcomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.supportedFeatures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = viewModel.supportedFeatures[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFeatureLanding", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showFeatureLanding":
            if let destinationVC = segue.destination as? FeatureLandingViewController {
                if let indexPath = sender as? IndexPath {
                    destinationVC.currentFeatures = viewModel.supportedFeatures[indexPath.row]
                }
            }
        default:
            break
        }
    }
}
