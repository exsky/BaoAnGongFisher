//
//  MainListView.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/10/9.
//

import SwiftUI

struct MainListView: View {
    
    var body: some View {
        TabView {
            StampAlbumView()
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("集郵冊")
                }
            ToxicFishListView()
                .tabItem {
                    Image(systemName: "xmark.shield.fill")
                    Text("危險魚類")
                }
            FishingLocationView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("私藏釣點")
                }
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
