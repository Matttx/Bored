//
//  FilterTips.swift
//  Bored
//
//  Created by Mattéo Fauchon  on 30/11/2023.
//

import Foundation
import TipKit

struct FilterIconTip: Tip {
    
    var title: Text {
        Text("Filters")
    }
    
    var message: Text? {
        Text("Add filters to the activity by tapping here")
    }
    
    var image: Image? {
        Image(systemName: "list.bullet.circle")
    }
    
    var rules: [Rule] {
        #Rule(Self.fetchActivityAtleast3TimesEvent) { $0.donations.count > 3 }
    }
    
    static let fetchActivityAtleast3TimesEvent: Event = .init(id: "fetch-activity-atleast-3-times")
}
