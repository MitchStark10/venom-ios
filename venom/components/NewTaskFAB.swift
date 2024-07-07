//
//  NewTaskFAB.swift
//  venom
//
//  Created by Mitch Stark on 6/28/24.
//
import SwiftUI

struct NewTaskFAB: View {
    @Binding var isShowingNewTaskModal: Bool
    var body: some View {
        Button {
            isShowingNewTaskModal = true;
        } label: {
            Image(systemName: "plus")
                .font(.title.weight(.semibold))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 4, x: 0, y: 4)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 40)
    }
}
