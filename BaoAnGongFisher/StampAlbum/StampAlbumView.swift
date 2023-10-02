//
//  StampAlbumView.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/10/9.
//

import SwiftUI
import Amplify

struct StampAlbumView: View {
    @State private var stamps:[Stamp] = []
    @State private var addStampAlertIsPresented: Bool = false
    @State private var addStampName: String = ""
    @State private var photoSource: PhotoSource?
    @State private var newStampPhoto: UIImage = UIImage()
    @State private var uploadFilenameQueue: [URL] = []
    @State private var userAttr: [String:String] = [:]
    @State var statusText: String = ""

    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 130))
    ]
    
    init () {
        let localPicsInfo = scanLocalStamp()
        let localStamp = generateStamps(info:localPicsInfo)
        _stamps = State(initialValue: localStamp)
    }

    var body: some View {
        NavigationView{
            ZStack(alignment: .center) {
                ScrollView{
                    LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                        ForEach(Array(zip(stamps.indices, stamps)), id: \.0) { index, stamp in
                            ZStack{
                                FishStampView(
                                    imgName: stamp.imgName, fishName: stamp.fishName,
                                    counted: stamp.counted, number: index+1
                                )
                            }
                        }
                    }
                } // end of scroll view
                .navigationBarTitle("集郵冊")
                .navigationBarItems(
                    trailing:
                        HStack {
                            //Text(statusText)
                            TextField("statusBar", text: $statusText)
                            Button(action: {
                                Task {
                                    await fetchStamp()
                                }
                            }) {
                                Label("Fetch", systemImage: "tray.and.arrow.down.fill")
                            }
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
            let fishDirUrl = picUrl.deletingLastPathComponent()
            let fishDirName = fishDirUrl.lastPathComponent
            print("Upload -- \(fileNameKey)")
            let uploadTask = Amplify.Storage.uploadFile(
                key: "\(username)/\(fishDirName)/\(fileNameKey)",
                local: picUrl
            )
            Task {
                for await progress in await uploadTask.progress {
                    print("Progress: \(progress)")
                    self.statusText = progress.description
                }
            }
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

    func fetchStamp() async {
        print("Fetch Amplify S3 Fish dir")
        let attrs = await fetchUserAttr()
        let username = attrs["name"] ?? "guest"
        var toBeDownloadedList:[String] = []

        // Base Dir
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        do {
            let options = StorageListRequest.Options(path:username, pageSize: 1000)
            let listResult = try await Amplify.Storage.list(options: options)
            listResult.items.forEach { item in
                print("Key: \(item.key)")
                toBeDownloadedList.append(item.key)
                // Key: email/生魚片/20230930161239.png
            }
        } catch {
            print("failed to fetch s3 file key")
        }
        print("==============")
        for picKey in toBeDownloadedList {
            print(picKey)
            let pathSplit = picKey.split(separator: ["/"])
            let localFileUrl = url.appendingPathComponent("saved/pics/\(pathSplit[1])/\(pathSplit[2])")
            // Create fish dir
            let localFishDir = url.appendingPathComponent("saved/pics/\(pathSplit[1])")
            do {
                try manager.createDirectory(at: localFishDir, withIntermediateDirectories: true)
            } catch {
                print(error)
            }
            // Start download
            let downloadTask = Amplify.Storage.downloadFile(
                key: picKey,
                local: localFileUrl,
                options: nil
            )
            Task {
                for await progress in await downloadTask.progress {
                    // print("Progress: \(progress)")
                    self.statusText = progress.description
                }
            }
            do {
                try await downloadTask.value
                print("Completed: \(picKey)")
                print("Local: "+"/saved/pics/\(pathSplit[1])/\(pathSplit[2])")
                stamps.append(Stamp(imgName: "/saved/pics/\(pathSplit[1])/\(pathSplit[2])",
                                     fishName: String(pathSplit[1]),
                                     counted: 1)  // TODO: 辨別同名魚是否出現過
                )
            } catch {
                print("failed to download")
            }
        }
    }

    func documentDir() -> String {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return dir[0] as String
    }

    func generateStamps(info: [String: Any]) -> [Stamp] {
        var localStampPics:[Stamp] = []
        for fish in info {
            if let details = info[fish.key]! as? [String:Any] {
                //print(details["cover"]!)
                localStampPics.append(
                    Stamp(imgName: details["cover"]! as! String,
                          fishName: fish.key, counted: details["count"]! as! Int)
                )
            }
        }
        return localStampPics
    }

    func scanLocalStamp() -> [String:Any] {  // Return first img as stamp cover
        //var localStampPics:[Stamp] = []
        var localStampInfo:[String:Any] = [:]
        let manager = FileManager.default
        let docDir = self.documentDir()
        let dirPath = docDir.appendingFormat("/saved/pics")
        let contentsOfDirectory = try? manager.contentsOfDirectory(atPath: dirPath)
        if contentsOfDirectory != nil {
            let fishes:[String] = contentsOfDirectory!
            // print(fishes)  // 所有在手機裡裡面的魚名字
            for fish in fishes {
                // 目錄裡的魚照片
                let fishDirPath = dirPath.appendingFormat("/\(fish)")
                let picOfFish = try? manager.contentsOfDirectory(atPath: fishDirPath)
                if picOfFish != nil {
                    let pics:[String] = picOfFish!
                    localStampInfo[fish] = [
                        "cover": "/saved/pics/\(fish)/\(pics[0])",
                        "count": pics.count
                    ] as [String : Any]
                }
            }
        } else {
            print("empty dir")
        }
        //return localStampPics
    return localStampInfo
    }
}

struct StampAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        StampAlbumView()
    }
}
