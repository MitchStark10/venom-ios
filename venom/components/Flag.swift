//
//  Flag.swift
//  venom
//
//  Created by Mitch Stark on 8/2/24.
//

import Foundation
import SwiftUI

struct Flag: View {
    let tag: Tag;
    
    private func getColorFromTagColor(tagColor: String) -> Color {
        if (tagColor.lowercased() == "red") {
            return Color.red;
        } else if (tagColor.lowercased() == "blue") {
            return Color.blue;
        } else if (tagColor.lowercased() == "orange") {
            return Color.orange;
        }
        
        return Color(UIColor(red: 0, green: 102/255.0, blue: 51/255.0, alpha: 1.0));
    }
    
    var body: some View {
        Text(tag.tagName)
            .foregroundColor(.white)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 1)
            .background(
                Capsule()
                    .fill(getColorFromTagColor(tagColor: tag.tagColor))
            )
    }
}
