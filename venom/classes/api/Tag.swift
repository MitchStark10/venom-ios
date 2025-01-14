//
//  Tag.swift
//  venom
//
//  Created by Mitch Stark on 7/2/24.
//

import Foundation
import SwiftUI

class Tag: Decodable, Identifiable, @unchecked Sendable {
    let id: Int;
    var tagName: String;
    var tagColor: String;
    
    public func toJsonObject() -> [String: Any?] {
        return [
            "tagName": self.tagName,
            "tagColor": self.tagColor
        ]
    }
}

class TagApi: ApiClient, ObservableObject, @unchecked Sendable {
    @Published var hasFetchedTags = false;
    @Published var tags: [Tag] = [];
    @Published var showTagModal = false;
    @Published var selectedTag: Tag?
    
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
    
    public func createTag(tagName: String, tagColor: String) async {
        do {
            let createTagRequest = ["tagName": tagName, "tagColor": tagColor]
            try await sendApiCall(url: Constants.tagsUrl!, requestMethod: "POST", requestBody: createTagRequest)
            await self.fetchTags()
        } catch {
            print("Caught error when creating tag \(error)")
        }
    }
    
    public func updateTag(tag: Tag) async {
        do {
            try await sendApiCall(url: Constants.getTagUrlWithId(id: tag.id), requestMethod: "PUT", requestBody: tag.toJsonObject())
            await self.fetchTags()
        } catch {
            print("Caught error when creating tag \(error)")
        }
    }
    
    public func deleteTag(tag: Tag) async {
        do {
            try await sendApiCall(url: Constants.getTagUrlWithId(id: tag.id), requestMethod: "DELETE")
            await self.fetchTags()
        } catch {
            print("Caught error when creating tag \(error)")
        }
    }
}
