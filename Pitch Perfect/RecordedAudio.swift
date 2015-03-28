//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by ANDREW SMITH on 23/03/2015.
//  Copyright (c) 2015 Robot Loves You. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL
    var title: String
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
