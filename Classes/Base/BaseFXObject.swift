//
//  BaseFXObject.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/5/16.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation
import FXJsonSwift

open class BaseFXObject:NSObject,NSCopying,NSCoding{
    
    override init() {
        super.init()
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let object = type(of: self).initFXJsonDictionary(dictionary: self.fxDictionary())
        return object
    }
    
    public func encode(with aCoder: NSCoder) {
        let allPropertys = FXJsonUtiles.getPropertys(type(of: self))
        if allPropertys != nil {
            for object:FXJsonObject in allPropertys! {
                 aCoder.encode(self.value(forKey: object.name), forKey: object.name);
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        let allPropertys = FXJsonUtiles.getPropertys(type(of: self))
        if allPropertys != nil {
            for object in allPropertys! {
                let value = aDecoder.decodeObject(forKey: object.name)
                if value != nil {
                    self.setValue(value, forKey: object.name)
                }
            }
        }
    }
    
    open override var description: String{
        var str = String.init()
        let allPropertys = FXJsonUtiles.getPropertys(type(of: self))
        if allPropertys != nil {
            str.append("(")
            for object in allPropertys! {
                let value = self.value(forKey: object.name)
                if value != nil {
                    str = str.appendingFormat("%@:%@,", object.name,value as! CVarArg)
                }
            }
            str.append(")")
        }
        return String.init(format: "%@:%@",NSStringFromClass(type(of: self)),str)
    }
}
