//
//  CoversationViewModel.swift
//  MediMate
//
//  Created by Simon Bestler on 11.05.25.
//

import Foundation


class ConversationViewModel: ObservableObject, FlowStepViewModel {

    var isStaticVideo: Bool { false }


    var title: String { "Share Additional Information" }

    var isComplete: Bool { true } // Always allow skip

    func handleSave() {
        
    }

    func onNext(completion: @escaping (Bool) -> Void) {
        print("Call next")
    }
    



}
