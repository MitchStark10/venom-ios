//
//  NavMenuItem.swift
//  venom
//
//  Created by Mitch Stark on 7/2/24.
//

import Foundation

struct NavMenuItem: Hashable, Equatable {
    let label: String;
    let list: VenomList?;
    
    static func == (lhs: NavMenuItem, rhs: NavMenuItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var identifier: String {
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    init(label: String, list: VenomList? = nil) {
        self.label = label
        self.list = list
    }
}
