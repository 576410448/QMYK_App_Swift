//
//  FishListController.swift
//  QMYK_App_Swift
//
//  Created by shenj on 2018/10/15.
//  Copyright © 2018 aNever.all. All rights reserved.
//

import UIKit

public let fishListTableView_Width:CGFloat = UIScreen.main.bounds.width*3/4
public let fishListTableView_Header_Height:CGFloat = 150.0

private let myFishLishKey:String = "myFishLishKey"

//MARK:- FishListHeader
class FishListHeader:UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.uiConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func uiConfig() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: fishListTableView_Width, height: fishListTableView_Header_Height))
        label.font = UIFont(name: "Chalkduster", size: 50)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.text = "商城"
        self.addSubview(label)
    }
}

//MARK:- FishListFooter
class FishListFooter:UITableViewHeaderFooterView {
    
}

//MARK:- FishListController
class FishListController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    var fishListArray:NSMutableArray!
    var tableView:UITableView!
    var addFishBlock:((FishModel)->())?
    var fishArray:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backColor
        
        self.prepareData()
        self.uiConfig()
        
        if #available(iOS 11.0, *){
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    private func prepareData() {
        
        fishListArray = NSMutableArray()
        
        let fishDicArray:Array<Data>? = UserDefaults.standard.object(forKey: myFishLishKey) as? Array<Data>

        if fishDicArray == nil {
            for i in 1...60 {
                let model = FishManager.getFish(level: i)
                fishListArray.add(model)
            }
        } else {
            for i in 0...fishDicArray!.count-1 {
                let data:Data = fishDicArray![i]
                guard let model = try? JSONDecoder().decode(FishModel.self, from: data) else {
                    return
                }
                fishListArray.add(model)
            }
        }
    }
    
    private func saveLocalData() {
        let mutableArray = NSMutableArray()
        
        for i in 0...fishListArray.count-1 {
            
            let model:FishModel = fishListArray![i] as! FishModel
            
            if let data = try? JSONEncoder().encode(model) {
                mutableArray.add(data)
            } else {
                print("archived false")
            }
        }
        
        UserDefaults.standard.set(mutableArray, forKey: myFishLishKey)
        UserDefaults.standard.synchronize()
    }
    
    private func uiConfig() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: fishListTableView_Width, height: screenH), style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = backColor
        view.addSubview(tableView)
        
        tableView.register(FishListCell.self, forCellReuseIdentifier: NSStringFromClass(FishListCell.self))
        tableView.register(FishListHeader.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(FishListHeader.self))
        tableView.register(FishListFooter.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(FishListFooter.self))
    }
    
    //MARK:- tableview D
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fishListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model:FishModel = fishListArray[indexPath.row] as! FishModel
        
        let cell:FishListCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FishListCell.self)) as! FishListCell
        
        weak var weakSelf = self
        cell.priceBtnBlock = { (model)->() in
            
            let arr = NSMutableArray() // 有效鱼
            
            for fishModel in weakSelf!.fishArray! {
                if !(fishModel as! FishModel).isPlaceholder {
                    arr.add(fishModel)
                }
            }
            
            if arr.count >= 12 { // 判断 有效鱼数量
                self.alert(message:"鱼池已满")
                return
            }
            
            let newModel = FishManager.getFish(level: model.level!)
            let inc:Double = Double(1.07 + CGFloat(model.level!) * 0.011/4)
            newModel.curPrice = Int64(Double(model.curPrice!) * inc)
            self.fishListArray.replaceObject(at: indexPath.row, with: newModel)
            
            model.curPrice = Int64(Double(model.curPrice!) * inc)
//            self.fishListArray.replaceObject(at: indexPath.row, with: model)
            weakSelf!.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            self.saveLocalData()
            
            for i in 0...weakSelf!.fishArray!.count {
                let fishModel:FishModel = weakSelf!.fishArray![i] as! FishModel
                if fishModel.isPlaceholder {
                    weakSelf!.fishArray?.replaceObject(at: i, with: model) // 修改数据源
                    break
                }
            }
            
            if weakSelf!.addFishBlock != nil {
                weakSelf!.addFishBlock!(model)
            }
            
        }
        cell.model = model
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(FishListHeader.self))
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(FishListFooter.self))
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return fishListTableView_Header_Height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
        
    //MARK:- ACTION
    private func alert(message:String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}
