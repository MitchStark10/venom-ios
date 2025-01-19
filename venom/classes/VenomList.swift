//
//  VenomList.swift
//  venom
//
//  Created by Mitch Stark on 1/19/25.
//

class VenomList: Decodable, Hashable, @unchecked Sendable {
    let id, order: Int
    var listName: String
    var isStandupList: Bool
    var tasks: [VenomTask]? = []
    
    static func == (lhs: VenomList, rhs: VenomList) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var identifier: String {
        return String(self.id)
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    public func toJsonObject() -> [String: Any?] {
        return [
            "id": self.id,
            "order": self.order,
            "listName": self.listName,
            "isStandupList": self.isStandupList
        ]
    }
    
}
