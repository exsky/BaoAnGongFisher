//
//  ContentView.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/9/7.
//

import SwiftUI


struct ToxicFishListView: View {
    var toxicfishes = toxicFishesData
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(fishCates, id: \.self) { fishCate in
                    VStack {
                        NavigationView {
                            List(toxicfishes, id: \.self) { toxicfish in    // 每一種魚
                                // Fish Rectangle
                                if toxicfish.fishCategory == fishCate {
                                    FishCardView(
                                        imgName: toxicfish.imageName,
                                        fishName: toxicfish.fishName,
                                        fishNickName: toxicfish.fishNickName)
                                }   // end of 每一種魚
                            }
                            .listRowSeparator(.hidden)
                            .navigationTitle(fishCate)
                        }
                    }   // end of 每一分類魚
                }
            }
            .navigationBarTitle(Text("危險魚類圖鑑"), displayMode: .inline)
        }
    }
}

struct ToxicFishListView_Previews: PreviewProvider {
    static var previews: some View {
        ToxicFishListView()
        ToxicFishListView()
            .preferredColorScheme(.dark)
    }
}

// 魚卡
struct FishCardView: View {
    
    // 先定義好要接收的參數名稱與類型
    var imgName: String
    var fishName: String
    var fishNickName: [String]
    
    var body: some View {
        HStack {    // 有毒的魚，會以水平方式堆疊其他元件
            // 最左邊放一張圖片
            Image(imgName)
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(4)
            // 放一個垂直堆疊
            VStack {
                // 魚的名字
                HStack {
                    Text(fishName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(alignment: .leading)
                    Spacer()
                }
                // 魚的俗名，把 [String] join 成一個大的字串
                HStack {
                    Text(fishNickName.joined(separator: "、 "))
                        .frame(width: 200, alignment: .leading)
                        .background(Color(hue: 0.279, saturation: 1.0, brightness: 1.0, opacity: 0.21))
                    Spacer()
                }
            }
            Button(action: {
                if let yourURL = URL(string: "www.youtube.com") {
                    UIApplication.shared.open(yourURL, options: [:], completionHandler: nil)
                }

            }) {
               Text("Go to youtube")
            }
        }
    }
}
