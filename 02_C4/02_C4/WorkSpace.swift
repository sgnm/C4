//
//  WorkSpace.swift
//  02_C4
//
//  Created by Shin on 2016/03/17.
//  Copyright © 2016年 Shin. All rights reserved.
//

import UIKit

class WorkSpace: CanvasController {
    
    var timer: Timer!

    override func setup() {
        //----------------------------------------
        //0.25秒おきにログを出力
//        timer = Timer(interval: 0.25){
//            print("hello C4")
//        }
//        timer.start()
        //----------------------------------------
 
        //----------------------------------------
        //Timerが何回呼ばれたかが見れる(最初は0が出力されるが事実上1回目である)
//        timer = Timer(interval: 1){
//            print("hello C4 \(self.timer.step)") //1sおき
//        }
//        timer.start()
        //----------------------------------------
        
        //----------------------------------------
        //count: 2とすることで、2回呼ばれた後にTimerが停止する。
//        timer = Timer(interval: 1, count: 2){
//            print("hello C4 \(self.timer.step)")
//        }
//        timer.start()
        //----------------------------------------
    }


}

