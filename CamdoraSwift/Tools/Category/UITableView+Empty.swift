//
//  UITableView+Empty.swift
//  CamdoraSwift
//
//  Created by user on 27/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import MJRefresh

class DFList : NSObject {
    var isLoading : Bool = false
    var nextExist : Bool = true
    var emptyTip : String = "无数据"
    var emptyImageName : String? = nil
    var currentImageName : String = "===="
    var tapCallback : (()->Void)?
    
    func networkStatus (error : Error?) {
        isLoading = false
        guard let _ = error else {
            emptyTip = "无数据"
            currentImageName = emptyImageName ?? ""
            return
        }
    
        currentImageName = emptyImageName ?? ""
    }
}


struct RuntimeKey {
    static let tableKey = UnsafeRawPointer.init(bitPattern: "DFList".hashValue)
}
extension UITableView : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var list : DFList {
        set {
            objc_setAssociatedObject(self, RuntimeKey.tableKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            let list1 = objc_getAssociatedObject(self, RuntimeKey.tableKey!) as? DFList
            if let list1 = list1 {
                return list1
            }
            let tempList = DFList()
            self.list = tempList
            return tempList
        }
    }
    
    /**功能：设置没数据时的提示
     * @param emptyTip 提示语
     * return void
     */
    func setEmptyString (emptyTip : String) {
        list.emptyTip = emptyTip
    }
    
    /**功能：设置是否加载
     * @param isLoading  YES 正在加载， NO 停止加载
     * return void
     */
    func setLoading (isLoading : Bool) {
        list.isLoading = isLoading
    }
    
    /**功能：设置是否有更多数据
     * @param nextExist  YES 有下一页
     * return void
     */
    func setNextExist (nextExist : Bool) {
        list.nextExist = nextExist
    }
    
    /**功能：添加下拉刷新
     * @param callback head回调
     * return void
     */
    func addHeaderCallback (callback : @escaping ()->(Void)) {
        self.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            callback()
        })
    }
    /**功能：添加上拉刷新
     * @param callback foot回调
     * return void
     */
    func addFooterCallback (callback : @escaping ()->(Void)) {
        self.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            callback()
        })
    }
    
    /**功能：添加无数据显示
     * @param callback 无数据点击回调
     * return void
     */
    func addEmptyCallback (callback : (()->Void)?) {
        self.emptyDataSetSource = self
        self.emptyDataSetDelegate = self
        list.tapCallback = callback
        print(list.tapCallback ?? "======")
    }
    
    /**功能：无数据刷新
     * return void
     */
    func emptyReloadData () {
        self.reloadEmptyDataSet()
    }
    
    /**功能：头部刷新
     * return void
     */
    func headRefresh () {
        self.mj_header.beginRefreshing()
    };
    
    /**功能：请求成功后调用
     * @param noMoreData YES 设置没有更多数据
     * return void
     */
    func successReload(noMoreData : Bool = false) {
        if noMoreData {
            self.mj_footer.endRefreshingWithNoMoreData()
        } else {
            self.mj_footer.resetNoMoreData()
        }
        self.endRefresh()
        list.networkStatus(error: nil)
    }
    
    /**功能：请求失败后调用
     * return void
     */
    func failedReload (error : Error? = nil) {
        self.endRefresh()
        list.networkStatus(error: error)
    }
    
    private func endRefresh () {
        if self.mj_header.isRefreshing {
            self.mj_header.endRefreshing()
        }
        
        if self.mj_footer.isRefreshing {
            self.mj_footer.endRefreshing()
        }
    }
    
}

extension UITableView {
    //垂直偏移量
    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -50.0
    }
    
    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20.0
    }
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage.init(named: list.currentImageName)
    }
    
    public func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let anima = CABasicAnimation.init(keyPath: "transform.rotation")
        anima.toValue = Double.pi * 2
        anima.duration = 1.0
        anima.repeatCount = Float(MAX_CANON)
        return anima
    }
    
    public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return list.isLoading
    }
    
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        
        return NSAttributedString.init(string: list.emptyTip)
    }
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        if list.isLoading {
            return
        }
        list.isLoading = true
        self.emptyReloadData()
        if let callback = list.tapCallback {
            callback()
        }
    }
}



