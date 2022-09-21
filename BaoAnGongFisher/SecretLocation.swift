//
//  SecretLocation.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/9/20.
//

import Foundation
import CoreLocation

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

var SecretLocationsData = [
    PinLocation(name: "五股聖母宮", image:"", coordinate: CLLocationCoordinate2D(latitude: 25.1125, longitude: 121.4582), rank: 5),
    PinLocation(name: "台北港 (北堤)", image:"", coordinate: CLLocationCoordinate2D(latitude: 25.169456, longitude: 121.389712), rank:3),
    PinLocation(name: "八里左岸", image:"", coordinate: CLLocationCoordinate2D(latitude: 25.160970, longitude: 121.432821), rank:4),
    PinLocation(name: "下罟子漁港", image:"", coordinate: CLLocationCoordinate2D(latitude: 25.144274, longitude: 121.381837), rank:2),
    PinLocation(name: "林口發電廠 (南側)", image:"", coordinate: CLLocationCoordinate2D(latitude: 25.121356, longitude: 121.295589), rank:5),
    PinLocation(name: "林口發電廠出海口 (北側)", image:"", coordinate: CLLocationCoordinate2D(latitude: 25.125, longitude: 121.3), rank:3),
    PinLocation(name: "竹圍漁港 (南堤階梯)", image:"", coordinate: CLLocationCoordinate2D(latitude: 25.116585, longitude: 121.240676), rank:1),
    PinLocation(name: "竹圍漁港 (南堤港內)", image:"", coordinate: CLLocationCoordinate2D(latitude: 25.116848, longitude: 121.241588), rank:2),
]
