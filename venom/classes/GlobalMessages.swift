//
//  GlobalMessages.swift
//  venom
//
//  Created by Mitch Stark on 1/11/25.
//
import SwiftUI
import Foundation

class GlobalMessages: ObservableObject {
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
}
