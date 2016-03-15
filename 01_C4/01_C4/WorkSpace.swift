//
//  WorkSpace.swift
//  01_C4
//
//  Created by Shin on 2016/03/15.
//  Copyright © 2016年 Shin. All rights reserved.
//

import UIKit

class WorkSpace: CanvasController {

    override func setup() {
        //円を描く
//        let circle = Circle(center: canvas.center, radius: 50)
//        canvas.add(circle)
        
        //------------------------------------------------------------
        //背景が白->黒にグラデする
//        let a = ViewAnimation(duration: 1.0){
//            self.canvas.backgroundColor = black
//        }
//        a.autoreverses = true;
//        a.animate()
//        a.repeats = true
        
        //------------------------------------------------------------
        //親要素のアニメーションを継承しながら子要素がアニメーションする->レイヤーはC4において大事な概念だよ的な
//        let c = Circle(center: canvas.center, radius: 50)
//        c.fillColor = clear
//        
//        let sc = Circle(center: Point(), radius: 10)
//        c.add(sc)
//        
//        let a = ViewAnimation(duration: 2.0) {
//            sc.center = c.bounds.max //max: レシーバーの右下の点の位置を返す
//            c.rotation = 2*M_PI //M_PI: PIを返す
//        }
//        a.autoreverses = true
//        a.repeats = true
//        a.animate()
//        
//        canvas.add(c)
        
        //------------------------------------------------------------
        //塗りつぶしてる色が青->赤に変わるアニメーション、なぜ青なのかは謎、、
//        let circle = Circle(center: Point(20, 20), radius: 20)
//        let a = ViewAnimation(duration: 1.0) {
//            circle.fillColor = red
//        }
//        canvas.add(circle)
//        a.animate()
        
        //------------------------------------------------------------
        //長方形をピンクと青のグラデーションで描画するだけ
        let g = Gradient(frame: Rect(0,0,40,200)) //frame: 囲むもの、枠みたいな
        g.colors = [C4Pink, C4Blue] //[始点側の色, 終点側の色]、デフォルトでframeの上から下にグラデするようになってる
//        g.endPoint = Point(1, 1) //グラデを書きたかったら、startPointかendPointを指定してあげる。左上(0, 0)右下(1, 1)という感じ
        g.center = canvas.center
        canvas.add(g)

    }
}

