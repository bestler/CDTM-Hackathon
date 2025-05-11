//
//  ConversationView.swift
//  MediMate
//
//  Created by Simon Bestler on 11.05.25.
//

import SwiftUI

struct ConversationView: View {

    @ObservedObject var viewModel: ConversationViewModel

    var body: some View {
        TextField("You can also add your information here...", text: .constant(""))
            .padding() // Add some internal padding for better visual spacing
            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.3)
            .background(Color(.systemGray6)) // Use a light gray background
            .cornerRadius(8) // Add a corner radius for rounded edges
            .padding() // Optional: Add some padding around the TextField
    }

}

