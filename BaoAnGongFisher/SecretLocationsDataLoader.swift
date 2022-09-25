//
//  SecretLocationsDataLoader.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/9/24.
//

import Foundation
import CoreLocation

public class LocationsLoader {

    @Published var originLoadData = [FishPinAnnotation]()
    @Published var locationData = [PinLocation]()

    init() {
        loadDataFromFile()
        transferCoordinate()
    }

    func loadDataFromFile() {

        if let myLocationFile = Bundle.main.url(forResource: "MySecretLocations", withExtension: "json") {

            // 如果上面的 if let statement 不成立則不執行
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
}

struct FishPinAnnotation: Hashable, Codable{
//    private let id = UUID()
    var name: String
    var image: String
    var latitude: Double
    var longitude: Double
    var rank: Int
}
