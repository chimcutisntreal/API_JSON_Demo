//
//  HolidayData.swift
//  API_JSON_Demo
//
//  Created by Chinh on 10/8/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import Foundation

struct HolidayResponse: Decodable {
    var response:Holidays
}

struct Holidays: Decodable {
    var holidays:[HolidayDetail]
}

struct HolidayDetail: Decodable {
    var name:String
    var date:DateInfo
}

struct DateInfo: Decodable {
    var iso:String
}
