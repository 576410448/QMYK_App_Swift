//
//  FishModel.swift
//  QMYK_App_Swift
//
//  Created by shenj on 2018/10/15.
//  Copyright © 2018 aNever.all. All rights reserved.
//

import UIKit

class FishModel: NSObject,Codable {
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(isPlaceholder, forKey: "isPlaceholder")
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(image, forKey: "image")
//        aCoder.encode(level, forKey: "level")
//        aCoder.encode(staPrice, forKey: "staPrice")
//        aCoder.encode(curPrice, forKey: "curPrice")
//        aCoder.encode(makePrice, forKey: "makePrice")
//        aCoder.encode(isWorking, forKey: "isWorking")
//        aCoder.encode(touchSpeUp, forKey: "touchSpeUp")
//        aCoder.encode(animaTimeInterval, forKey: "animaTimeInterval")
//
//
//    }
//
//    override init() {
//        super.init()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init()
//        isPlaceholder = aDecoder.decodeBool(forKey: "isPlaceholder")
//        name = (aDecoder.decodeObject(forKey: "name") as! String)
//        image = (aDecoder.decodeObject(forKey: "image") as! String)
//        level = aDecoder.decodeInteger(forKey: "level")
//        staPrice = aDecoder.decodeInteger(forKey: "staPrice")
//        curPrice = aDecoder.decodeInteger(forKey: "curPrice")
//        makePrice = aDecoder.decodeInteger(forKey: "makePrice")
//        isWorking = aDecoder.decodeBool(forKey: "isWorking")
//        touchSpeUp = aDecoder.decodeBool(forKey: "touchSpeUp")
//        animaTimeInterval = (aDecoder.decodeObject(forKey: "animaTimeInterval") as! CFTimeInterval)
//    }
    
    
    var isPlaceholder:Bool = false
    var name:String?
    var image:String?
    var level:Int?
    var staPrice:Int64?
    var curPrice:Int64?
    var makePrice:Double?
    var isWorking:Bool = false
    var touchSpeUp:Bool = false  // 通过点击加速  单次加速
    var animaTimeInterval:CFTimeInterval? // 游玩一圈的时间
    
    
//    static var user: FishModel {
//
//        let ud = UserDefaults.standard
//        guard let data = ud.data(forKey: "lqUser_savedData") else {
//            // 如果获取失败则重新创建一个返回
//            return FishModel()
//        }
//
//        guard let us = try? JSONDecoder().decode(self, from: data) else {
//            return FishModel()
//        }
//
//        return us
//    }
    
    override init() {
        super.init()
    }
    
//    func saved() {
//        
//        if let data = try? JSONEncoder().encode(self) {
//            
//            let us = UserDefaults.standard
//            
//            us.set(data, forKey: "lqUser_savedData")
//            us.synchronize()
//        }
//    }
    
    
}
