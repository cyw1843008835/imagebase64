//
//  ContentView.swift
//  imageBase64
//
//  Created by yw c on 2020/02/01.
//  Copyright © 2020 yw c. All rights reserved.
//

import SwiftUI

struct ContentView: View {
 
        @State private var rect: CGRect = .zero
        @State var uiImage: UIImage? = nil
        @ObservedObject var store = StringList()
    
        var body: some View {
            VStack {
                VStack {
                   // Image(systemName: "sun.haze")
                    Image("111111")
                        .font(.title)
                        .foregroundColor(.white)
                    .background(RectangleGetter(rect: $rect))
                  
                    Text("Hello, World!")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                
                .onAppear() {
                    
                }
                
                Button(action: {
                    self.uiImage = UIApplication.shared.windows[0].rootViewController?.view!.getImage(rect: self.rect)
                    if self.uiImage != nil{
                      //  print(convertImageToBase64(image:  self.uiImage!) as Any)
                        post(id:"1",image:convertImageToBase64(image:  self.uiImage!) as Any as! String)
                    }
                    
                }) {
                    Text("Button")
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .cornerRadius(8)
                    
                }
                Button(action: {
//                    ForEach(0 ..< self.store.imagelist.count ,id: \.self){
//                        print(self.store.imagelist[$0].image)
                    print(load())
//
//                                               }
                }) {
                    Text("Button2")
                }
                List(store.imagelist) { post in
                               Text(String(post.id))
                                }
//                if uiImage != nil {
//                    VStack {
//                        Image(uiImage: self.uiImage!)
//                    }.background(Color.green)
//                        .frame(width: 500, height: 500)
//                }
            }
        }
    }

    struct RectangleGetter: View {
        @Binding var rect: CGRect
        
        var body: some View {
            GeometryReader { geometry in
                self.createView(proxy: geometry)
            }
        }
        
        func createView(proxy: GeometryProxy) -> some View {
            DispatchQueue.main.async {
                self.rect = proxy.frame(in: .global)
            }
            return Rectangle().fill(Color.clear)
        }
    }

    extension UIView {
        func getImage(rect: CGRect) -> UIImage {
            let renderer = UIGraphicsImageRenderer(bounds: rect)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        }
    }

   
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
func convertImageToBase64(image: UIImage) -> String? {
      let imageData = image.jpegData(compressionQuality: 1)
      return imageData?.base64EncodedString(options:
      Data.Base64EncodingOptions.lineLength64Characters)
     }

func post(id:String,image:String){
        let url = URL(string: "http://192.168.3.3:3000/savephoto")
        var request = URLRequest(url: url!)
        // POSTを指定
        request.httpMethod = "POST"
        // POSTするデータをBodyとして設定
        let urlstr = "id=" + id + "&image=" + image
//        request.httpBody = "userid=666666&username=true&distcode=8888".data(using: .utf8)
        request.httpBody = urlstr.data(using: .utf8)!
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                // HTTPヘッダの取得
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                // HTTPステータスコード
                print("statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }
func convertBase64ToImage(imageString: String) -> UIImage {
    let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
    return UIImage(data: imageData)!
}
func load() ->String{
   var str: String = ""
    let url = URL(string: "http://192.168.3.3:3000/savephoto?id=eq.1")!
    URLSession.shared.dataTask(with: url) { data, response, error in
        DispatchQueue.main.async {
           str = try! JSONDecoder().decode(String.self, from: data!)
        }
    }.resume()
    return str
}
