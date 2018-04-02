//
//  Bookmark.swift
//  Bookmarks REST Client
//
//  Created by Brook Li on 3/29/18.
//  Copyright © 2018 Brook Li. All rights reserved.
//

struct Bookmark {
    var id: Int
    var uri: String
    var description: String
    init(id: Int, uri: String, description: String){
        self.id = id
        self.uri = uri
        self.description = description
    }
    init?(json: [String: Any]){
        guard let id = json["id"] as? Int,
            let uri = json["uri"] as? String,
            let description = json["description"] as? String else{
                return nil
        }
        self.id = id
        self.uri = uri
        self.description = description
    }
}
