//
//  KunCell.swift
//  QMYK_App_Swift
//
//  Created by shenj on 2018/10/15.
//  Copyright © 2018 aNever.all. All rights reserved.
//

import UIKit

class KunCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.uiConfig()
        self.layer.borderWidth = 0.5
        self.clipsToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var fishImgv:UIImageView!
    var levelLab:UILabel!
    var cancelImgv:UIImageView!
    
    private func uiConfig() {
        
        fishImgv = UIImageView(frame: CGRect(x: -1, y: -1, width: frame.size.width+2, height: frame.size.height+2))
        fishImgv.isUserInteractionEnabled = true
        fishImgv.contentMode = UIView.ContentMode.scaleAspectFill
        contentView.addSubview(fishImgv)
        
        levelLab = UILabel(frame: CGRect(x: -3, y: frame.size.height-12, width: 15, height: 15))
        levelLab.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        levelLab.textColor = UIColor.white
        levelLab.font = UIFont(name: "Chalkduster", size: 9)
        levelLab.layer.cornerRadius = 7.5
        levelLab.clipsToBounds = true
        levelLab.textAlignment = NSTextAlignment.center
        contentView.addSubview(levelLab)
        
        cancelImgv = UIImageView(frame: CGRect(x: frame.size.width-16, y: frame.size.height-16, width: 16, height: 16))
        cancelImgv.isHidden = true
        cancelImgv.backgroundColor = UIColor.black
        contentView.addSubview(cancelImgv)
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
        
        if model == nil ||
            model?.isPlaceholder == true {
            fishImgv.image = nil
            levelLab.text = nil
            
            fishImgv.isHidden = true
            levelLab.isHidden = true
            cancelImgv.isHidden = true
        }else {
            fishImgv.image = UIImage(named: model?.image! as! String)
            levelLab.text = String(model?.level as! Int)
            
            fishImgv.isHidden = false
            levelLab.isHidden = false
            cancelImgv.isHidden = !model!.isWorking
            fishImgv.alpha = model!.isWorking ? 0.5:1
        }
        
        
    }
}
