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
    @State var isShowingTagEditor = false;
    
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                if (tagApi.tags.count == 0) {
                    if (!tagApi.hasFetchedTags) {
                        ProgressView()
                    } else {
                        Text("No tags found")
                    }
                }
                
                Section {
                    ForEach(tagApi.tags) { tag in
                        Flag(tag: tag).onTapGesture {
                            isShowingTagEditor = true;
                        }
                    }
                }
            }
        }
        .navigationTitle(Constants.tagsViewLabel)
    }
}

