//
//  StampAlbumView.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/10/9.
//

import SwiftUI
import Amplify

struct StampAlbumView: View {
    @State private var stamps = stampsData
    // The photo and event state
    @State private var addStampAlertIsPresented: Bool = false
    @State private var addStampName: String = ""
    //@State private var showPhotoOptions = false
    @State private var photoSource: PhotoSource?
    @State private var newStampPhoto: UIImage = UIImage()
    // To add the new stamp into stamps
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 130))
    ]
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .center) {
                ScrollView{
                    LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                        //ForEach(stampData, id: \.self) { number in
                        ForEach(Array(zip(stamps.indices, stamps)), id: \.0) { index, stamp in
                            ZStack{
                                // Stamp here
                                FishStampView(
                                    imgName: stamp.imgName, fishName: stamp.fishName,
                                    catched: stamp.catched, counted: stamp.counted, number: index+1
                                )
                            } // end of zstack
                        } // end of stampData
                        ZStack{ // 跳出新增郵票框框
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
                                Label("", systemImage: "plus.rectangle.on.folder.fill")
                                .labelStyle(.iconOnly)
                                .frame(width: 40, height:40)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .cornerRadius(15)
                                .padding(5)
                                .onTapGesture {
                                    self.addStampAlertIsPresented = true
                                    // self.showPhotoOptions.toggle()
                                    self.createStamp()
                                }
                            }
                        }
                        //StampSync()
                    }
                } // end of scroll view
                .navigationBarTitle("集郵冊")
                .navigationBarItems(
                    trailing:
                        Button(action: {
                            print("Sync button pressed...")
                        }) {
                            Label("Sync", systemImage: "arrow.up.right.and.arrow.down.left.rectangle.fill")
                            //Text("Sync")
                        }
                )
                // The box for insert new stamp
                AddStampAlert(alertIsPresented: $addStampAlertIsPresented,
                              newStampName: $addStampName,
                              newStampPhoto: $newStampPhoto,
                              wholeStamps: $stamps
                )
            } // end of zstack
            
        }
    }
    
    func createStamp() {
        // 當輸入介面按下完成後
        // 1. 把 self.newStampPhoto 的 UIImage 存成檔案
        // 2. 產生 FishStampView 並給予魚名、圖片路徑、抓到和看到的數量為 1 (如果開雙弓就先不討論)
        FishStampView(
            imgName: self.addStampName,
            fishName: self.addStampName,
            catched: 1, counted: 1, number: stamps.count
        )
        print("Create !!!")
    }
}

struct StampAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        StampAlbumView()
    }
}

// 郵票
struct FishStampView: View {
    // 先定義好要接收的參數名稱與類型
    var imgName: String // TODO: change the src to amplify
    var fishName: String
    var catched: Int
    var counted: Int
    var number: Int // The fish serial number
    private let colors: [Color] = [
        .red, .blue, .green, .yellow, .pink, .cyan, .indigo]
    
    var body: some View {
        Rectangle()  // 底部是個方塊
            .frame(width: 180, height: 250)
            .foregroundColor(colors[number%7])
            .cornerRadius(10)
        VStack{  // 中間放一層 垂直堆 // A stamp
            HStack{
                Text("\(catched)/\(counted)")
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
            Text("**\(fishName)**")
            Image("\(fishName)")
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
        } // end of a stamp
    }
    
    func addStampByName() {
        // pass
        print("ADD !!!")
    }
    
    func editStampByName() {
        // pass
    }
    
    func deleteStampByName() {
        // pass
    }
}

struct StampSync: View {
    // the data function for Stamp model
    @State var fileStatus: String?
    
    var body: some View {
        if let fileStatus = self.fileStatus {
            Text(fileStatus)
        }
        Button("Upload File", action: uploadStamp).padding()
    }
    
    func uploadStamp() {
        // pass
    }
}
