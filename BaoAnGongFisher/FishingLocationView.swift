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
    // 用來記錄長按手勢是否被觸發
    @State private var isLongPressed = false
    @StateObject private var viewModel = FishingLocationModel()
    @State private var SecretLocations = SecretLocationsData

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: SecretLocations) { item in
                    // MapMarker(coordinate: item.coordinate, tint: .red)
                    MapAnnotation(coordinate: item.coordinate) {
                        Text(item.name)
                            .fontWeight(.light)
                            .font(.caption2)
                        switch item.rank {
                        case 1:
                            Image(systemName: "hand.thumbsdown.circle.fill")
                                .foregroundColor(.red)
                                .background(Color.white)
                                .clipShape(Circle())
                        case 2:
                            Image(systemName: "tortoise.fill")
                                .foregroundColor(.orange)
                        case 3:
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.gray)
                                .background(Color.white)
                                .clipShape(Circle())
                        case 4:
                            Image(systemName: "face.smiling.fill")
                                .foregroundColor(.cyan)
                                .background(Color.white)
                                .clipShape(Circle())
                        case 5:
                            Image(systemName: "hand.thumbsup.circle.fill")
                                .foregroundColor(.green)
                                .background(Color.white)
                                .clipShape(Circle())
                        default:
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.gray)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .gesture(DragGesture())
                .onLongPressGesture {
                    isLongPressed.toggle()
                }.actionSheet(isPresented: $isLongPressed) {
                    ActionSheet(title: Text("新增私房釣點嗎？"),
                                message: nil,
                                buttons: [
                                    .default(Text("新增釣點")) {
                                        // Yes
                                    },
                                    .cancel()
                                ])
                }
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
        center: CLLocationCoordinate2D(latitude: 25.144274, longitude: 121.381837),
        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))

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
