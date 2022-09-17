//
//  FishingLocationView.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/9/14.
//

import SwiftUI
import MapKit
import CoreLocationUI

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
    @StateObject private var viewModel = FishingLocationModel()
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
                .tint(.green)
            LocationButton(.currentLocation) {
                viewModel.requestAllowOnceLocationPermission()
            }
            .foregroundColor(.white)
            .cornerRadius(15)
            .labelStyle(.iconOnly)
            .symbolVariant(.fill)
            .padding(10)
        }
    }
}


struct FishingLocationView_Previews: PreviewProvider {
    static var previews: some View {
        FishingLocationView()
        FishingLocationView()
            .preferredColorScheme(.dark)
    }
}


final class FishingLocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.1125, longitude: 121.4582),
        span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008))

    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            return
        }

        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(
                center: latestLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            print("Region --> \(self.region)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
