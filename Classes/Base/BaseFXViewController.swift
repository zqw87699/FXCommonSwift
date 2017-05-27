//
//  BaseFXViewController.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/5/16.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation
import UIKit
import FXJsonSwift
import SnapKit
import FXRoutableSwift

let FXViewControllerTitleKey = "FXViewControllerTitleKey"

open class BaseFXViewController:UIViewController,IFXRoutableProtocol{
    
    var fxNavTitle:String?{
        didSet{
            if self.fxNavigationItem != nil {
                self.fxNavigationItem!.title = self.fxNavTitle;
            }
        }
    }

     var fxNavigationItem:UINavigationItem?
    
    var routerParams:Dictionary<String,Any>?
    
    @IBOutlet weak var fxNavigationBar:UINavigationBar?
    
    @IBOutlet weak var fxView:UIView?
    
    static public func fx_instance()->BaseFXViewController{
        var instance:BaseFXViewController?
        let className = NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!;
        let nibFile = Bundle.main.bundlePath.appending(String.init(format: "/%@.nib", className));
        
        let iphoneNibFile:String = Bundle.main.bundlePath.appending(String.init(format: "/%@~iphone.nib", className));
        let ipadNibFile:String = Bundle.main.bundlePath.appending(String.init(format: "/%@~ipad.nib", className));
        let fm = FileManager.default;
        if fm.fileExists(atPath: nibFile) || fm.fileExists(atPath: iphoneNibFile) || fm.fileExists(atPath: ipadNibFile) {
            let k = self.classForCoder() as! BaseFXViewController.Type
            instance = k.init(nibName: className, bundle: Bundle.main)
        }
        if instance == nil {
            let k = self.classForCoder() as! BaseFXViewController.Type;
            instance = k.init();
        }
        return instance!;
    }
    
    public required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.fx_vcInit();
    }
    
    open func fx_vcInit(){
        let a = self.fx_viewModels()
        if a != nil {
            for proName in a! {
                let clazz = FXJsonUtiles.getClassWithClassName(FXJsonUtiles.getPropertyTypeNameByPropertyName(proName, type(of: self))!) as! NSObject.Type
                let value = clazz.init();
                self.setValue(value, forKey: proName);
            }
        }
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }
    
    open func fx_viewModels()->Array<String>?{
        return nil
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.fx_vcInit()
    }

    open func customNavigationBar()->Bool {
        return true;
    }

    open func fxPopIcon()->String{
        return "BaseFXBundle.bundle/Images/returnArrow.png"
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }

    public func fx_customNavigationBar() {
        if self.customNavigationBar() {
            if self.fxNavigationBar == nil {
                let bar = UINavigationBar.init()
                let item = UINavigationItem.init(title: self.fxNavTitle ?? "")
                self.fxNavigationItem = item
                bar.items = Array.init(arrayLiteral: item)
                if self.navigationController != nil && (self.navigationController?.viewControllers.count)! > 1 {
                    let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
                    negativeSpacer.width = -2.0
                    let icon = UIImage.init(named: self.fxPopIcon())?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                    let backItem = UIBarButtonItem.init(image: icon, style: UIBarButtonItemStyle.plain, target: self, action: Selector.init(fxPopIcon()))
                    self.fxNavigationItem?.leftBarButtonItems = [negativeSpacer,backItem]
                }
                self.view.addSubview(bar)
                weak var selfObject = self
                bar.snp.makeConstraints({ (make) in
                    if selfObject != nil {
                        make.left.equalTo(selfObject!.view.snp.left)
                        make.right.equalTo(selfObject!.view.snp.right)
                        make.top.equalTo(selfObject!.view.snp.top)
                        make.height.equalTo(64)
                    }
                })
                self.fxNavigationBar = bar
            }
            if self.fxView != nil {
                let v = UIView.init()
                self.view.insertSubview(v, at: 0)
                weak var selfObject = self
                v.snp.makeConstraints({ (make) in
                    if selfObject != nil {
                        let edgeInsets = UIEdgeInsetsMake(((self.edgesForExtendedLayout.rawValue & UIRectEdge.top.rawValue)>0) ? 0: 64, 0, 0, 0)
                        make.edges.equalTo(selfObject!.view).inset(edgeInsets)
                    }
                })
                self.fxView = v
            }
        }else{
            self.fxView = self.view
        }
        self.fxView?.backgroundColor = UIColor.white
    }

    open func fx_popReturn() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad();
        self.automaticallyAdjustsScrollViewInsets = false
        self.fx_customNavigationBar()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController != nil {
            self.navigationController?.setNeedsStatusBarAppearanceUpdate()
        }else{
            self.setNeedsStatusBarAppearanceUpdate()
        }
        if self.fx_viewModels() != nil {
            for proName in self.fx_viewModels()! {
                let viewModel = self.value(forKey: proName) as! BaseFXViewModel
                viewModel.fx_modelWillAppear()
            }
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.fx_viewModels() != nil {
            for proName in self.fx_viewModels()! {
                let viewModel = self.value(forKey: proName) as! BaseFXViewModel
                viewModel.fx_modelDidAppear()
            }
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.fx_viewModels() != nil {
            for proName in self.fx_viewModels()! {
                let viewModel = self.value(forKey: proName) as! BaseFXViewModel
                viewModel.fx_modelWillDisappear()
            }
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.fx_viewModels() != nil {
            for proName in self.fx_viewModels()! {
                let viewModel = self.value(forKey: proName) as! BaseFXViewModel
                viewModel.fx_modelDidDisappear()
            }
        }
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        if self.isViewLoaded && self.view.window == nil {
            self.view = nil
        }
        if self.fx_viewModels() != nil {
            for proName in self.fx_viewModels()! {
                let viewModel = self.value(forKey: proName) as! BaseFXViewModel
                viewModel.fx_modelDidReceiveMemoryWarning()
            }
        }
    }

    open static func initWithUrl(_ URL: String, _ params: Dictionary<String, Any>) -> Any {
        let k = self.classForCoder() as! BaseFXViewController.Type;
        let controller = k.init()
        controller.routerParams = params
        return controller
    }
}
