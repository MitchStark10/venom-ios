//
//  DropdownMenu.swift
//  venom
//
//  Created by Mitch Stark on 7/3/24.
//

import Foundation
import SwiftUI

struct DropdownMenu: View {
    @Binding var selectedOption: String
    let options: [String]
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.isExpanded.toggle()
            }) {
                HStack {
                    Text(selectedOption.isEmpty ? "Select an option" : selectedOption)
                        .foregroundColor(selectedOption.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
            }

            if isExpanded {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        self.selectedOption = option
                        self.isExpanded = false
                    }) {
                        Text(option)
                            .padding()
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                }
            }
        }
        .padding()
    }
}
