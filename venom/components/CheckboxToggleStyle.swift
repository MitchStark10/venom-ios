//
//  CheckboxToggleStyle.swift
//  venom
//
//  Created by Mitch Stark on 7/22/24.
//

import Foundation
import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    let onTap: () -> Void
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(configuration.isOn ? Color.blue : Color.clear)
                .frame(width: 20, height: 20)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                    self.onTap()
                }
            
            configuration.label
        }
    }
}
