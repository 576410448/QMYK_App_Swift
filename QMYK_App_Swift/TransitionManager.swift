//
//  PresentTransition.swift
//  EShow
//
//  Created by shenj on 2018/9/30.
//  Copyright © 2018 cyyun. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning ,CAAnimationDelegate{
    
    let animationTime:Double = 1.2
    var animationPoint:CGPoint!    // 动画起始位置
    var animationStartSize:CGSize! // 动画其实尺寸
    
    var transitionDuration: TimeInterval = 0.25
    var widthScale: CGFloat = 0.5
    
    enum TransitionType {
        case dismiss
        case present
    }
    
    private let transitionType: TransitionType
    
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .present:
            let containerView = transitionContext.containerView
            containerView.backgroundColor = UIColor(white: 0, alpha: 0)
            
            let toViewController = transitionContext.viewController(forKey: .to)!
            toViewController.view.frame.size.width = containerView.frame.width * widthScale
            toViewController.view.frame.origin.x = containerView.frame.width
            containerView.addSubview(toViewController.view)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                containerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                toViewController.view.frame.origin = CGPoint(x: (1-self.widthScale)*screenW, y: 0)
            }) { (bool) in
                transitionContext.completeTransition(true)
            }
//            self.animationPresent(containerView: containerView, toViewController: toViewController)
            
            
            
            //回调执行者
            let target = TapGestureRecognizerTarget()
            target.isHidden = true
            target.contentViewController = toViewController
            containerView.layer.addSublayer(target)
            let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: #selector(target.handleTap))
            tapGestureRecognizer.delegate = target
            containerView.addGestureRecognizer(tapGestureRecognizer)
            
        case .dismiss:
            let containerView = transitionContext.containerView
            containerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            let fromViewController = transitionContext.viewController(forKey: .from)!

//            self.animationDismiss(containerView: containerView, fromViewController: fromViewController)
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animationTime) {
//                transitionContext.completeTransition(true)
//            }
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                containerView.backgroundColor = UIColor.init(white: 0, alpha: 0)
                fromViewController.view.frame.origin.x = containerView.frame.size.width
            }) { (bool) in
                transitionContext.completeTransition(true)
            }
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
    
//    private func animationDismiss(containerView:UIView, fromViewController:UIViewController) {
//        let maskLayer = CAShapeLayer()
//        maskLayer.lineCap = kCALineCapRound
//        fromViewController.view.layer.mask = maskLayer
//
//
//        let bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
//
//        // Create CAShapeLayerS
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = bounds
//        rectShape.position = animationPoint
//        rectShape.cornerRadius = bounds.width / 2
//        maskLayer.addSublayer(rectShape)
//
//        // 开始的shape半径为50
//        let startShape = UIBezierPath(roundedRect: bounds, cornerRadius: 0).cgPath
//        // 结束的shape半径为500
//        let endShape = UIBezierPath(roundedRect: CGRect(x: -900, y: -900, width: 2000, height: 2000), cornerRadius: 1200).cgPath
//
//        //设置开始的shape
//        rectShape.path = endShape
//
//        // 使用CABasicAnimation来动画
//        // animate the `path`
//        let animation = CABasicAnimation(keyPath: "path")
//        animation.delegate = self
//        animation.toValue = startShape
//        animation.duration = animationTime // 动画时间
//        // 设置动画曲线为渐进渐出，开起来自然
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        animation.fillMode = kCAFillModeBoth // keep to value after finishing
//        animation.isRemovedOnCompletion = false // 动画完成后不移除
//        // 把动画添加到layer上
//        rectShape.add(animation, forKey: animation.keyPath)
//
//    }
    
//    private func animationPresent(containerView:UIView, toViewController:UIViewController) {
//
//        let maskLayer = CAShapeLayer()
//        maskLayer.lineCap = kCALineCapRound
//        toViewController.view.layer.mask = maskLayer
//
//
//        let bounds = CGRect(x: 0, y: 0, width: animationStartSize.width, height: animationStartSize.height)
//
//        // Create CAShapeLayerS
//        let rectShape = CAShapeLayer()
//        rectShape.bounds = bounds
//        rectShape.position = animationPoint
//        rectShape.cornerRadius = bounds.width / 2
//        maskLayer.addSublayer(rectShape)
//
//        // 开始的shape半径为50
//        let startShape = UIBezierPath(roundedRect: bounds, cornerRadius: 50).cgPath
//        // 结束的shape半径为500
//        let endShape = UIBezierPath(roundedRect: CGRect(x: -900, y: -900, width: 2000, height: 2000), cornerRadius: 1200).cgPath
//
//        //设置开始的shape
//        rectShape.path = startShape
//
//        // 使用CABasicAnimation来动画
//        // animate the `path`
//        let animation = CABasicAnimation(keyPath: "path")
//        animation.delegate = self
//        animation.toValue = endShape
//        animation.duration = animationTime // 动画时间
//        // 设置动画曲线为渐进渐出，开起来自然
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        animation.fillMode = kCAFillModeBoth // keep to value after finishing
//        animation.isRemovedOnCompletion = false // 动画完成后不移除
//        // 把动画添加到layer上
//        rectShape.add(animation, forKey: animation.keyPath)
//
//    }
    
    private class TapGestureRecognizerTarget: CALayer, UIGestureRecognizerDelegate {

        weak var contentViewController: UIViewController?

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            let point = gestureRecognizer.location(in: gestureRecognizer.view)
            if let viewController = contentViewController {
                return !viewController.view.frame.contains(point)
            }
            return true
        }

        @objc func handleTap() {
            contentViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
