//
//  BaseFXView.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/5/9.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation
import UIKit

open class BaseFXView:UIView{
    
    open func fx_loadView(){
        
    }
    
    override public init(frame: CGRect){
        super.init(frame: frame);
        self.fx_loadView();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.fx_loadView();
    }

    static public func fx_instance()->BaseFXView{
        var instance:BaseFXView?
        let className = NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!;
        let nibFile = Bundle.main.bundlePath.appending(String.init(format: "/%@.nib", className));
        
        let iphoneNibFile:String = Bundle.main.bundlePath.appending(String.init(format: "/%@~iphone.nib", className));
        let ipadNibFile:String = Bundle.main.bundlePath.appending(String.init(format: "/%@~ipad.nib", className));
        let fm = FileManager.default;
        if fm.fileExists(atPath: nibFile) || fm.fileExists(atPath: iphoneNibFile) || fm.fileExists(atPath: ipadNibFile) {
            let o = Bundle.main.loadNibNamed(className, owner: nil, options: nil)?.last as! BaseFXView;
            if o.isKind(of: self.classForCoder()) {
                instance = o;
            }
        }
        if instance == nil {
            let k = self.classForCoder() as! BaseFXView.Type;
            instance = k.init();
        }
        return instance!;
    }
}
