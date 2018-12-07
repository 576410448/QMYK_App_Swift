//
//  FishListCell.swift
//  QMYK_App_Swift
//
//  Created by shenj on 2018/10/15.
//  Copyright © 2018 aNever.all. All rights reserved.
//

import UIKit

class FishListCell: UITableViewCell {
    
    var priceBtnBlock:((FishModel) ->())?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.uiConfig()
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var levelLab:UILabel!
    var fishImgv:UIImageView!
    var priceBtn:UIButton!
    
    private func uiConfig() {
        
        fishImgv = UIImageView(frame: CGRect(x: 20, y: 20, width: 60, height: 60))
        fishImgv.layer.cornerRadius = 30
        fishImgv.clipsToBounds = true
        fishImgv.contentMode = UIView.ContentMode.scaleAspectFit
        contentView.addSubview(fishImgv)
        
        levelLab = UILabel(frame: CGRect(x: 5, y: 65, width: 30, height: 30))
        levelLab.layer.cornerRadius = 15
        levelLab.clipsToBounds = true
        levelLab.textAlignment = NSTextAlignment.center
        levelLab.textColor = UIColor.black
        levelLab.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        contentView.addSubview(levelLab)
        
        priceBtn = UIButton(type: UIButton.ButtonType.custom)
        priceBtn.frame = CGRect(x: fishListTableView_Width-130, y: 30, width: 110, height: 40)
        priceBtn.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        priceBtn.layer.borderWidth = 2
        priceBtn.addTarget(self, action: #selector(priceBtnAction), for: UIControl.Event.touchUpInside)
        contentView.addSubview(priceBtn)
        
    }
    
    var _model:FishModel?
    var model:FishModel? {
        set {
            _model = newValue
            self.assignment()
        }
        get {
            return _model
        }
    }
    
    private func assignment() {
        fishImgv.image = UIImage(named: (model?.image)!)
        levelLab.text = String((model?.level)!)
        let price:String = String((model?.curPrice)!)
        priceBtn.setTitle(price, for: UIControl.State.normal)
    }

    @objc private func priceBtnAction() {
        if priceBtnBlock != nil {
            priceBtnBlock!(model!)
        }
    }
}
