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
    @State private var addStampAlertIsPresented: Bool = false
    @State private var addStampName: String = ""
    @State private var photoSource: PhotoSource?
    @State private var newStampPhoto: UIImage = UIImage()
    @State private var uploadFilenameQueue: [URL] = []
    @State private var userAttr: [String:String] = [:]

    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 130))
    ]
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .center) {
                ScrollView{
                    LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                        ForEach(Array(zip(stamps.indices, stamps)), id: \.0) { index, stamp in
                            ZStack{
                                // Stamp here
                                FishStampView(
                                    imgName: stamp.imgName, fishName: stamp.fishName,
                                    catched: stamp.catched, counted: stamp.counted, number: index+1
                                )
                            }
                        }
                        //StampSync()
                    }
                } // end of scroll view
                .navigationBarTitle("集郵冊")
                .navigationBarItems(
                    trailing:
                        HStack {
                            Button(action: {
                                Task {
                                    await uploadStamp()
                                }
                            }) {
                                Label("Sync", systemImage: "arrow.up.right.and.arrow.down.left.rectangle.fill")
                                //Text("Sync")
                            }
                            Button(action: createStamp) {
                                Label("", systemImage: "plus.rectangle.on.folder.fill")
                                .onTapGesture {
                                    self.addStampAlertIsPresented.toggle()
                                }
                            }
                        }
                )
                // The box for insert new stamp
                AddStampAlert(alertIsPresented: $addStampAlertIsPresented,
                              newStampName: $addStampName,
                              newStampPhoto: $newStampPhoto,
                              wholeStamps: $stamps,
                              fileQueue: $uploadFilenameQueue
                )
            } // end of zstack
            
        }
    }

    func fetchUserAttr() async -> [String:String] {
        var userAttr: [String:String] = [:]
        do {
            let curAuthMsg = try await Amplify.Auth.fetchUserAttributes()
            for attr in curAuthMsg {
                userAttr[attr.key.rawValue] = attr.value
            }
        } catch {
            print("Failed to fetch user attributes")
        }
        return userAttr
    }

    func createStamp() {    // Let AddStampAlert show or hide
        print("Press AddStampAlert Button")
    }

    func uploadStamp() async {
        print("Sync local pic -> Amplify S3")
        let attrs = await fetchUserAttr()
        let username = attrs["name"] ?? "guest"
        for picUrl in uploadFilenameQueue {
            let fileNameKey = picUrl.lastPathComponent
            print("Upload -- \(fileNameKey)")
            let uploadTask = Amplify.Storage.uploadFile(
                key: "\(username)/\(fileNameKey)",
                local: picUrl
            )
            //Task {
            //    for await progress in await uploadTask.progress {
            //        print("Progress: \(progress)")
            //    }
            //}
            do {
                let data = try await uploadTask.value
                print("Completed: \(data)")
            } catch {
                print("Couldn't upload file: \(picUrl)")
            }
        }
        print("Clean queue")
        uploadFilenameQueue.removeAll()
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
            let imageExists: Bool = UIImage(named: fishName) != nil
            if imageExists {
                //let _ = print("從 Assets 拿圖片")
                Image("\(fishName)")
                    .resizable()
                    .frame(width: 80, height: 80)
            } else {
                //let _ = print("從手機端的檔案引用圖片")
                let img = loadStampImageByName(fishname: fishName)
                Image(uiImage: img)
                    .resizable()
                    .frame(width: 80, height: 80)
            }
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

    func documentDir() -> String {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return dir[0] as String
    }

    func loadStampImageByName(fishname: String) -> UIImage {
        let manager = FileManager()
        let docDir = self.documentDir()
        let filePath = docDir.appendingFormat("/saved/\(fishname).png")
        //let fileUrl = NSURL(fileURLWithPath: filePath).absoluteString!
        //let path = fileUrl.replacingOccurrences(of: "file://", with: "")

        if manager.fileExists(atPath: filePath) {
            let img = UIImage(contentsOfFile: filePath)
            //print("load 1: \(filePath)")
            return img!
        } else {
            print("no \(fishname).png found")
            //var hola = manager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
            //hola = hola.appendingPathComponent("saved")
            //let yale = try? manager.contentsOfDirectory(atPath:hola)
            //print(yale)
            return UIImage()
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
}
