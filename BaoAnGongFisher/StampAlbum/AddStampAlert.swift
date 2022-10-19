//
//  AddStampAlert.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/10/18.
//

import SwiftUI

struct AddStampAlert: View {
    
    let screenSize = UIScreen.main.bounds
    @Binding var alertIsPresented: Bool
    @Binding var newStampName: String
    var boxTitle: String = "開郵票"
    
    var body: some View {
        VStack {
            Text(boxTitle)
            TextField("魚名", text: $newStampName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
        .frame(width: screenSize.width * 0.6, height: screenSize.height * 0.2)
        .background(Color.cyan)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.gray, radius: 15, x: -1, y: -1)
        .offset(y: alertIsPresented ? screenSize.height * 0.2 : screenSize.height)
    }
}

struct AddStampAlert_Previews: PreviewProvider {
    static var previews: some View {
        AddStampAlert(
            alertIsPresented: .constant(false),
            newStampName: .constant("xx魚")
        )
    }
}
