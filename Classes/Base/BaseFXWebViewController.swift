//
//  BaseFXWebViewController.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/5/17.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation
import FXRoutableSwift

open class BaseFXWebViewController:BaseFXViewController,IFXWebRoutableProtocol{
    
    open static func canOpenURL(_ URL: String) -> Bool {
        return true
    }
}
