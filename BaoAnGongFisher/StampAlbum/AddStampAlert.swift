//
//  AddStampAlert.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/10/18.
//

import SwiftUI

struct AddStampAlert: View {
    
    let screenSize = UIScreen.main.bounds
    @Binding var alertIsPresented: Bool
    @Binding var newStampName: String
    @Binding var newStampPhoto: UIImage
    @State private var showPhotoOptions: Bool = false
    //@State private var newStampPhoto = UIImage()
    @State private var photoSource: PhotoSource?
    var boxTitle: String = "新增郵票"
    
    var body: some View {
        VStack {
            Text(boxTitle)
            HStack {
                Text("名稱：")
                    .frame(width: 50, alignment: .leading)
                TextField("魚名", text: $newStampName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer()
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
                Button("完成") {
                    self.alertIsPresented = false
                }
                .foregroundColor(Color(red: 1.0, green: 1.0, blue: 0.0))
                Spacer()
                Button("取消") {
                    self.alertIsPresented = false
                }
                .foregroundColor(Color(red: 1.0, green: 0.0, blue: 0.0))
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
            newStampPhoto: .constant(UIImage())
        )
    }
}
