//
//  BaseFXHttpAPI.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/4/17.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation
import FXJsonSwift
import Alamofire
import FXHttpEngineSwift

open class BaseFXHttpRequest:NSObject,IFXHttpRequest{
    
    open func getUrl() -> String{
        return ""
    }
    
    open func validateParams() -> Bool {
        return true
    }
    
    open func getHeaders() -> Dictionary<String, String>? {
        return nil
    }
    
    open func getParams() -> Dictionary<String, Any>? {
        return nil
    }
    
    open func getMethod() -> HTTPMethod {
        return HTTPMethod.post
    }
    
    open func getTimeoutDuration() -> CLong {
        return 0
    }
    
    open func getUploadFiles() -> Dictionary<String, IFXUploadFileInfo>? {
        return nil
    }
}

open class BaseFXHttpResponse:NSObject,IFXHttpResponse{
    open class func parseResult(_ responseData: Data) -> IFXHttpResponse {
        var res:BaseFXHttpResponse
        print(String.init(data: responseData, encoding: String.Encoding.utf8) ?? "");
        do {
            res = try FXJsonUtiles.fromJsonData(json: responseData, Class: self) as! BaseFXHttpResponse;
        } catch{
            res = BaseFXHttpResponse.init()
        }
        return res
    }
    
    open func isError() -> Bool {
        return false
    }

    open func errorCode() -> String? {
        return nil
    }

    open func errorMsg() -> String? {
        return nil
    }
}
