//
//  Band.swift
//  06_C4
//
//  Created by Shin on 2016/03/22.
//  Copyright © 2016年 Shin. All rights reserved.
//

//import C4
import UIKit

public class Band: Rectangle {
    //We'll need access to the object's superview-canvas for the pan gesture
    var canvas: View!
    
    //Keeps track of the swipe gestures
    var swipes = [UISwipeGestureRecognizer]()
    
    //We need to enable / disable the rotation gesture, so we need a reference
    var rotationGesture: UIRotationGestureRecognizer?
    
    var rotationAnimation: ViewAnimation?
    
    let customColor: [Color] = [Color(red: 0.0/255.0, green: 160.0/255.0, blue: 233.0/255.0, alpha: 1.0),
                                Color(red: 0.0/255.0, green: 120.0/255.0, blue: 232.0/255.0, alpha: 1.0),
                                Color(red: 0.0/255.0, green: 197.0/255.0, blue: 232.0/255.0, alpha: 1.0)]
    
    //sound
    let deleteSound = AudioPlayer("delete.mp3")
    let createLineSound = AudioPlayer("createLine.mp3")
    
    public func setupIn(canvas: View) {
        //sets up the shape
        self.canvas = canvas
        strokeColor = C4Blue
//        strokeColor = Color(red: 0.0/233.0, green: 0.271, blue: 1.0, alpha: 1.0)
        var randInt = Int(arc4random_uniform(UInt32(customColor.count)))
        strokeColor = customColor[randInt]
        
        fillColor = C4Grey
        corner = Size()
        
        addGesture()
    }
    
    func addRotation() {
        //rotates the band
        rotationGesture = addRotationGestureRecognizer { rotation, velocity, state in
            switch state {
            case .Began:
                ShapeLayer.disableActions = true
            case .Changed:
                self.rotation = rotation
                if abs(velocity) >= 10 {
                    self.rotationGesture?.enabled = false
                    self.createRotationAnimation(velocity / 10.0)
                }
            case .Ended:
                ShapeLayer.disableActions = false
            default:
                _ = ""
            }
        }
    }
    
    func createRotationAnimation(multiplier: Double) {
        //animates a the rotation of the band
        ShapeLayer.disableActions = false
        let Θ = M_PI * 2.0 * (multiplier < 0.0 ? -1.0 : 1.0)
        
        let a = ViewAnimation(duration: 4.0 / abs(multiplier)) {
            self.rotation += Θ
        }
        a.repeats = true
        a.curve = .Linear
        a.animate()
    }
    
    func animateLine(line: Line, to target: Point) {
        //animates a given line
        let a = ViewAnimation(duration: 1.0) {
            line.center = target
        }
        a.repeats = true
        a.animate()
    }
    
    func addSwipes() {
        //Four swipes will add lines
        let w = 10.0
        let up = addSwipeGestureRecognizer { locations, center, state, direction in
            let points = (Point(0, self.height+w/2.0), Point(self.width, self.height+w/2.0))
            let line = self.createLine(points, w: w)
            self.add(line)
            self.animateLine(line, to: Point(line.center.x, -w/2.0))
        }
        up.direction = .Up
        
        let down = addSwipeGestureRecognizer { locations, center, state, direction in
            let points = (Point(0, -w/2.0), Point(self.width, -w/2.0))
            let line = self.createLine(points, w: w)
            self.add(line)
            self.animateLine(line, to: Point(line.center.x, self.height+w/2.0))
        }
        down.direction = .Down
        
        let left = addSwipeGestureRecognizer { locations, center, state, direction in
            let points = (Point(self.width+w/2.0, 0), Point(self.width+w/2.0, self.height))
            let line = self.createLine(points, w: w)
            self.add(line)
            self.animateLine(line, to: Point(-w/2.0, line.center.y))
        }
        left.direction = .Left
        
        let right = addSwipeGestureRecognizer { locations, center, state, direction in
            let points = (Point(-w/2.0, 0), Point(-w/2.0, self.height))
            let line = self.createLine(points, w: w)
            self.add(line)
            self.animateLine(line, to: Point(self.width+w/2.0, line.center.y))
        }
        swipes = [up, down, left, right]
    }
    
    func createLine(points: (Point, Point), w: Double) -> Line {
        //creates a new animatable line
        let line = Line(points)
        line.lineCap = .Butt
        line.interactionEnabled = false
        line.lineWidth = w - (Double)(arc4random_uniform(10))
//        line.strokeColor = C4Blue
        var randInt = Int(arc4random_uniform(UInt32(customColor.count)))
        line.strokeColor = customColor[randInt]
        
        createLineSound?.play()
        return line
    }
    
    func addTaps() {
        //triple tap to remove the object
        //double tap to toggle the background
        //single tap to toggle the border
        let tt = addTapGestureRecognizer { locations, center, state in
            let a = ViewAnimation(duration: 0.25) {
                self.transform.scale(0.1, 0.1)
                self.opacity = 0.0
                self.deleteSound?.play()
            }
            a.addCompletionObserver {
                self.removeFromSuperview()
            }
            a.animate()
        }
        
        let dt = addTapGestureRecognizer { locations, center, state in
            if self.fillColor?.alpha == 0.0 {
                self.fillColor = C4Grey
            } else {
                self.fillColor = clear
            }
        }
        
        let t = addTapGestureRecognizer { locations, center, state in
            if self.lineWidth > 0.0 {
                self.lineWidth = 0.0
            } else {
                self.lineWidth = 1.0
            }
        }
        tt.numberOfTapsRequired = 3
        dt.numberOfTapsRequired = 2
        
        dt.requireGestureRecognizerToFail(tt)
        t.requireGestureRecognizerToFail(dt)
    }
    
    func addPan() {
        //moves the shape around the canvas
        var dxdy = Vector()
        let lp = addLongPressGestureRecognizer { locations, center, state in
            switch state {
            case .Began:
                ShapeLayer.disableActions = true
                dxdy = Vector(center)
                self.strokeColor = C4Pink
            case .Changed:
                self.origin = self.canvas.convert(center, from: self) - dxdy
            case .Ended:
                self.strokeColor = C4Blue
                ShapeLayer.disableActions = false
            default:
                _ = ""
            }
        }
        lp.minimumPressDuration = 0.1
    }
    
    func addGesture(){
        addTaps()
        addPan()
        addSwipes()
        addRotation()
    }
}