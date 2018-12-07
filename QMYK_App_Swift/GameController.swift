//
//  GameController.swift
//  QMYK_App_Swift
//
//  Created by shenj on 2018/10/15.
//  Copyright © 2018 aNever.all. All rights reserved.
//


import UIKit
import AudioToolbox

public enum FishMoveType : Int {
    case exchange
    case composed
    case work
    case sell
    case util
}

public enum FishAnimaType : Int {
    case work
    case sepUp
    case sepCut
}

public let itemW = screenW/2-40
public let kSoundID:UInt32 = 1104
public let getMoneyY = screenH/2
public let kFishWorkFrame = CGRect(x: screenW*3/4,
                                   y: (screenH-(screenW*2-160)/3-50)/2,
                                   width: screenW/4,
                                   height: (screenW*2-160)/3+50)
public let KSellFrame = CGRect(x: screenW*3/4, y: screenH*3/4, width: screenW/4, height: screenH/4)


class GameController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIViewControllerTransitioningDelegate ,UIGestureRecognizerDelegate{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let manager = TransitionManager(transitionType: .present)
        //自定义toViewController的宽度
        manager.widthScale = 3.0/4.0
        
        return manager
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let manager = TransitionManager(transitionType: .dismiss)
        //自定义toViewController的宽度
//        manager.animationPoint = animationPoint
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + manager.animationTime) {
//            UIView.animate(withDuration: 0.24) {
//                self.selectedBtn.alpha = 1
//            }
//        }
        
        
        return manager
    }

    
    var collectionView:UICollectionView! //
    var fishArray:NSMutableArray!        // 拥有鱼 数组
    var workFishArray:NSMutableArray!    // 工作鱼 数组
    var myGold:CGFloat = 10000.00        // 拥有金币
    
//    var fishMoveType:FishMoveType!
    var layoutAttributes:NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backColor
        
        self.prepareData()
        self.uiConfig()
        self.addWorkFishTapGest()
        
        self.localFishWork()
    }
    
    private func localFishWork() {
        
        for i in 0...fishArray.count-1 {
            let model:FishModel = fishArray![i] as! FishModel
            let unitH = kFishWorkFrame.size.height/10
            if model.isWorking {
                let y = kFishWorkFrame.origin.y + unitH * CGFloat(arc4random()%10)
                self.fishWork(model: model, pointY: y)
            }
        }
        
        
    }
    
    private func addWorkFishTapGest() {
        
        // 点击鱼加速
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(fishExpediteWork(gest:)))
        tapGest.delegate = self
        view.addGestureRecognizer(tapGest)
        
    }
    
    private func prepareData() {
        fishArray = NSMutableArray()
        workFishArray = NSMutableArray()
        
        fishArray = FishManager.getFishs()
//        fishArray.addObjects(from: fishs as! [Any])
        
        
        layoutAttributes = NSMutableArray()
    }
    
    
    private func uiConfig() {
        
        self.collectionViewConfig()
        self.workUIConfig()
        self.sellUIConfig()
        self.makeMoneyUIConfig()
    }
    
    private func workUIConfig() {
        let label = UILabel(frame: kFishWorkFrame)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Chalkduster", size: 20)
        label.text = "拖\n至\n此\n处\n赚\n钱"
        view.addSubview(label)
        
        let topLine = UIView(frame: CGRect(x: kFishWorkFrame.origin.x, y: kFishWorkFrame.origin.y, width: kFishWorkFrame.size.width, height: 1))
        topLine.backgroundColor = UIColor(red: 150, green: 150, blue: 150, alpha: 1)
        view.addSubview(topLine)
        
        let bottomLine = UIView(frame: CGRect(x: kFishWorkFrame.origin.x, y: kFishWorkFrame.origin.y+kFishWorkFrame.size.height, width: kFishWorkFrame.size.width, height: 1))
        bottomLine.backgroundColor = UIColor(red: 150, green: 150, blue: 150, alpha: 1)
        view.addSubview(bottomLine)
        
    }
    
    private func makeMoneyUIConfig() {
        let makeMoneyLabel = UILabel(frame: CGRect(x: 0, y: getMoneyY+2, width: screenW/4, height: 10))
        makeMoneyLabel.textColor = UIColor.lightGray
        makeMoneyLabel.textAlignment = NSTextAlignment.center
        makeMoneyLabel.text = "经过赚钱"
        makeMoneyLabel.font = UIFont(name: "Chalkduster", size: 15)
        view.addSubview(makeMoneyLabel)
        
        let makeMoneyLine = UIView(frame: CGRect(x: 0, y: getMoneyY, width: screenW/4, height: 1))
        makeMoneyLine.backgroundColor = UIColor(red: 150, green: 150, blue: 150, alpha: 1)
        view.addSubview(makeMoneyLine)

    }
    
    private func sellUIConfig() {
        
        let label = UILabel(frame: KSellFrame)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Chalkduster", size: 20)
        label.text = "拖至此处出售"
        view.addSubview(label)
        
        let topLine = UIView(frame: CGRect(x: KSellFrame.origin.x, y: KSellFrame.origin.y, width: KSellFrame.size.width, height: 1))
        topLine.backgroundColor = UIColor(red: 150, green: 150, blue: 150, alpha: 1)
        view.addSubview(topLine)

        
    }
    
    private func collectionViewConfig() {
        
        let layout = UICollectionViewFlowLayout() //18722-10801=7800
        layout.itemSize = CGSize(width: (itemW)/3, height: (itemW)/3)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = CGSize(width: screenW/2, height: 100)
        layout.footerReferenceSize = CGSize(width: screenW/2, height: 100)
        
        let height =  (screenW*2-160)/3+250
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenW/2, height: height), collectionViewLayout: layout)
        collectionView.center = view.center
        collectionView.layer.cornerRadius = screenW/4
        collectionView.layer.borderWidth = 0.5
        collectionView.backgroundColor = UIColor.clear
        collectionView.clipsToBounds = false
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.register(KunCell.self, forCellWithReuseIdentifier: NSStringFromClass(KunCell.self))
        collectionView.register(GameHeader.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader , withReuseIdentifier: NSStringFromClass(GameHeader.self))
        collectionView.register(GameFooter.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter , withReuseIdentifier: NSStringFromClass(GameFooter.self))
        
    }
    
    //MARK:- collectionView D
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fishArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:KunCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(KunCell.self), for: indexPath) as! KunCell
        
        let model:FishModel = (fishArray[indexPath.row] as? FishModel)!
        cell.model = model
        
        if model.isWorking == false &&
            model.isPlaceholder == false {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(longPressAction(gest:)))
            cell.fishImgv.addGestureRecognizer(panGesture)
            cell.fishImgv.isUserInteractionEnabled = true
        }else {
            cell.fishImgv.isUserInteractionEnabled = false
        }
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview:UICollectionReusableView!
        
        if kind == UICollectionView.elementKindSectionHeader
        {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(GameHeader.self), for: indexPath)
            reusableview.backgroundColor = UIColor.clear
            
        }
        else if kind == UICollectionView.elementKindSectionFooter
        {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(GameFooter.self), for: indexPath)
            reusableview.backgroundColor = UIColor.clear
            
            weak var weakSelf = self
            (reusableview as! GameFooter).shopBtnActionBlock = { ()->() in
                let fishListVC = FishListController()
                fishListVC.transitioningDelegate = self
                fishListVC.modalPresentationStyle = .custom
                fishListVC.fishArray = self.fishArray
                
                weak var weakSelf = self
                fishListVC.addFishBlock = { (model) -> () in
                    //            weakSelf?.fishArray.add(model) // 添加界面修改数据源
                    weakSelf?.collectionView.reloadData()
                    FishManager.saveLocalFishs(fishs: self.fishArray as! Array<FishModel>)
                }
                weakSelf!.present(fishListVC, animated: true, completion: nil)

            }
            
        }
        
        return reusableview
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let model:FishModel = fishArray![indexPath.row] as! FishModel
        if model.isWorking {
            let cell:KunCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(KunCell.self), for: indexPath) as! KunCell

            let rect = collectionView.convert(cell.frame, to: collectionView.superview)
            fishStopWork(model: model,point: CGPoint(x: rect.origin.x, y: rect.origin.y))
            model.isWorking = false
            collectionView.reloadItems(at: [indexPath])
            
        }
    }
    
    //MARK:- panGest
    @objc private func longPressAction(gest:UIPanGestureRecognizer) {
        
        let gestView = gest.view
        let cell:KunCell = gestView?.superview?.superview as! KunCell
        let cellIndexPath = collectionView.indexPath(for: cell)
        
        collectionView.bringSubviewToFront(cell)
        
        switch gest.state {
        case UIGestureRecognizer.State.began:
            
            AudioServicesPlaySystemSound(kSoundID)
            
            layoutAttributes.removeAllObjects()
            for i in 0...fishArray.count-1 {
                layoutAttributes.add(collectionView.layoutAttributesForItem(at: NSIndexPath.init(row: i, section: 0) as IndexPath) as Any)
            }
            
        case UIGestureRecognizer.State.changed:
            
            gestView?.center = gest.location(in: cell)
            
        case UIGestureRecognizer.State.ended:
            
            let gestViewInCollectionView = gest.location(in: cell.superview!)
            let gestViewInWindow = gest.location(in: cell.superview?.superview!)
            
            // cell所在区域
            for i in 0...layoutAttributes.count-1 {
                let attributes = layoutAttributes[i] as! UICollectionViewLayoutAttributes
                
                if attributes.frame.contains(gestViewInCollectionView) &&
                    cellIndexPath != attributes.indexPath {
                    
                    // 移动到其他cell位置
                    let froModel:FishModel = (fishArray[cellIndexPath!.row] as? FishModel)!
                    let toModel:FishModel = (fishArray[attributes.indexPath.row] as? FishModel)!
                    
                    if toModel.isPlaceholder { //目标为空（占位model）
                        print("目标为空（占位model）")
                        AudioServicesPlaySystemSound(kSoundID)
                        
                        fishArray.exchangeObject(at: cellIndexPath!.row, withObjectAt: attributes.indexPath.row)
                        collectionView.reloadData()
                        FishManager.saveLocalFishs(fishs: fishArray as! Array<FishModel>)
                        
                        let attribute:UICollectionViewLayoutAttributes = collectionView.layoutAttributesForItem(at: attributes.indexPath)!
                        gestView!.center = CGPoint(x: attribute.size.width/2, y: attribute.size.height/2)
                        
                        break
                        //                        collectionView.relo
                        
                    } else if froModel.level == toModel.level { //与目标鲲等级相同 合成
                        print("与目标鲲等级相同 合成")

                        let newModel:FishModel = FishManager.getFish(level: froModel.level!+1)
                        
                        let attribute:UICollectionViewLayoutAttributes = collectionView.layoutAttributesForItem(at: attributes.indexPath)!
                        
                        if toModel.isWorking {
                            fishStopWork(model: toModel ,point: CGPoint(x: attributes.center.x+collectionView.frame.origin.x, y: attributes.center.y+collectionView.frame.origin.y))
                        }
                        
                        let toCell:KunCell = collectionView.cellForItem(at: attribute.indexPath) as! KunCell
                        let gestCenter:CGPoint =  gest.location(in: cell)
                        let toCellImgvCenter:CGPoint = toCell.fishImgv.center
                        
                        //MARK:- 鱼 合成动画
                        UIView.animate(withDuration: 0.24, animations: {
                            
                            gestView?.center = CGPoint(x: gestCenter.x-100, y: gestCenter.y)
                            toCell.fishImgv.center = CGPoint(x: toCellImgvCenter.x+100, y: toCellImgvCenter.y)
                        }) { (bool1) in
                            
                            UIView.animate(withDuration: 0.24, animations: {
                                gestView?.center = CGPoint(x: gestCenter.x, y: gestCenter.y)
                                toCell.fishImgv.center = CGPoint(x: toCellImgvCenter.x, y: toCellImgvCenter.y)
                            }, completion: { (bool2) in
                                
                                gestView!.center = CGPoint(x: attribute.size.width/2, y: attribute.size.height/2)
                                
                                self.fishArray.replaceObject(at: attributes.indexPath.row, with: newModel)
                                self.fishArray.replaceObject(at: cellIndexPath!.row, with: FishManager.getPlaceholderFish())
                                self.collectionView.reloadData()
                                FishManager.saveLocalFishs(fishs: self.fishArray as! Array<FishModel>)

                            })
                            
                        }
                        
                        AudioServicesPlaySystemSound(kSoundID)
                        break
                    }else {

                        print("cell内 其他")
                        let attributes:UICollectionViewLayoutAttributes = collectionView.layoutAttributesForItem(at: cellIndexPath!)!
                        gestView!.center = CGPoint(x: attributes.size.width/2, y: attributes.size.height/2)
                        break
                    }
                    
                }
                else {
                    
                    // 工作区域
                    if kFishWorkFrame.contains(gestViewInWindow) {
                        //                fishMoveType = FishMoveType.work
                        print("工作区域")
                        let attributes:UICollectionViewLayoutAttributes = collectionView.layoutAttributesForItem(at: cellIndexPath!)!
                        gestView!.center = CGPoint(x: attributes.size.width/2, y: attributes.size.height/2)

                        let model:FishModel = fishArray[cellIndexPath!.row] as! FishModel
                        model.isWorking = true
                        
                        collectionView.reloadData()
                        FishManager.saveLocalFishs(fishs: fishArray as! Array<FishModel>)

                        
                        self.fishWork(model: model, pointY: gestViewInWindow.y)
                        
                        break
                    }
                    
                    // 出售区域
                    if KSellFrame.contains(gestViewInWindow) {
                        //                fishMoveType = FishMoveType.sell
                        print("出售区域")
                        let model:FishModel = FishManager.getPlaceholderFish()
                        fishArray.replaceObject(at: cellIndexPath!.row, with: model)
                        
                        collectionView.reloadItems(at: [cellIndexPath!])
                        
                        FishManager.saveLocalFishs(fishs: fishArray as! Array<FishModel>)

                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.48)) {
                            let attributes:UICollectionViewLayoutAttributes = self.collectionView.layoutAttributesForItem(at: cellIndexPath!)!
                            gestView!.center = CGPoint(x: attributes.size.width/2, y: attributes.size.height/2)
                        }
                        
                        break
                    }
                    
                    if i == layoutAttributes.count-1 {
                        print("cell外 其他")
                        let attributes:UICollectionViewLayoutAttributes = collectionView.layoutAttributesForItem(at: cellIndexPath!)!
                        gestView!.center = CGPoint(x: attributes.size.width/2, y: attributes.size.height/2)

                    }
                    
                }
                
            }
            // 其他区域
            
        default:
            break
        }
        
    }
    
    //MARK:- 鱼开始工作
    private func fishWork(model:FishModel, pointY:CGFloat) {
        
        let fishBtn = FishButton.init(type: UIButton.ButtonType.custom)
        fishBtn.model = model
        fishBtn.frame = CGRect(x: 0, y: 0, width: itemW/4, height: itemW/3)
        fishBtn.center = CGPoint(x: screenW*7/8, y: pointY)
        fishBtn.setImage(UIImage(named: model.image!), for: UIControl.State.normal)
        view.addSubview(fishBtn)
        
        var transform = CGAffineTransform.identity
        transform = CGAffineTransform.init(rotationAngle: CGFloat.pi/2)
        fishBtn.transform = transform
        workFishArray.add(fishBtn)
        
        fishWorkAnima(fishBtn: fishBtn, type: FishAnimaType.work)
        fishWorkToCollect(fishBtn:fishBtn)
    }
    
    //MARK:- 鱼暂停工作
    private func fishStopWork(model:FishModel, point:CGPoint) {
        
        for i in 0...workFishArray.count-1 {
            let fishBtn:FishButton = workFishArray[i] as! FishButton
            if fishBtn.model == model {
        
                fishBtn.fishTimer?.invalidate() // 停止定时器
                
                let path = UIBezierPath()
                path.move(to: (fishBtn.layer.presentation()?.position)!)
                path.addLine(to: point)
                
                let animation = CAKeyframeAnimation(keyPath: "position")
                animation.duration = 0.24
                animation.path = path.cgPath
                animation.calculationMode = CAAnimationCalculationMode.paced
                animation.isRemovedOnCompletion = false
                animation.autoreverses = false
                animation.repeatCount = MAXFLOAT
                animation.rotationMode = CAAnimationRotationMode.rotateAuto
                animation.fillMode = CAMediaTimingFillMode.forwards
                fishBtn.layer.add(animation, forKey: "fishWorkKey")
                
                UIView.animate(withDuration: 0.24, animations: {
                    fishBtn.alpha = 0
                }) { (bool) in
                    fishBtn.removeFromSuperview()
                    self.workFishArray.remove(fishBtn)
                }
                
                break
            }
        }

    }
    
    //MARK:- 鱼 点击加速
    @objc private func fishExpediteWork(gest:UITapGestureRecognizer) {
        
        let touchPoint = gest.location(in: view)
        
        if touchPoint.y >= kFishWorkFrame.origin.y+kFishWorkFrame.size.height {
            print(touchPoint)
            for fishBtn in workFishArray {
                let btn:FishButton = fishBtn as! FishButton
                
                let layer:CALayer? = btn.layer.presentation()?.hitTest(touchPoint)
                if layer != nil {
//                    print(btn.model?.level!)
                    btn.model?.animaTimeInterval = (btn.model?.animaTimeInterval)!/2
                    btn.model?.touchSpeUp = true
                    btn.isHiddenAlert = true
                    fishWorkAnima(fishBtn: btn, type:FishAnimaType.sepUp) // 一次加速
                    
                }
            }
        }
        
    }
    
    
    //MARK:- 鱼工作动画
    private func fishWorkAnima(fishBtn:FishButton,type:FishAnimaType) {
        
        if type == FishAnimaType.work { //正常工作
            let path = UIBezierPath()
            path.move(to: fishBtn.center)
            path.addLine(to: CGPoint(x: fishBtn.center.x,
                                     y: kFishWorkFrame.origin.y))
            
            path.addArc(withCenter: CGPoint(x: screenW/2,
                                            y: kFishWorkFrame.origin.y),
                        radius: screenW*3/8, startAngle: 0, endAngle: CGFloat.pi, clockwise: false)
            
            path.addLine(to: CGPoint(x: screenW/8,
                                     y: kFishWorkFrame.origin.y+kFishWorkFrame.size.height))
            
            path.addArc(withCenter: CGPoint(x: screenW/2,
                                            y:kFishWorkFrame.origin.y+kFishWorkFrame.size.height),
                        radius: screenW*3/8, startAngle: CGFloat.pi, endAngle: 2*CGFloat.pi, clockwise: false)
            
            path.addLine(to: fishBtn.center)
            
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.duration = fishBtn.model!.animaTimeInterval!
            animation.path = path.cgPath
            animation.calculationMode = CAAnimationCalculationMode.paced
            animation.isRemovedOnCompletion = false
            animation.autoreverses = false
            animation.repeatCount = MAXFLOAT
            animation.rotationMode = CAAnimationRotationMode.rotateAuto
            animation.fillMode = CAMediaTimingFillMode.forwards
            fishBtn.layer.add(animation, forKey: "fishWorkKey")
            
//            let lineShape = CAShapeLayer()
//            lineShape.frame = view.bounds
//            lineShape.lineWidth = 2
//            lineShape.strokeColor = UIColor.green.cgColor
//            lineShape.path = path.cgPath
//            lineShape.fillColor = UIColor.clear.cgColor
//
//            view.layer.addSublayer(lineShape)
            
        }else if type == FishAnimaType.sepUp { // 点击加速
            
            print(fishBtn.layer.position)
            let point:CGPoint = (fishBtn.layer.presentation()?.position)!
            
            let path = UIBezierPath()
            path.move(to: point)
            
            let startAngel = acos((screenW/2 - point.x)/(screenW*3/8))
            
            path.addArc(withCenter: CGPoint(x: screenW/2,
                                            y:kFishWorkFrame.origin.y+kFishWorkFrame.size.height),
                        radius: screenW*3/8, startAngle: CGFloat.pi-startAngel,
                        endAngle: 2*CGFloat.pi, clockwise: false)

            path.addLine(to: CGPoint(x: screenW*7/8,
                                     y: kFishWorkFrame.origin.y))

            path.addArc(withCenter: CGPoint(x: screenW/2,
                                            y:kFishWorkFrame.origin.y),
                        radius: screenW*3/8, startAngle: 0, endAngle: CGFloat.pi, clockwise: false)

            path.addLine(to: CGPoint(x: screenW/8,
                                     y: kFishWorkFrame.origin.y+kFishWorkFrame.size.height))

            path.addArc(withCenter: CGPoint(x: screenW/2,
                                            y:kFishWorkFrame.origin.y+kFishWorkFrame.size.height),
                        radius: screenW*3/8, startAngle: CGFloat.pi, endAngle: CGFloat.pi-startAngel, clockwise: false)
            
            
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.duration = fishBtn.model!.animaTimeInterval!
            animation.path = path.cgPath
            animation.calculationMode = CAAnimationCalculationMode.paced
            animation.isRemovedOnCompletion = false
            animation.autoreverses = false
            animation.repeatCount = MAXFLOAT
            animation.rotationMode = CAAnimationRotationMode.rotateAuto
            animation.fillMode = CAMediaTimingFillMode.forwards
            fishBtn.layer.add(animation, forKey: "fishWorkKey")
            
//            let lineShape = CAShapeLayer()
//            lineShape.frame = view.bounds
//            lineShape.lineWidth = 2
//            lineShape.strokeColor = UIColor.red.cgColor
//            lineShape.path = path.cgPath
//            lineShape.fillColor = UIColor.clear.cgColor
//
//            view.layer.addSublayer(lineShape)
            
        } else if  type == FishAnimaType.sepCut { // 点击加速的鱼 经过赚钱点降回原速
            
            let point:CGPoint = (fishBtn.layer.presentation()?.position)!
            
            let path = UIBezierPath()
            path.move(to: point)
            path.addLine(to: CGPoint(x: screenW/8,
                                     y: kFishWorkFrame.origin.y+kFishWorkFrame.size.height))
            
            path.addArc(withCenter: CGPoint(x: screenW/2,
                                            y: kFishWorkFrame.origin.y+kFishWorkFrame.size.height),
                        radius: screenW*3/8, startAngle: CGFloat.pi, endAngle: 2*CGFloat.pi, clockwise: false)
            
            path.addLine(to: CGPoint(x: screenW*7/8,
                                     y: kFishWorkFrame.origin.y))
            
            path.addArc(withCenter: CGPoint(x: screenW/2,
                                            y:kFishWorkFrame.origin.y),
                        radius: screenW*3/8, startAngle: 0, endAngle: CGFloat.pi, clockwise: false)
            
            path.addLine(to: point)
            
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.duration = fishBtn.model!.animaTimeInterval!
            animation.path = path.cgPath
            animation.calculationMode = CAAnimationCalculationMode.paced
            animation.isRemovedOnCompletion = false
            animation.autoreverses = false
            animation.repeatCount = MAXFLOAT
            animation.rotationMode = CAAnimationRotationMode.rotateAuto
            animation.fillMode = CAMediaTimingFillMode.forwards
            fishBtn.layer.add(animation, forKey: "fishWorkKey")
            
//            let lineShape = CAShapeLayer()
//            lineShape.frame = view.bounds
//            lineShape.lineWidth = 2
//            lineShape.strokeColor = UIColor.yellow.cgColor
//            lineShape.path = path.cgPath
//            lineShape.fillColor = UIColor.clear.cgColor
//
//            view.layer.addSublayer(lineShape)

            
        }
        
        

        
    }
    
    //MARK:- 鱼经过赚钱区
    private func fishWorkToCollect(fishBtn:FishButton) {
        
        var lastY:CGFloat = getMoneyY
        fishBtn.fishTimer = Timer(timeInterval: 0.01, repeats: true) { (timer) in
            
            // 赚钱判断
            weak var weakSelf = self
            let y:CGFloat = fishBtn.layer.presentation()?.frame.origin.y ?? fishBtn.center.y
            if lastY < getMoneyY &&
                y >= getMoneyY{
                print(fishBtn.model?.name!)
                print("赚钱" )
                
                if (fishBtn.model?.touchSpeUp)! { // 单次加速完成
                    fishBtn.model?.touchSpeUp = false
                    fishBtn.model?.animaTimeInterval = (fishBtn.model?.animaTimeInterval!)!*2
                    weakSelf?.fishWorkAnima(fishBtn: fishBtn, type: FishAnimaType.sepCut)
                }
                // 经过赚钱区域
                weakSelf?.fishMakeMoneyAnima(money: (fishBtn.model?.makePrice)!)
                
            }
            
            // 显示 点击加速
            if lastY < kFishWorkFrame.origin.y + kFishWorkFrame.size.height &&
                y >= kFishWorkFrame.origin.y + kFishWorkFrame.size.height {
                fishBtn.isHiddenAlert = false
            }
            
            // 隐藏 点击加速
            if lastY > kFishWorkFrame.origin.y + kFishWorkFrame.size.height &&
                y <= kFishWorkFrame.origin.y + kFishWorkFrame.size.height{
                fishBtn.isHiddenAlert = true
            }
            
            lastY = y
            
            
            
        }
        RunLoop.main.add(fishBtn.fishTimer!, forMode: RunLoop.Mode.common)
        fishBtn.fishTimer!.fire()
        
        // 不同等级fishBtn经过指定区域
        
        // 动画执行经过某个区域
        print("fishWokToCollect")
        
        // 赚钱动画
        
        // 赚钱总数
        
        
    }
    
    //MARK:- GestureRecognizer D
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool  {
        
        if (touch.view?.isDescendant(of: self.collectionView))! {
            return false
        }else {
            return true
        }
        
    }
    
    //MARK:- 鱼赚钱 获得金钱 动效
    private func fishMakeMoneyAnima(money:Double) {
        
        let moneyStr = GameController.changeMoneyShowType(money: money)
        
        let label = UILabel(frame: CGRect(x: 20, y: getMoneyY, width: screenW/2, height: 20))
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Chalkduster", size: 18)
        label.text = moneyStr
        view.addSubview(label)
        
        UIView.animate(withDuration: 0.48, animations: {
            label.frame.origin.y = getMoneyY-80
        }) { (bool) in
            UIView.animate(withDuration: 0.72, animations: {
                label.frame.origin.y = getMoneyY-150
                label.alpha = 0
            }, completion: { (bool) in
                label.removeFromSuperview()
            })
        }
        
    }
    
    //MARK:- 钱数 Float 转字符串
    //万、亿、兆、京、垓、秭、穰、沟、涧、正、载
    class func changeMoneyShowType(money:Double) -> (String) {
        var moneyStr:String?
        if money >= pow(10, 44) { // 载
            moneyStr = String(format: "+ %.2f载",money/pow(10, 44))
            
        }else if money >= pow(10, 40) { // 正
            moneyStr = String(format: "+ %.2f正",money/pow(10, 40))
            
        }else if money >= pow(10, 36) { // 涧
            moneyStr = String(format: "+ %.2f涧",money/pow(10, 36))
            
        }else if money >= pow(10, 32) { // 沟
            moneyStr = String(format: "+ %.2f沟",money/pow(10, 32))
            
        }else if money >= pow(10, 28) { // 穰
            moneyStr = String(format: "+ %.2f穰",money/pow(10, 28))
            
        }else if money >= pow(10, 24) { // 秭
            moneyStr = String(format: "+ %.2f秭",money/pow(10, 24))
            
        }else if money >= pow(10, 20) { // 垓
            moneyStr = String(format: "+ %.2f垓",money/pow(10, 20))
            
        }else if money >= pow(10, 16) { // 京
            moneyStr = String(format: "+ %.2f京",money/pow(10, 16))
            
        }else if money >= pow(10, 12) { // 兆
            moneyStr = String(format: "+ %.2f兆",money/pow(10, 12))
            
        }else if money >= pow(10, 8) { // 亿
            moneyStr = String(format: "+ %.2f亿",money/pow(10, 8))
            
        }else if money >= pow(10, 4) { // 万
            moneyStr = String(format: "+ %.2f万",money/pow(10, 4))
        }else {
            moneyStr = String(format: "+ %.0f",money)
        }
        return moneyStr!
    }
    
    //MARK:- 金钱累计 （增减）
        
//        CGPoint touchPoint = [tap locationInView:self];
//        for (DTActivityMarqueeView *marqueeView in self.views) {
//            if (marqueeView) {
//                CALayer *layer = [marqueeView.layer.presentationLayer hitTest:touchPoint];
//                if (layer) {
//                    [marqueeView.delegate activityMarqueeViewClick:marqueeView];
//                    break;
//                }
//            }
//
//        }
}
