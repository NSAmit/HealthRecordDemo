//
//  FeatureLandingViewController.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/9/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import UIKit

class FeatureLandingViewController: UIViewController {

    var viewModel:FeatureLandingViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel?.currentFeature.title
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
