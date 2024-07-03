//
//  Tag.swift
//  venom
//
//  Created by Mitch Stark on 7/2/24.
//

import Foundation

struct Tag: Decodable {
    let id: Int;
    let tagName: String;
    let tagColor: String;
}
