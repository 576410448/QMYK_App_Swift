//
//  GameFooter.swift
//  QMYK_App_Swift
//
//  Created by shenj on 2018/10/19.
//  Copyright © 2018 aNever.all. All rights reserved.
//

import UIKit

class GameFooter: UICollectionReusableView {
    var shopBtnActionBlock:(()->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        let shopBtn:UIButton = UIButton(type: UIButton.ButtonType.custom)
        shopBtn.frame = CGRect(x: 0, y: 0, width: screenW/2, height: 100)
        shopBtn.setTitle("商城", for: UIControl.State.normal)
        shopBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        shopBtn.addTarget(self, action: #selector(shopBtnAction), for: UIControl.Event.touchUpInside)
        self.addSubview(shopBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func shopBtnAction() {
        if shopBtnActionBlock != nil {
            shopBtnActionBlock!()
        }
    }
}
