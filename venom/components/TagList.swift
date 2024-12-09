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
    
    @State var isPresentingDeleteDialog = false
    @State var selectedTag: Tag?
    
    
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
                            tagApi.selectedTag = tag;
                            tagApi.showTagModal = true;
                        }.contextMenu(
                            ContextMenu(menuItems: {
                                Button("Delete Tag", role: .destructive) {
                                    isPresentingDeleteDialog = true;
                                    selectedTag = tag;
                                }
                            })
                        )
                    }
                }
            }
        }
        .navigationTitle(Constants.tagsViewLabel)
        .confirmationDialog(
            "This will delete the tag permanently. Are you sure you wish to proceed?",
            isPresented: $isPresentingDeleteDialog
        ) {
            Button("Delete Tag", role: .destructive) {
                Task {
                    await tagApi.deleteTag(tag: selectedTag!);
                    selectedTag = nil;
                }
            }.onDisappear {
                selectedTag = nil;
            }
        }
    }
}

