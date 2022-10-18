//
//  StampAlbumView.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/10/9.
//

import SwiftUI

struct StampAlbumView: View {
    private var stampData: [Int] = Array(1...3)
    private let colors: [Color] = [
        .red, .blue, .green, .yellow, .pink, .cyan, .indigo]
    // The photo and event state
    // @State private var newStampPhoto = UIImage(systemName: "camera")!
    @State private var newStampPhoto = UIImage()
    @State private var showPhotoOptions = false
    @State private var photoSource: PhotoSource?
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 130))
    ]
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                    ForEach(stampData, id: \.self) { number in
                        ZStack{
                            Rectangle()  // 底部是個方塊
                                .frame(width: 180, height: 250)
                                .foregroundColor(colors[number%7])
                                .cornerRadius(10)
                            VStack{  // 中間放一層 垂直堆
                                HStack{
                                    Text("1/1")
                                        .padding()
                                        .font(.footnote)
                                    Spacer()
                                    Text("\(number)")
                                        .frame(width: 15, height: 15, alignment: .center)
                                        .font(.footnote)
                                        //.fontWeight(.bold)
                                        .padding()
                                        //.background(Color(.gray))
                                        .overlay(
                                            Circle()
                                                .size(width: 16, height: 16)
                                                .offset(x: 16,y: 16)
                                                .scale(1.5)
                                                .stroke(Color.orange, lineWidth: 3)
                                        )
                                }
                                .padding(10)
                                Text("**石狗公**")
                                Image("石狗公")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                // Button
                                HStack{
                                    Button(action: addStampByName) {
                                        Label("", systemImage: "plus.rectangle.fill.on.rectangle.fill")
                                        .labelStyle(.iconOnly)
                                        .frame(width: 40, height:40)
                                        .foregroundColor(.white)
                                        .background(Color.black)
                                        .cornerRadius(15)
                                        .padding(5)
                                    }
                                    Button(action: editStampByName) {
                                        Label("", systemImage: "pencil")
                                        .labelStyle(.iconOnly)
                                        .frame(width: 40, height:40)
                                        .foregroundColor(.white)
                                        .background(Color.black)
                                        .cornerRadius(15)
                                        .padding(5)
                                    }
                                    Button(action: deleteStampByName) {
                                        Label("", systemImage: "xmark.bin")
                                        .labelStyle(.iconOnly)
                                        .frame(width: 40, height:40)
                                        .foregroundColor(.white)
                                        .background(Color.black)
                                        .cornerRadius(15)
                                        .padding(5)
                                    }
                                }
                                Spacer()
                            }
                        }
                    } // end of stampData
                    ZStack{ // Camera
                        Rectangle()  // 底部是個方塊
                            .frame(width: 180, height: 250)
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                        VStack {
                            Image(uiImage: newStampPhoto)
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                        Button(action: createStamp) {
                            Label("", systemImage: "camera")
                            .labelStyle(.iconOnly)
                            .frame(width: 40, height:40)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(15)
                            .padding(5)
                            .onTapGesture {
                                self.showPhotoOptions.toggle()
                            }
                        }
                    }
                }
            }
            .navigationTitle("集郵冊")
            .actionSheet(isPresented: $showPhotoOptions) {
                
                ActionSheet(title: Text("選擇相片來源"),
                            message: nil,
                            buttons: [
                                .default(Text("相機")) {
                                    self.photoSource = .camera
                                },
                                .default(Text("照片")) {
                                    self.photoSource = .photoLibrary
                                },
                                .cancel(Text("取消"))
                            ])
            }
        }
        .fullScreenCover(item: $photoSource) { source in
            switch source {
            case .photoLibrary: ImagePicker(sourceType: .photoLibrary, selectedImage: $newStampPhoto).ignoresSafeArea()
            case .camera: ImagePicker(sourceType: .camera, selectedImage: $newStampPhoto).ignoresSafeArea()
            }
        }
    }
    
    func addStampByName() {
        // pass
    }
    
    func editStampByName() {
        // pass
    }
    
    func deleteStampByName() {
        // pass
    }
    
    func createStamp() {
        // pass
    }
}

enum PhotoSource: Identifiable {
    case photoLibrary
    case camera
    
    var id: Int {
        hashValue
    }
}

struct StampAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        StampAlbumView()
    }
}
