//
//  SceneView.swift
//  RxMarbles
//
//  Created by Roman Tutubalin on 21.01.16.
//  Copyright © 2016 Roman Tutubalin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SceneView: UIView {
    var animator: UIDynamicAnimator?
    var sourceTimeline: SourceTimelineView! {
        didSet {
            sourceTimeline.center.y = center.y * 0.33
            addSubview(sourceTimeline)
            
            for t in 1..<4 {
                let time = t * 100
                let event = Event.Next(ColoredType(value: String(randomNumber()), color: Color.nextRandom, shape: .Circle))
                sourceTimeline.addNextEventToTimeline(time, event: event, animator: animator, isEditing: editing)
            }
            let completedTime = 700
            sourceTimeline.addCompletedEventToTimeline(completedTime, animator: animator, isEditing: editing)
        }
    }
    var secondSourceTimeline: SourceTimelineView! {
        didSet {
            secondSourceTimeline.center.y = center.y * 0.66
            addSubview(secondSourceTimeline)
            
            for t in 1..<3 {
                let time = t * 100
                let event = Event.Next(ColoredType(value: String(randomNumber()), color: Color.nextRandom, shape: .Rect))
                secondSourceTimeline.addNextEventToTimeline(time, event: event, animator: animator, isEditing: editing)
            }
            let secondCompletedTime = 500
            secondSourceTimeline.addCompletedEventToTimeline(secondCompletedTime, animator: animator, isEditing: editing)
        }
    }
    var resultTimeline: ResultTimelineView! {
        didSet {
            resultTimeline.center.y = center.y
            addSubview(resultTimeline)
        }
    }
    var trashView = UIImageView(image: Image.trash)
    var currentOperator: Operator!
    var editing: Bool!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRectZero)
        trashView.frame = CGRectMake(0, 0, 60, 60)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resultTimeline.frame = CGRectMake(0, 0, bounds.size.width, 40)
        resultTimeline.center.y = center.y
        sourceTimeline.frame = CGRectMake(0, 0, bounds.size.width, 40)
        sourceTimeline.center.y = center.y * 0.33
        if secondSourceTimeline != nil {
            secondSourceTimeline.frame = CGRectMake(0, 0, bounds.size.width, 40)
            secondSourceTimeline.center.y = center.y * 0.66
        }
        trashView.center.x = bounds.size.width / 2.0
        trashView.center.y = bounds.size.height - 50
    }
    
    func updateResultTimeline() {
        if let secondSourceTimeline = secondSourceTimeline {
            resultTimeline.updateEvents((sourceTimeline.sourceEvents, secondSourceTimeline.sourceEvents))
        } else {
            resultTimeline.updateEvents((sourceTimeline.sourceEvents, nil))
        }
    }
    
    func showTrashView() {
        addSubview(trashView)
        trashView.hidden = false
        trashView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        trashView.alpha = 0.05
        UIView.animateWithDuration(0.3) { _ in
            self.trashView.alpha = 0.2
            self.trashView.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.trashView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
    }
    
    func hideTrashView() {
        trashView.hideWithCompletion({ _ in self.trashView.removeFromSuperview() })
    }
    
    private func randomNumber() -> Int {
        return Int(arc4random_uniform(10) + 1)
    }
    
}