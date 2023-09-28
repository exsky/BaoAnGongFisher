//
//  AddStampAlert.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/10/18.
//

import SwiftUI
import Amplify

struct AddStampAlert: View {
    
    let screenSize = UIScreen.main.bounds
    @Binding var alertIsPresented: Bool
    @Binding var newStampName: String   // 1
    @Binding var newStampPhoto: UIImage // 2
    @Binding var wholeStamps: [Stamp]
    @Binding var fileQueue: [URL]
    @State private var showPhotoOptions: Bool = false
    //@State private var newStampPhoto = UIImage()
    @State private var photoSource: PhotoSource?
    var boxTitle: String = "新增郵票"
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack {
            Text(boxTitle)
            HStack {
                Text("名稱：")
                    .frame(width: 50, alignment: .leading)
                TextField("魚名", text: $newStampName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isFocused)
                    //.onChange(of:isFocused){value in
                    //    print(value)}
                //Button(action: { isFocused = true }) {
                //    Label("", systemImage: "checkmark.square.fill")
                //}
                Spacer()
            }.onTapGesture {
                self.isFocused.toggle()
            }
            HStack {
                Text("照片：")
                    .frame(width: 50, alignment: .leading)
                Button(action: takeFishPhoto) {
                    Label("", systemImage: "camera")
                    .labelStyle(.iconOnly)
                    .frame(width: 40, height:40)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(15)
                    .padding(5)
                    .onTapGesture {
                        // print("click take photo")
                        self.showPhotoOptions.toggle()
                    }
                }
                Spacer()
            }
            HStack { // 預覽
                Text("預覽：")
                    .frame(width: 50, alignment: .leading)
                Image(uiImage: newStampPhoto)
                    .resizable()
                    .frame(width: 100, height: 100)
                Spacer()
            }
            Spacer()
            HStack (alignment: .center){
                Spacer()
                Button("取消") {
                    // Clean the newStampName and newStampPhoto or not to add
                    self.alertIsPresented = false
                }
                .foregroundColor(Color(red: 1.0, green: 0.0, blue: 0.0))
                Spacer()
                Button("完成") {
                    // 當輸入介面按下完成後
                    // 1. 把 self.newStampPhoto 的 UIImage 存成檔案
                    saveFishPicToFile(newStampPhoto)
                    // 2. Hide Add Alert box
                    self.alertIsPresented = false
                    // 在 binding 資料 StampData 加入新郵票
                    wholeStamps.append(Stamp(imgName: "/saved/pics/\(newStampName).png",
                                             fishName: newStampName,
                                             catched: 1, counted: 1)
                    )
                }
                .foregroundColor(Color(red: 1.0, green: 1.0, blue: 0.0))
                Spacer()
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.6, height: screenSize.height * 0.5)
        .background(Color.cyan)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color.gray, radius: 15, x: -1, y: -1)
        .offset(y: alertIsPresented ? screenSize.height * 0.1 : screenSize.height)
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
        .fullScreenCover(item: $photoSource) { source in
            switch source {
            case .photoLibrary: ImagePicker(sourceType: .photoLibrary, selectedImage: $newStampPhoto).ignoresSafeArea()
            case .camera: ImagePicker(sourceType: .camera, selectedImage: $newStampPhoto).ignoresSafeArea()
            }
        }
    }
    
    func takeFishPhoto() {
        print("Take fish photo !!")
        self.showPhotoOptions.toggle()
    }

    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        return path.first
    }
    
    func saveFishPicToFile(_ image: UIImage) {
        print("store fish pic locally")
        // Create Dir
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        //print(url.path)
        let newFolderUrl = url.appendingPathComponent("saved")
        do {
            try manager.createDirectory(at: newFolderUrl, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
        // Create file
        let fileUrl = newFolderUrl.appendingPathComponent("\(newStampName).png")
        print(fileUrl)  // 編碼會變成 url 型態，所以中文字會變成 %E4%BD%A0 這種樣子
        let pngData = image.pngData()
        //let path = documentDirectoryPath()?.appendingPathComponent("/pics/\(newStampName).png")
        try? pngData?.write(to: fileUrl)
        print(type(of: fileUrl))
        print("save pic to \(fileUrl)")
        fileQueue.append(fileUrl)
    }
}

enum PhotoSource: Identifiable {
    case photoLibrary
    case camera
    
    var id: Int {
        hashValue
    }
}

struct AddStampAlert_Previews: PreviewProvider {
    static var previews: some View {
        AddStampAlert(
            alertIsPresented: .constant(true),
            newStampName: .constant("xx魚"),
            newStampPhoto: .constant(UIImage()),
            wholeStamps: .constant([]),
            fileQueue: .constant([])
        )
    }
}
