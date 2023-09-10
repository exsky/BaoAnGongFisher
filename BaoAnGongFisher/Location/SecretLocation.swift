//
//  SecretLocation.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/9/20.
//

import Foundation
import CoreLocation

struct ScreenLocation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D

    init(latitude: Double, longitude: Double) {
        self.coordinate = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
    }

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    init() {
        self.coordinate = CLLocationCoordinate2D(latitude:0, longitude:0)
    }
}

struct PinLocation: Identifiable {
    let id = UUID()
    var name: String
    var image: String
    var coordinate: CLLocationCoordinate2D
    var rank: Int

    init(name: String, image: String, coordinate: CLLocationCoordinate2D, rank: Int) {
        self.name = name
        self.image = image
        self.coordinate = coordinate
        self.rank = rank
    }

    init() {
        self.name = "秘密釣點 - 五股聖母宮"
        self.image = "default"
        self.coordinate = CLLocationCoordinate2D(latitude:25.1125, longitude:121.4582)
        self.rank = 5   // 1: Bad ~ 5: Good
    }
}

// 釣點圖釘標記位置
struct FishPinAnnotation: Hashable, Codable{
    var name: String
    var image: String
    var latitude: Double
    var longitude: Double
    var rank: Int
}
