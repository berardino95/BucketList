//
//  PinScreenView.swift
//  BucketList
//
//  Created by Berardino Chiarello on 03/07/23.
//

import SwiftUI

struct PinScreenView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var insertedPin = ""
    var pin : (String) -> Void
    
    var body: some View {
        VStack (spacing: 5){
            Spacer()
            Text("Insert your pin")
                .font(.title)
            Text("To unlock saved places")
            
            Spacer()
            HStack {
                Spacer()
                TextField("Insert your pin", text: $insertedPin)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke( .blue, lineWidth: 2)
                        
                    }
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                
                Button ("OK"){
                    pin(insertedPin)
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding(.horizontal, 50)
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
    }
    
    init(pin: @escaping (String) -> Void) {
        self.pin = pin
    }
    
}

struct PinScreenView_Previews: PreviewProvider {
    static var previews: some View {
        PinScreenView() { _ in }
    }
}
