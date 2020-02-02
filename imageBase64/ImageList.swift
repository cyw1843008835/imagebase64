//
//  ImageList.swift
//  imageBase64Tests
//
//  Created by yw c on 2020/02/02.
//  Copyright © 2020 yw c. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ImageList: ObservableObject {
    @Published var imagelist: [ImageList] = []
    
    
    init() {
        load()
        
    }
    
    func load() {
        let url = URL(string: "http://192.168.10.7:3000/savephoto?id=eq.1")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.imagelist = try! JSONDecoder().decode([ImageList].self, from: data!)
            }
        }.resume()
        
    }
    
    struct ImageList: Decodable,Hashable,Identifiable {
        
        var id: Int
        var base64String: String
    }
    
}
