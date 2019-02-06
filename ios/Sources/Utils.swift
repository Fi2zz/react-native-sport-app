//
//  Utils.swift
//  StepCounterApp
//
//  Created by Fitz on 2019/2/3.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation

import CoreLocation


struct AppJSON: Decodable {

    var name: String
    var displayName: String

}
func noopDispatcher(name:String,payload:Any?)->Void{}

func stringListToStringMap(list: [String]) -> [String: String] {
    var map = [String: String]()
    for item in list {
        map[item] = item;
    }
    return map;

}


func stringMapToStringList(map: [String: String]) -> [String] {
    var list: [String] = [];
    for (key, _) in map {
        list.append(key)
    }
    return list;

}


func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter();
    dateFormatter.dateFormat = "yyyy/MM/dd, hh:mm a zz";
    return dateFormatter.string(from: date)
}


func ReadAppJSON(filepath: String) -> AppJSON? {

    if let path = Bundle.main.url(forResource: filepath, withExtension: "json") {
        let data = try? Data(contentsOf: path, options: .mappedIfSafe)
        let decoder = JSONDecoder()
        let jsonData = try? decoder.decode(AppJSON.self, from: data!)

        return jsonData!;
    } else {
        print("read app.json with error")
        return nil
    }


}


