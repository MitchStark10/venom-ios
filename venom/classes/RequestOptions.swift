//
//  RequestOptions.swift
//  venom
//
//  Created by Mitch Stark on 1/11/25.
//

struct RequestOptions {
    let verboseLogging: Bool
    let toastOnErrors: Bool
    let fallbackErrorMessage: String
    
    init(
        verboseLogging: Bool = false,
        toastOnErrors: Bool = true,
        fallbackErrorMessage: String = "An error occurred. Please try again."
    ) {
        self.verboseLogging = verboseLogging
        self.toastOnErrors = toastOnErrors
        self.fallbackErrorMessage = fallbackErrorMessage
    }}
