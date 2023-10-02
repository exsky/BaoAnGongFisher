//
//  FishStampView.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2023/10/2.
//

import SwiftUI

// 郵票
struct FishStampView: View {
    // 先定義好要接收的參數名稱與類型
    var imgName: String // TODO: change the src to amplify
    var fishName: String
    //var catched: Int
    var counted: Int
    var number: Int // The fish serial number
    private let colors: [Color] = [
        .red, .blue, .green, .yellow, .pink, .cyan, .indigo]

    var body: some View {
        Rectangle()  // 底部是個方塊 .frame(width: 150, height: 200)
            .frame(width: 180, height: 250)
            .foregroundColor(colors[number%7])
            .cornerRadius(10)
        VStack{  // 中間放一層 垂直堆 // A stamp
            HStack{
                //Text("\(catched)/\(counted)")
                Text("數量：\(counted)")
                    .padding()
                    .font(.footnote)
                Spacer()
                Text("\(number)")
                    .frame(width: 15, height: 15, alignment: .center)
                    .font(.footnote)
                    .fontWeight(.bold)
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
            .padding(2)
            Text("**\(fishName)**")
            //let _ = print("Round - \(fishName)")
            let imageExists: Bool = UIImage(named: fishName) != nil
            if imageExists {
                let _ = print("從 Assets 拿圖片 - \(fishName)")
                Image("\(fishName)")
                    .resizable()
                    .frame(width: 80, height: 80)
            } else {
                let _ = print("從手機端的檔案引用圖片 - \(fishName)")
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
        let dirPath = docDir.appendingFormat("/saved/pics/\(fishname)/")
        let contentsOfDirectory = try? manager.contentsOfDirectory(atPath: dirPath)
        if contentsOfDirectory != nil {
            let firstFile:String! = contentsOfDirectory![0]
            let filePath = dirPath.appendingFormat(firstFile)
            if manager.fileExists(atPath: filePath) {
                let img = UIImage(contentsOfFile: filePath)
                return img!
            } else {
                print("no \(fishname).png found")
                return UIImage()
            }
        } else {
            print("empty dir")
        }
        return UIImage()
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

struct FishStampView_Previews: PreviewProvider {
    static var previews: some View {
        //FishStampView(imgName: "石狗公", fishName: "石狗公", catched: 5, counted: 8, number: 10)
        FishStampView(imgName: "石狗公", fishName: "石狗公", counted: 8, number: 10)
    }
}
