//
//  FishingLocationView.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/9/14.
//

import SwiftUI
import MapKit

struct FishingLocationView: View {
    var body: some View {
        VStack {
            NavigationView {
                MapView()
                    .navigationBarTitle(Text("釣點地圖"), displayMode: .inline)
            }
        }
    }
}

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 25.1125,
            longitude: 121.4582),
        span: MKCoordinateSpan(
            latitudeDelta: 0.005,
            longitudeDelta: 0.005)
        )

    var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
    }
}


struct FishingLocationView_Previews: PreviewProvider {
    static var previews: some View {
        FishingLocationView()
        FishingLocationView()
            .preferredColorScheme(.dark)
    }
}
