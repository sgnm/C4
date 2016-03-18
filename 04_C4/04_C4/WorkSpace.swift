//
//  WorkSpace.swift
//  04_C4
//
//  Created by Shin on 2016/03/18.
//  Copyright © 2016年 Shin. All rights reserved.
//

import UIKit

class WorkSpace: CanvasController {
    
    var previous: Shape!
    
    //shapeの配列を作ってそれぞれをアニメーションさせる *1
    var shapes = [Shape]() //shapeの配列を用意
    var timer: Timer!

    override func setup() {
        //-------------------------------------------------------------------------------
        //円を20個生成、アンカーポイント等や遅延時間をそれぞれ指定してあげることでオブジェクト毎にアニメーションずらす基本的な
//        for i in 1...20 {
//            let s = Circle(center: canvas.center, radius: Double(50 - i * 2))
//            s.anchorPoint = Point(0.5, 1.0)
//            s.center = canvas.center
//            s.lineWidth = 0
//            
//            if i % 2 == 0 {
//                s.fillColor = C4Pink
//            }
//            
//            canvas.add(s)
//            
////            basicRotate(s) //回転の基礎。全体がまとまって回転する
//            delayRotate(s, delayTime: 0.25 * Double(i)) //それぞれの要素が0.25*i分遅れて回転するので、チューチュートレインみたいになる
//        }
        //-------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------
        //直前のShapeを参照することで数珠繋がり的なことができるよみたいな（上はcanvasに20個追加してみたいな感じだけど概念が違う）
//        for i in 1...20 {
//            let s = Circle(center: canvas.center, radius: Double(50 - i * 2))
//            s.anchorPoint = Point(0.5, 1.0)
//            s.lineWidth = 0
//            
//            if i % 2 == 0 {
//                s.fillColor = C4Pink
//            }
//            
//            if i == 1 {
//                s.center = canvas.center
//                canvas.add(s) //最初の1つだけはcanvasに追加する
//            } else {
//                s.center = previous.bounds.center //centerを直前のやつの中心にすることで、アンカーポイントが影響して、直前の中心にセットされるので数珠繋がりになってるみたいな
//                previous.add(s) //2つ目以降は、直前のオブジェクトを参照してそれに追加してく感じ
//            }
//            
//            previous = s
////            basicRotate(s)
//            delayRotate(s, delayTime: 0.25 * Double(i))
//        }
        //-------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------
        //shapesの配列にs(shape)を格納して、animate()で配列の要素取得してそれぞれにランダムアニメーションさせてるみたいな *1
        for i in 1...20 {
            let s = Circle(center: canvas.center, radius: Double(50 - i * 2))
            s.anchorPoint = Point(0.5, 1.0)
            s.lineWidth = 0
            
            if i == 1 {
                s.center = canvas.center
                canvas.add(s)
            } else {
                s.center = previous.bounds.center
                previous.add(s)
            }
            previous = s
            
            if i % 2 == 0 {
                s.fillColor = C4Pink
            }
            shapes.append(s)
        }
        
        timer = Timer(interval: 1.0) {
            self.animate()
        }
        timer.fire()
        timer.start()
        //-------------------------------------------------------------------------------
    }
    
    func basicRotate(shape: Shape) {
        let a = ViewAnimation(duration: 5.0) {
//            shape.rotation = M_PI //0~πまで1sかけて変化するがそこで終わってしまう
            shape.rotation += M_PI //+=としてあげると、下でもう一度animate()が呼ばれて、繰り返されるのでどんどん足されていく感じ
        }
        a.addCompletionObserver {
            a.animate() //アニメーションが完了した時の処理
        }
        a.animate()
    }
    
    func delayRotate(shape: Shape, delayTime: Double){
        let a = ViewAnimation(duration: 5.0){
            shape.rotation += M_PI
        }
        a.addCompletionObserver{
            a.delay = 0.0 //delayを0.0に戻してあげないと呼ばれるたびにどんどん遅延してしまう。
            a.animate()
        }
        a.delay = delayTime
        a.animate()
    }
    
    func animate() {
        for s in shapes {
            ViewAnimation(duration: random01() * 0.75 + 0.25) {
                let dir = random(below: 2) == 1 ? 1.0 : -1.0
                let angle = random01() * M_PI_4
                s.rotation += angle * dir
                }.animate()
        }
    }
}

