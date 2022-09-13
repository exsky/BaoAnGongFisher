//
//  ToxicFish.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/9/9.
//

import Foundation

struct FishRect: Hashable {    // 放置魚資訊的方塊
    var fishName:String    // 魟、虎、沙毛、斑午、象耳、倒吊
    var fishCategory:String    // 魟
    var fishNickName:[String]    // 赤魟
    var imageName:String {return fishName}    // 赤土魟 ...
}

var toxicFishesData = [
    FishRect(fishName: "赤魟", fishCategory: "魟", fishNickName: ["赤土魟", "紅魴魚", "牛尾魴"]),
    FishRect(fishName: "黃魟", fishCategory: "魟", fishNickName: ["笨氏土魟", "黃魴", "紅魴"]),
    FishRect(fishName: "石狗公", fishCategory: "虎", fishNickName: ["石頭魚", "獅甕", "紅鱠仔"]),
    FishRect(fishName: "花身鯻", fishCategory: "斑午", fishNickName: ["花身雞魚", "花身仔", "雞仔魚", "斑午"]),
    FishRect(fishName: "線紋鰻鯰", fishCategory: "沙毛", fishNickName: ["鰻鯰", "沙毛", "海土虱", "斜門"])
]

var fishCates = ["魟", "虎", "沙毛", "斑午"]
