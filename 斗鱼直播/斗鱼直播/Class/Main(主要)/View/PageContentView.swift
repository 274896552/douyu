//
//  PageContentView.swift
//  斗鱼直播
//
//  Created by schindler name on 2017/12/15.
//  Copyright © 2017年 hrx. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

private let ContentCellID = "ContentCellID"

class PageContentView: UIView {

    // MARK:- 定义属性
    private var childVcs :[UIViewController]
    private weak var parenViewController: UIViewController?
    private var statusOffsetX : CGFloat = 0
    weak  var delegate : PageContentViewDelegate?
    private var isForbidScollDelegate : Bool = false
    // MARK:- 懒加载属性
    private lazy var collectionView :UICollectionView = {[weak self] in
        //创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        //创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        //关闭水平滑动指示器
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        return collectionView
    }()
    // MARK:- 自定义构造函数
    init(frame: CGRect, childVcs:[UIViewController], parenViewController: UIViewController?) {
        self.childVcs=childVcs
        self.parenViewController=parenViewController
        super.init(frame: frame)
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK:- 设置UI界面
extension PageContentView {
    
    private func setupUI(){
        //将所有子控制器加载到父控制器中
        for childvc in childVcs {
            parenViewController?.addChildViewController(childvc)
        }
        //添加uicollectionview 用于在cell中存放控制器的ciew
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}
// MARK:- 遵守UICollectionViewDataSource协议
extension PageContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        //给cell设置内容
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}
// MARK:- 遵守uicollectionviewdelegate协议 滑动
extension PageContentView : UICollectionViewDelegate{
    //开始拖拽方法
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScollDelegate = false
        statusOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForbidScollDelegate { return }
        //定义获取的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > statusOffsetX {//左滑
            //计算滑动进度
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            //计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            //计算targetIndex
            targetIndex = Int(sourceIndex + 1)
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
            if currentOffsetX - statusOffsetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{
            //计算滑动进度
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count{
                sourceIndex = childVcs.count - 1
            }
        }
        //计算完毕 通知titleview做同样处理(滑动)
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
// MARK:- 对外暴露的方法
extension PageContentView {
    //接收外部传进来的title点击参数
    func setCurrentIndex(currentIndex: Int){
        isForbidScollDelegate = true
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
