//
//  MultiSelect.swift
//  venom
//
//  Created by Mitch Stark on 8/2/24.
//

import Foundation
import SwiftUI

struct MultiSelectData: Hashable {
    var id: String { "\(value)" }
    let value: Int
    let label: String
}

struct MultiSelect: View {
    let title: String
    let items: [MultiSelectData]
    @Binding var selectedItems: Set<Int>;
    @State private var isExpanded: Bool = false;
    
    var expandedImage: String {
        if (isExpanded) {
            return "chevron.down";
        }
        
        return "chevron.up";
    }
    
    var body: some View {
        if (items.count > 0) {
            HStack {
                Text(title)
                Color.clear
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity)
                Image(systemName: expandedImage)
                    .resizable()
                    .frame(width: 15, height: 8)
            }.onTapGesture {
                isExpanded = !isExpanded;
            }
        }
        
        if (isExpanded) {
            List(items, id: \.self, selection: $selectedItems) { item in
                HStack {
                    Text(item.label)
                    Spacer()
                    if selectedItems.contains(item.value) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle()) // Ensures the whole row is tappable
                .onTapGesture {
                    if selectedItems.contains(item.value) {
                        selectedItems.remove(item.value)
                    } else {
                        selectedItems.insert(item.value)
                    }
                }
            }
        }
    }
}
