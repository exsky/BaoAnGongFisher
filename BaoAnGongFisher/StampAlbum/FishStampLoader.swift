//
//  FishStampLoader.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/11/11.
//

import Foundation

// 製作一個 Loader 進行下列活動
// 1. 起初相簿是空的
// 2. 使用者從畫面中拍照及取名(回傳魚的名字和圖片) (AddStampAlert 按下 Done)
// 3. 將圖片存到指定路徑 (saveFishPic)
// 4. 將這張新照片同步到 Amplify Storage (AWS S3)
// 5. 從檔案讀入並產生郵票，加進畫面中
// 打開 APP 時
// 1. 起初相簿是空的
// 2. 打撈回魚圖稱號對應 txt
// 3. 根據稱號對應 txt 檢查圖鑑中的圖片使否已存在手機端
// 4. 若不存在，則下載魚圖(封面)
// 5. 從檔案讀入並產生郵票，加進畫面中
public class FishStampLoader {
    @Published var stampData = [Stamp]()
    private var originLoadData: Decodable?
    
    private func documentDir() -> String {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return dir[0] as String
    }
    
    func saveFishPic(fishName: String) -> Bool {
        // Create Dir
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return false
        }
        print(url.path)
        let newFolderUrl = url.appendingPathComponent("saved/pics")
        do {
            try manager.createDirectory(at: newFolderUrl, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
        // Create file
        let fileUrl = newFolderUrl.appendingPathComponent("NewSecretLocations.json")
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        // 需要做 error handling
//        do {
//            let jsonData = try jsonEncoder.encode(self.encodeCoordinate())
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                print(jsonString)
//                //try jsonData.write(to: myLocationFile)
//                manager.createFile(atPath: fileUrl.path,
//                                   contents: jsonData,
//                                   attributes: [FileAttributeKey.creationDate: Date()])
//            }
//        } catch {
//            print(error)
//        }
        return true
    }
    
    func loadStampData() {
        let manager = FileManager()
        let docDir = self.documentDir()
        let filePath = docDir.appendingFormat("/saved/NewSecretLocations.json")
        
        if manager.fileExists(atPath: filePath) { //  先前存檔過，就從存檔紀錄讀資料
            do {
                let data = try Data(contentsOf: URL(string: "file://\(filePath)")!)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([FishPinAnnotation].self, from: data)
                self.originLoadData = dataFromJson
            } catch {
                print(error)
            }
        } else {
            if let myLocationFile = Bundle.main.url(forResource: "MySecretLocations", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: myLocationFile)
                    let jsonDecoder = JSONDecoder()
                    let dataFromJson = try jsonDecoder.decode([FishPinAnnotation].self, from: data)
                    self.originLoadData = dataFromJson
                } catch {
                    print(error)
                }
            }
        }
    }
}
