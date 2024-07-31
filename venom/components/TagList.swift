//
//  TagList.swift
//  venom
//
//  Created by Mitch Stark on 7/30/24.
//

import Foundation
import SwiftUI

struct TagList: View {
    @EnvironmentObject var tagApi: TagApi;
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                if (tagApi.tags.count == 0) {
                    Text("No tags found")
                }
                
                Section {
                    ForEach(tagApi.tags) { tag in
                        Text(tag.tagName)
                    }
                }
            }
        }
        .navigationTitle("Tags")
    }
}

