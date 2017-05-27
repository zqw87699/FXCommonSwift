//
//  BaseFXNavigationController.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/5/9.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation
import UIKit

open class BaseFXNavigationController:UINavigationController{
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return (self.topViewController?.preferredStatusBarStyle)!;
    }

    override open func viewDidLoad() {
        super.viewDidLoad();
        self.setNavigationBarHidden(true, animated: false);
    }
    
    override open func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
        if self.isViewLoaded && self.view.window == nil {
            self.view = nil;
        }
    }
    
    override open var shouldAutorotate: Bool{
        return false;
    }
}
