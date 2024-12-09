//
//  TagModal.swift
//  venom
//
//  Created by Mitch Stark on 12/8/24.
//
import SwiftUI

struct TagModal: View {
    var tag: Tag?
    
    @EnvironmentObject var tagApi: TagApi
    
    @State var tagName: String
    @State var tagColor: String
    
    init(tag: Tag? = nil) {
        self.tag = tag
        self.tagName = tag?.tagName ?? ""
        self.tagColor = tag?.tagColor ?? "blue"
    }
    
    var body: some View {
        VStack {
            Form {
                TextField(text: $tagName, prompt: Text("Tag Name"), axis: .vertical) {
                    Text("Tag Name")
                }
                Picker("Color", selection: $tagColor) {
                    ForEach(Constants.colorOptions, id: \.self) { color in
                        Text(color.capitalized).tag(color)
                    }
                }
               HStack {
                    Button(action: {
                        tagApi.selectedTag = nil;
                        tagApi.showTagModal = false;
                    }) {
                        Text("Dismiss")
                    }.buttonStyle(BorderlessButtonStyle()).padding()
                    
                    Spacer()
                    
                   Button(action: {
                       Task {
                           if (tag != nil) {
                               tag!.tagName = tagName
                               tag!.tagColor = tagColor
                               await tagApi.updateTag(tag: tag!)
                           } else {
                               await tagApi.createTag(tagName: tagName, tagColor: tagColor)
                           }
                           tagApi.selectedTag = nil
                           tagApi.showTagModal = false
                       }
                   }) {
                       Text("Save")
                   }.buttonStyle(BorderedButtonStyle())
                       .disabled(isDisabled)
                }
            }
        }
    }
    
    var isDisabled: Bool {
        return tagName.isEmpty || tagColor.isEmpty
    }
}
