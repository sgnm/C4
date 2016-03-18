//
//  WorkSpace.swift
//  05_C4
//
//  Created by Shin on 2016/03/18.
//  Copyright © 2016年 Shin. All rights reserved.
//

import UIKit

class WorkSpace: CanvasController {

    override func setup() {
        let microbe = createMicrobe(canvas.center)
        randomMove(microbe)
        canvas.add(microbe)
    }
    
    func createMicrobe(center: Point) -> Circle {
        let microbe = Circle(center: center, radius: 50)
        microbe.lineWidth = 0
        microbe.fillColor = C4Pink
        
        let a = ViewAnimation(duration: 0.5) {
            microbe.fillColor = C4Blue
        }
        a.autoreverses = true
        a.repeats = true
        a.animate()
        
        return microbe
    }
    
    func randomMove(microbe: Circle) {
        let randomMove = ViewAnimation(duration: 0.5) {
            microbe.center = Point(random01()*self.canvas.width,random01()*self.canvas.height)
        }
        randomMove.addCompletionObserver { () -> Void in
            randomMove.animate()
        }
        randomMove.animate()
    }


}

