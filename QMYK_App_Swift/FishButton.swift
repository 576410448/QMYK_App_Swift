//
//  FishButton.swift
//  QMYK_App_Swift
//
//  Created by shenj on 2018/10/19.
//  Copyright © 2018 aNever.all. All rights reserved.
//

import UIKit

class FishButton: UIButton {

    var model:FishModel?
    var fishTimer:Timer?
    var _isHiddenAlert:Bool?
    var isHiddenAlert:Bool? {
        set {
            _isHiddenAlert = newValue!
            alertRota()
        }
        get {
            return _isHiddenAlert
        }
    }
    
    var alertLayer:CATextLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.uiConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func alertRota() {
        
        alertLayer?.isHidden = isHiddenAlert!
        
        let time:CFTimeInterval? = model?.animaTimeInterval
        
        let timeThis =  (CGFloat.pi*screenW*3/8) / (2*CGFloat.pi*screenW*3/8+2*kFishWorkFrame.size.height)

        // 创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 设置动画属性
        anim.fromValue = CGFloat.pi
        anim.toValue = 2 * CGFloat.pi
        anim.repeatCount = 1
        anim.duration = time!*Double(timeThis)-0.11
        anim.isRemovedOnCompletion = false
        // 将动画添加到图层上
        alertLayer!.add(anim, forKey: "alertRotaKey")
//
        if isHiddenAlert! {
            alertLayer?.removeAllAnimations()
        }

    }
    
    private func uiConfig() {
        alertLayer = CATextLayer.init()
        alertLayer?.string = "点击加速"
        alertLayer?.foregroundColor = UIColor.red.cgColor
        alertLayer?.isHidden = true
        alertLayer?.font = "HiraKakuProN-W3" as CFTypeRef;//字体的名字 不是 UIFont
        alertLayer?.fontSize = 18;//字体的大小
        //设置渲染的方式
        alertLayer?.contentsScale = UIScreen.main.scale;
        alertLayer?.bounds = CGRect(x: 0, y: 0, width: 80, height: 19)
//        alertLayer.
        layer.addSublayer(alertLayer!)
    }

}
