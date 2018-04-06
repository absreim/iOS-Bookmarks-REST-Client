//
//  OutgoingBookmark.swift
//  Bookmarks REST Client
//
//  Created by Brook Li on 4/4/18.
//  Copyright © 2018 Brook Li. All rights reserved.
//

struct OutgoingBookmark: Codable{
    var uri: String
    var description: String
    init(uri: String, description: String){
        self.uri = uri
        self.description = description
    }
}
