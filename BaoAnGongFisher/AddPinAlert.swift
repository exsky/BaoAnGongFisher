//
//  AddPinAlert.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/9/22.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct AddPinAlert: View {

    let screenSize = UIScreen.main.bounds
    @Binding var alertIsPresented: Bool
    @Binding var myLocationName: String
    @Binding var currentRegion: MKCoordinateRegion
    @Binding var pinsData: [PinLocation]
    @State var myLocationRank: Int = 3
    var boxTitle: String = "在十字記號下新增私房釣點？"

    var body: some View {
        VStack {
            Text(boxTitle)
            TextField("自訂名稱", text: $myLocationName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Picker("", selection: $myLocationRank) {
                Text("不推").tag(1)
                Text("龜").tag(2)
                Text("普通 / 未知").tag(3)
                Text("好").tag(4)
                Text("超讚").tag(5)
            }
            Spacer()
            HStack (alignment: .center){
                Spacer()
                Button("好") {
                    print(currentRegion)
                    saveLocation()
                    self.alertIsPresented = false
                }
                Spacer()
                Button("取消") {
                    self.alertIsPresented = false
                }
                Spacer()
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.6, height: screenSize.height * 0.2)
        .background(Color.cyan)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.gray, radius: 15, x: -1, y: -1)
        .offset(y: alertIsPresented ? screenSize.height * 0.2 : screenSize.height)
    }

    func saveLocation() {
        self.pinsData.append(
            PinLocation(name: myLocationName, image:"",
                        coordinate: CLLocationCoordinate2D(latitude: currentRegion.center.latitude,
                                                           longitude: currentRegion.center.longitude),
                        rank: myLocationRank)
        )
    }
}

struct AddPinAlert_Previews: PreviewProvider {
    static var previews: some View {
        //AddPinAlert(alertIsPresented: .constant(true), myLocationName: .constant(""))
        AddPinAlert(alertIsPresented: .constant(false), myLocationName: .constant(""),
                    currentRegion: .constant(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: 25.144274, longitude: 121.381837),
                            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
                        ),
                    pinsData: .constant(SecretLocationsData)
        )
    }
}
