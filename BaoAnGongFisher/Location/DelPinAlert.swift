//
//  DelPinAlert.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/10/18.
//

import SwiftUI

struct DelPinAlert: View {

    let screenSize = UIScreen.main.bounds
    @Binding var alertIsPresented: Bool
    @Binding var locationLoader: LocationLoader
    var boxTitle: String = "刪除釣點"

    var body: some View {
        VStack {
            Text(boxTitle)
                .font(.title2)
                .fontWeight(.semibold)
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(Array(self.locationLoader.encodeCoordinate().enumerated()), id: \.element) { index, item in
                        HStack {
                            Text(item.name)
                                .frame(alignment: .leading)
                                .font(.headline)
                            Spacer()
                            Button {
                                delSingleLocation(pin: item, index: index)
                            } label: {
                                Label("", systemImage: "xmark.bin.circle")
                                    .labelStyle(.iconOnly)
                                    .frame(width: 20, height:20)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                                    .padding(10)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.6, height: screenSize.height * 0.4)
        .background(Color.indigo)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.gray, radius: 15, x: -1, y: -1)
        .offset(y: alertIsPresented ? screenSize.height * 0.1 : screenSize.height)
    }
    
    func delSingleLocation(pin: FishPinAnnotation, index: Int) {
        //func delSingleLocation(at indexSet: IndexSet) {
        self.locationLoader.locationData.remove(at: index)
        self.locationLoader.saveAndReloadLocation()
        self.alertIsPresented.toggle()
    }
}

struct DelPinAlert_Previews: PreviewProvider {
    static var previews: some View {
        DelPinAlert(alertIsPresented: .constant(false),
                    locationLoader: .constant(LocationLoader())
        )
    }
}

