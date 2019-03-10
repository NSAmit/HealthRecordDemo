//
//  WelcomeViewModel.swift
//  HealthAppDemo
//
//  Created by Amit C Rote on 3/9/19.
//  Copyright © 2019 Amit C Rote. All rights reserved.
//

import Foundation

class WelcomeViewModel {
    let supportedFeatures:[SupportedFeatures]
    init() {
        supportedFeatures = [SupportedFeatures(id:1, title:"Health Records")]
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
}
