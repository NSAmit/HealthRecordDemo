//
//  WelcomeModel.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/9/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import Foundation

struct SupportedFeatures {
    let id:SupportedFeaturesId
    var title:String?
}

enum SupportedFeaturesId {
    case healthRecords
    case healthKit
    case researchKit
    case careKit
}
