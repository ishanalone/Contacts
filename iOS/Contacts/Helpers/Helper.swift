//
//  Helper.swift
//  
//
//  Created by Sushant Alone on 04/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//


import Foundation
import Alamofire

struct Helper {
    static func makeUrlWithParameters(_ parameters :Parameters) -> String {
        do {
                              
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let dictFromJSON = decoded as? [String:String] {
            print(dictFromJSON)
            let jsonString = dictFromJSON.reduce("") { "\($0)\($1.0)=\($1.1)&" }
                return jsonString
            } else {
                return ""
            }
                              
        } catch {
            return ""
        }
    }
    
    static func makeHttpBodyWithParameters(_ parameters:Parameters) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return jsonData
        } catch {
            return nil
        }
    }
    
    static func loadJson(filename fileName: String) -> [String:Any]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
               let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                          print(jsonResult)
                    return jsonResult
                }

            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
