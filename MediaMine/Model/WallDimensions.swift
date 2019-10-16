//
//  WallDimensions.swift
//  MediaMine
//
//  Created by Christopher Chu on 9/11/19.
//  Copyright © 2019 NoOrg. All rights reserved.
//

import Foundation


class OurWall{
    var length : String
    var width : String
    var total : String
    var gallons : String
    
    init(length: String, width: String, total: String, gallons: String){
        self.length = length
        self.width = width
        self.total = total
        self.gallons = gallons
    }
}
