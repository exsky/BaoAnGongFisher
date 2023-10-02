//
//  FishStamp.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/10/31.
//

import Amplify
import Foundation

struct Stamp: Hashable {
    var imgName: String
    var fishName: String
    //var catched: Int
    var counted: Int
}

//var stampsData = [
//    Stamp(imgName: "石狗公", fishName: "石狗公", catched: 5, counted: 8),
//    Stamp(imgName: "花身鯻", fishName: "花身鯻", catched: 20, counted: 32),
//    Stamp(imgName: "/saved/pics/蝦仁/20230930182929.png", fishName: "花枝", catched: 1, counted: 1)
//]
