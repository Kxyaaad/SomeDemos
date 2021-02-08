//
//  UIViewPropertyAnimator.swift
//  SomeDemos
//
//  Created by Mac on 2021/2/5.
//

import UIKit

class ViewPropertyAnimator: UIViewController {
    
    var squareView : UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let squareView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        squareView.backgroundColor = .systemGreen
        squareView.center = CGPoint(x: self.view.center.x - 100, y: self.view.center.y)
        view.addSubview(squareView)
        
//        tapGesture.perform(#selector(tapGesture(_:)), with: animator)
        
        self.squareView = squareView
        self.animation()
    }
    
    func animation() {
        let timing = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: 2.0, timingParameters: timing)
        animator.addAnimations {
            self.squareView?.center = CGPoint(x: self.view.center.x + 100, y: self.view.center.y)
            self.squareView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }
        animator.addCompletion { _ in
            self.squareView?.backgroundColor = .systemBlue
        }
        
        animator.startAnimation()
//        perform(#selector(pause(_:)), with: animator, afterDelay: 1.0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TapGesture(_:)))
        tapGesture.propertyAnimator = animator
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func pause(_ animator:UIViewPropertyAnimator) {
//        animator.stopAnimation(false)
        animator.pauseAnimation()
//        print(animator.isRunning)
        animator.finishAnimation(at: .end)
//        animator.startAnimation()
//        animator.isReversed = true
    }
    
    @objc func TapGesture(_ sender:UITapGestureRecognizer) {
        if sender.propertyAnimator?.state == .some(.stopped) {
            sender.propertyAnimator?.continueAnimation(withTimingParameters: .none, durationFactor: 1)
        }else if sender.propertyAnimator?.state == .some(.active) {
            sender.propertyAnimator?.stopAnimation(true)
        }else if sender.propertyAnimator?.state == .some(.inactive) {
            sender.propertyAnimator?.startAnimation()
        }
    }
}

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
