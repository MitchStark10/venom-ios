//
//  Tag.swift
//  venom
//
//  Created by Mitch Stark on 7/2/24.
//

import Foundation

struct Tag: Decodable, Identifiable {
    let id: Int;
    let tagName: String;
    let tagColor: String;
}

class TagApi: ObservableObject {
    @Published var hasFetchedTags = false;
    @Published var tags: [Tag] = [];
    
    public func fetchTags() async {
        do {
            let tagsResponse = try await sendApiCall(url: Constants.tagsUrl!, requestMethod: "GET")
            let newTags = try JSONDecoder().decode([Tag].self, from: tagsResponse)
            DispatchQueue.main.async {
                self.tags = newTags;
                self.hasFetchedTags = true;
            }
        } catch {
            print("Caught error when fetching lists \(error)")
        }
    }
}
