//
//  WorkSpace.swift
//  05_C4
//
//  Created by Shin on 2016/03/18.
//  Copyright © 2016年 Shin. All rights reserved.
//

import UIKit

class WorkSpace: CanvasController {
    
    var petris = [Circle]()

    override func setup() {
//        let microbe = createMicrobe(canvas.center)
//        randomMove(microbe)
//        canvas.add(microbe)
        createPetris()
        
        //ジェスチャー追加
        canvas.addPanGestureRecognizer { (locations, center, translation, velocity, state) -> () in
            ShapeLayer.disableActions = true
            let microbe = self.createMicrobe(center)
            self.canvas.add(microbe)
            
//            self.randomMove(microbe)
//            self.fade(microbe)
            let petri = self.petris[random(below: self.petris.count)]
            self.moveToCenter(microbe, ofPetri: petri)
            
            ShapeLayer.disableActions = false
        }
    }
    
    func createMicrobe(center: Point) -> Circle {
        let microbe = Circle(center: center, radius: 2)
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
//        let randomMove = ViewAnimation(duration: 0.5) {
//            microbe.center = Point(random01()*self.canvas.width,random01()*self.canvas.height)
//        }
//        randomMove.addCompletionObserver { () -> Void in
//            randomMove.animate()
//        }
//        randomMove.animate()
        
        let anim = ViewAnimation(duration: random01() + 2.0){ () -> Void in
            let theta = random01() * 2 * M_PI
            let r = 50 * random01()
            let c = Point(r * cos(theta), r * sin(theta)) + Vector(self.canvas.center)
            microbe.center = c
        }
        anim.delay = random01()
        anim.addCompletionObserver{ () ->  Void in
            self.randomMove(microbe)
        }
        anim.animate()
    }
    
    func fade(microbe: Circle) {
        let a = ViewAnimation(duration: 0.25) {
            microbe.opacity = 0.0
        }
        a.addCompletionObserver { () -> Void in
            microbe.removeFromSuperview()
        }
        a.delay = random01() * 5 + 3
        a.animate()
    }

    func moveToCenter(microbe: Circle, ofPetri petri: Circle){
        let a = ViewAnimation(duration: random01() * 0.5 + 0.5){ () -> Void in
            microbe.center = self.canvas.center
        }
        a.addCompletionObserver(){ () -> Void in
            microbe.removeFromSuperview()
            microbe.center = petri.bounds.center
            petri.add(microbe)
            self.randomMove(microbe)
            self.fade(microbe)
        }
        a.delay = random01() * 2
        a.animate()
    }
    
    func createPetris() {
        let r = 150.0
        for _ in 0...5 {
            let petri = Circle(center: canvas.center, radius: r)
            petri.fillColor = clear
            petri.strokeColor = clear
            petri.interactionEnabled = false
            randomRotate(petri)
            petris.append(petri)
            canvas.add(petri)
        }
    }
    
    func randomRotate(petri: Circle) {
        let anim = ViewAnimation(duration: random01() * 5 + 2.0) { () -> Void in
            let θ = random01() * M_PI
            let d = round(random01()) == 0 ? -1.0 : 1.0
            petri.transform.rotate(θ * d)
        }
        anim.delay = random01()
        anim.addCompletionObserver { () -> Void in
            self.randomRotate(petri)
        }
        anim.animate()
    }
}

