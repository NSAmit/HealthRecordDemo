//
//  HealthRecordModel.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/10/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import Foundation
import HealthKit

struct HealthRecordModel {
    let type:HKClinicalTypeIdentifier
    let authorizationStatus:HKAuthorizationStatus
    let displayString:String
    
    init(inType: HKClinicalTypeIdentifier, inStatus: HKAuthorizationStatus, inDisplayString: String) {
        self.type = inType
        self.authorizationStatus = inStatus
        self.displayString = inDisplayString
    }
}
