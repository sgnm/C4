//
//  WorkSpace.swift
//  06_C4
//
//  Created by Shin on 2016/03/22.
//  Copyright © 2016年 Shin. All rights reserved.
//

import UIKit

class WorkSpace: CanvasController {
    
    //The object that will reccord the screen
    var recorder = ScreenRecorder()
    //The gesture to initiate recording, we need a reference to enable / disable dynamically
    var startRecording: UILongPressGestureRecognizer?
    
    override func setup() {
        //initializes the app
        canvasLongPress()
    }
    
    func createBand(center: Point, displacement: Vector) -> Band {
        //creates a band
        let w = max(abs(displacement.x), 8.0) * 2
        let h = max(abs(displacement.y), 8.0) * 2
        let f = Rect(center.x-w/2.0, center.y-h/2.0, w, h)
        let band = Band(frame: f)
        band.setupIn(self.canvas) //インスタンス生成して、init処理してる
        return band
    }
    
    func canvasLongPress() {
        //adds a longpress gesture to create a band
        var currentBand: Band?
        var position = Point()
        canvas.addLongPressGestureRecognizer { (locations, center, state) -> () in
            switch state {
            case .Began:
                ShapeLayer.disableActions = true
                position = center
                currentBand = self.createBand(position, displacement: Vector())
                self.canvas.add(currentBand)
            case .Changed:
                let dxdy = Vector(center) - Vector(position)
                let newBand = self.createBand(position, displacement: dxdy)
                currentBand?.removeFromSuperview()
                currentBand = newBand
                self.canvas.add(currentBand)
            case .Ended:
                ShapeLayer.disableActions = false
            default:
                _ = ""
            }
        }
    }
    
    func canvasStartRecording() {
        //adds a longpress gesture to start recording
    }


}

