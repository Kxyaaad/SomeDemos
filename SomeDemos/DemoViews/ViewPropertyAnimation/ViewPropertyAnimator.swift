//
//  UIViewPropertyAnimator.swift
//  SomeDemos
//
//  Created by Mac on 2021/2/5.
//

import UIKit

class ViewPropertyAnimator: UIViewController {
    
    var squareView : UIView?
    
    var label : UILabel?
    
    var propertyAnimatior : UIViewPropertyAnimator?
    
    var animatorFraction : CGFloat = 0.0 {
        willSet {
            self.label?.text = newValue.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        label.text = "测试"
        label.textAlignment = .center
        label.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 200)
        view.addSubview(label)
        self.label = label
        
        let squareView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        squareView.backgroundColor = .systemGreen
        squareView.center = CGPoint(x: self.view.center.x - 100, y: self.view.center.y)
        view.addSubview(squareView)
        
        //        tapGesture.perform(#selector(tapGesture(_:)), with: animator)
        
        self.squareView = squareView
        self.animation()
    }
    
    
    func animation() {
//        let timing = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.5, y: 0.5), controlPoint2: CGPoint(x: 1, y: 0)) //贝塞尔曲线
        let timing = UISpringTimingParameters(dampingRatio: 0.5)
        
        let animator = UIViewPropertyAnimator(duration: 2.0, timingParameters: timing)
        animator.addAnimations {
            self.squareView?.center = CGPoint(x: self.view.center.x + 100, y: self.view.center.y)
            self.squareView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
            self.squareView?.backgroundColor = .red
        }
        animator.addCompletion { _ in
            self.squareView?.backgroundColor = .systemBlue
        }
        
        animator.startAnimation()
        self.propertyAnimatior = animator
        self.animatorFraction = self.propertyAnimatior?.fractionComplete ?? 0.0
        self.propertyAnimatior?.addObserver(self, forKeyPath: "fractionComplete", options: [.new, .old, .prior], context: &self.animatorFraction)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TapGesture(_:)))
        tapGesture.propertyAnimator = animator
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func TapGesture(_ sender:UITapGestureRecognizer) {
        //        sender.propertyAnimator?.fractionComplete = 0.45 //设置跳转到动画完成的比例
        
        ///提前停止动画
        //        sender.propertyAnimator?.stopAnimation(false)
        //        sender.propertyAnimator?.finishAnimation(at: .end)
        
        /// 翻转动画
        //        sender.propertyAnimator?.pauseAnimation()
        //        sender.propertyAnimator?.isReversed = !(sender.propertyAnimator?.isReversed ?? false)
        //        sender.propertyAnimator?.startAnimation()
        
        /// 返回动画添加弹性效果
//        sender.propertyAnimator?.addAnimations {
//            self.squareView?.center.x = 100
//            self.squareView?.transform = CGAffineTransform.
//        }
        
//        self.label?.text = self.propertyAnimatior?.fractionComplete.description
        
        switch sender.propertyAnimator?.state {
        case .active:
            if sender.propertyAnimator!.isRunning {
                sender.propertyAnimator?.pauseAnimation()
            }else {
                sender.propertyAnimator?.startAnimation()
            }
        default:
            break
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print("fef", change)
        if context == &self.animatorFraction {
            if keyPath == "fractionComplete" {
//                print(change?[NSKeyValueChangeKey.newKey])
                self.animatorFraction = change?[NSKeyValueChangeKey.newKey] as? CGFloat ?? 0.0
            }
        }
    }
}


//向extension添加存储属性
private var key: Void?
public extension UITapGestureRecognizer {
    var propertyAnimator : UIViewPropertyAnimator? {
        get{
            return objc_getAssociatedObject(self, &key) as? UIViewPropertyAnimator
        }
        
        set{
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}


