//
//  HomeViewController.swift
//  斗鱼直播
//
//  Created by schindler name on 2017/12/14.
//  Copyright © 2017年 hrx. All rights reserved.
//

import UIKit

//标题高度
private let kTitleViewH:CGFloat = 40

class HomeViewController: UIViewController {
    // MARK:- 懒加载属性
    private lazy var pageTitleView : PageTitleView={ [weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusH + kNavigationBarH, width: kWidth, height: kTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame,titles:titles)
        titleView.delegate = self
        return titleView
    }()
    private lazy var pageContentView :PageContentView = {[weak self] in
        //确定frame
        let contentH = kHeight-kStatusH-kNavigationBarH-kTitleViewH-kTabbarH
        let contentFrame = CGRect(x: 0, y: kStatusH+kNavigationBarH+kTitleViewH, width: kWidth, height: contentH)
        //创建子控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parenViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    //系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }

}
// MARK:- 设置ui
extension HomeViewController{
    private func setUI(){
        //不要内边距 原automaticallyAdjustsScrollViewInsets被弃用改用scrollView.contentInsetAdjustmentBehavior = .never

        setNavigationBar()
        //添加titleview
        view.addSubview(pageTitleView)
        //添加CtentView
        view.addSubview(pageContentView)
    }
    ///设置导航
    private func setNavigationBar(){
        //首页logo图标按钮
        navigationItem.leftBarButtonItem=UIBarButtonItem(imageName: "logo")
        //设置右边按钮
        //历史
        let size=CGSize(width: 40, height: 40)
        let historyItem=UIBarButtonItem(imageName: "image_my_history", endImageName: "Image_my_history_click", Size: size)
        //搜索
        let seachItem=UIBarButtonItem(imageName: "btn_search", endImageName: "btn_search_clicked", Size: size)
        //二维码
        let qrcodeItem=UIBarButtonItem(imageName: "Image_scan", endImageName: "Image_scan_click", Size: size)
        navigationItem.rightBarButtonItems=[historyItem,seachItem,qrcodeItem]
    }
}
// MARK:- 遵守pagetitleviewdelegate协议
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleViewIndex(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}
// MARK:- 遵守pagecontentviewdelegate协议
extension HomeViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
