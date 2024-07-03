//
//  SubViewRouter.swift
//  venom
//
//  Created by Mitch Stark on 7/2/24.
//

import Foundation
import SwiftUI

struct SubViewRouter: View {
    let navMenuItem: NavMenuItem;
    
    var body: some View {
        VStack {
            if (navMenuItem.list != nil) {
                TaskList(taskItems: navMenuItem.list?.tasks ?? [], navTitle: navMenuItem.label)
            } else {
                Text(navMenuItem.label)
            }
        }
    }
}
