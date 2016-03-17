//
//  WorkSpace.swift
//  03_C4
//
//  Created by Shin on 2016/03/17.
//  Copyright © 2016年 Shin. All rights reserved.
//

import UIKit

class WorkSpace: CanvasController {
    
    var gradients = [Gradient]() //
    var timer: Timer!

    override func setup() {
        //------------------------------------------
        //一つだけがアニメーションする。（一つしか生成してないから）
//        let g = createGradient(canvas.center)
//        createAnimation(g)
        
        //------------------------------------------
        
        //while文回して要素追加
        var x = 2.0
        repeat{
            gradients.append(createGradient(Point(x, canvas.center.y))) //appendで配列に要素を追加
            x += 3.0
        }while x < canvas.width
        
        //要素の数分それぞれに対してアニメーションさせる。その際にintervalでズラすことで面白いsin波みたいなのができる
        timer = Timer(interval: 0.01, count: gradients.count){ ()->() in
            let g = self.gradients[self.timer.step]
            self.createAnimation(g)
        }
        timer.start()
    }
    
    //グラデーションを作る関数
    func createGradient(point: Point) -> Gradient {
        var colors = [C4Blue,C4Pink]
        
        if random(below: 2) == 1 {
            colors = [C4Pink,C4Blue] //ランダムにグラデーションを反転させてる
        }
        
        let g = Gradient(frame: Rect(0,0,2,2))
        g.colors = colors
        g.center = point
        g.transform.rotate(M_PI_4) //(デフォルトで)Z軸を基準にラジアン分回転させてる
        canvas.add(g)
        return g
    }
    
    //アニメーションを作る関数
    func createAnimation(g: Gradient) {
        let anim = ViewAnimation(duration: 2.0) {
            //引数で受け取ったグラデオブジェクトを一旦変数に格納
            var f = g.frame
            let c = g.center
            
            //さっきの変数をアニメーションさせて、元のオブジェクトに格納することで適用される
            f.height = 100
            f.center = c
            g.frame = f
        }
        anim.curve = .EaseInOut
        anim.autoreverses = true
        anim.repeats = true
        anim.animate()
    }

}

