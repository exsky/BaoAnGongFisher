//
//  SecretLocationsDataLoader.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/9/24.
//

import Amplify
import Foundation
import CoreLocation

public class LocationLoader {

    @Published var originLoadData = [FishPinAnnotation]()
    @Published var locationData = [PinLocation]()

    init() {
        loadDataFromFile()
        transferCoordinate()
        loadDataFromAmplify()
    }

    private func documentDir() -> String {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return dir[0] as String
    }

    func loadDataFromAmplify() {
        print("LOAD ~ FROM ~ AMPLIFY")
        do {
            Amplify.DataStore.query(FishingSpot.self) { result in
                switch result {
                case .success(let spots):
                    for spot in spots {
                        print(spot)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func loadDataFromFile() {
        print("LOAD ~ FROM ~ FILE")
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

    // 將 FishPinAnnotation 轉換後加入 locationData
    // 為了讀入檔案所製作
    func transferCoordinate() {    // 將目前程式使用中的圖釘清單內新增轉換後的資料
        for pin in self.originLoadData {
            self.locationData.append(
                PinLocation(
                    name: pin.name,
                    image: pin.image,
                    coordinate: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude),
                    rank: pin.rank)
            )
        }
    }
    
    // 以 locationData 生成新的 [FishPinAnnotation]
    // 這是為了提供給寫檔案時使用
    func encodeCoordinate() -> [FishPinAnnotation] {
        var retPins: [FishPinAnnotation] = []
        for pin in self.locationData {
            retPins.append(
                FishPinAnnotation(
                    name: pin.name,
                    image: pin.image,
                    latitude: pin.coordinate.latitude,
                    longitude: pin.coordinate.longitude,
                    rank: pin.rank)
            )
        }
        return retPins
    }

    func saveDataToFile() {
        // Create Dir
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        print(url.path)
        let newFolderUrl = url.appendingPathComponent("saved")
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
        do {
            let jsonData = try jsonEncoder.encode(self.encodeCoordinate())
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                //try jsonData.write(to: myLocationFile)
                manager.createFile(atPath: fileUrl.path,
                                   contents: jsonData,
                                   attributes: [FileAttributeKey.creationDate: Date()])
            }
        } catch {
            print(error)
        }
    }
    
    func copyFileFromBundleToDocumentsFolder(sourceFile: String, destinationFile: String = "") {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        if let documentsURL = documentsURL {
            let sourceURL = Bundle.main.bundleURL.appendingPathComponent(sourceFile)

            // Use the same filename if destination filename is not specified
            let destURL = documentsURL.appendingPathComponent(!destinationFile.isEmpty ? destinationFile : sourceFile)

            do {
                try FileManager.default.removeItem(at: destURL)
                print("Removed existing file at destination")
            } catch (let error) {
                print(error)
            }

            do {
                try FileManager.default.copyItem(at: sourceURL, to: destURL)
                print("\(sourceFile) was copied successfully.")
            } catch (let error) {
                print(error)
            }
        }
    }

    func getLocations () -> [PinLocation] {
        return self.locationData
    }
    
    func saveAndReloadLocation() {
        self.saveDataToFile()
        self.loadDataFromFile()
    }
}
