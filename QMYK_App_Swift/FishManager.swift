//
//  FishManager.swift
//  QMYK_App_Swift
//
//  Created by shenj on 2018/10/23.
//  Copyright © 2018 aNever.all. All rights reserved.
//

import UIKit

public let myGlodKey:String = "myGlodKey"
public let myFishArrayKey:String = "myFishArrayKey"
public let workStop_TimeKey:String = "workStopTimeKey"
public let workStop_MakeMoney_InSecondKey:String = "workStop_MakeMoney_InSecondKey"


class FishManager: NSObject {

    /*
     获取占位空model鱼
     */
    class func getPlaceholderFish() -> (FishModel) {
        let model:FishModel! = FishModel()
        model.isPlaceholder = true
        return model
    }
    
    /*
     创建对应等级鱼
     */
    class func getFish(level:Int) ->(FishModel) {
        let model:FishModel! = FishModel()
        model.name = "鲲"+String(level)+"号"
        model.image = "mermaid"
        model.level = level
        let intPrice = level*level*100
        model.staPrice = Int64(intPrice)
        model.curPrice = Int64(intPrice)
        let mp:Float = 25 * powf(2, Float(level-1))
        let mpStr = String(format: "%.f", mp)
        model.makePrice = Double(mpStr)
        model.isPlaceholder = false
        model.animaTimeInterval = 7-Double(level)*0.05
        
        return model
    }
    
    /*
     存结束时 总金钱数
     */
    class func saveGlod(glod:Int) {
        UserDefaults.standard.set(glod, forKey: myGlodKey)
        UserDefaults.standard.synchronize()
    }
    
    /*
     取上次结束时 总金钱数
     */
    class func getLastGlod() ->(Int) {
        let glod:Int = UserDefaults.standard.object(forKey: myGlodKey) as! Int
        return glod
    }
    
    /*
     存结束时间
     */
    class func saveStopTime() {
        let time:Date = Date()
        print(time)
        
        UserDefaults.standard.set(time, forKey: workStop_TimeKey)
        UserDefaults.standard.synchronize()
    }
    
    /*
     取上次结束时间
     */
    
    class func getLastStopTime()->(Date) {
        let time:Date = UserDefaults.standard.object(forKey: workStop_TimeKey) as! Date
        return time
    }
    
    /*
     存离线后 每秒赚钱数
     */
    class func saveOfflineMakeMoney_EvenySecond(money:Int) {
        UserDefaults.standard.set(money, forKey: workStop_MakeMoney_InSecondKey)
        UserDefaults.standard.synchronize()
    }
    
    /*
     获取离线期间 每秒赚钱数
     */
    class func getOfflineMakeMoney_EverySecond()->(Int) {
        let everySecond_makeMoney:Int = UserDefaults.standard.object(forKey: workStop_MakeMoney_InSecondKey) as! Int
        return everySecond_makeMoney
    }
    
    /*
     反序列化model数组
     */
    class func getFishs()->(NSMutableArray) {
        let fishDicArray:Array<Data>? = UserDefaults.standard.object(forKey: myFishArrayKey) as? Array<Data>
        let mutableArray = NSMutableArray()

        if fishDicArray == nil {
            for _ in 0...11 {
                let model:FishModel =  FishManager.getPlaceholderFish()
                mutableArray.add(model)
            }

        } else {
            for i in 0...fishDicArray!.count-1 {
                let data:Data = fishDicArray![i]
                guard let model = try? JSONDecoder().decode(FishModel.self, from: data) else {
                    return mutableArray
                }
                
                mutableArray.add(model)
                
            }
        }
        
        return mutableArray
        
    }
    
    /*
    序列化model数组
    */
    class func saveLocalFishs(fishs:Array<FishModel>) {
        
        let mutableArray = NSMutableArray()
        
        for i in 0...fishs.count-1 {
            
            
            let model:FishModel = fishs[i]
            
            if let data = try? JSONEncoder().encode(model) {
                mutableArray.add(data)
            } else {
                print("archived false")
            }
            
//            let data:Data!
//
//            do {
//                try data = NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
//            } catch {
//                data = Data()
//                print("archived false")
//            }
//            mutableArray.add(data)
        }
        
        UserDefaults.standard.set(mutableArray, forKey: myFishArrayKey)
        UserDefaults.standard.synchronize()
        
    }
    
}
