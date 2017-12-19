//
//  pageTitleView.swift
//  斗鱼直播
//
//  Created by schindler name on 2017/12/14.
//  Copyright © 2017年 hrx. All rights reserved.
//

import UIKit

// MARK:- 定义一个协议 -代理
protocol PageTitleViewDelegate : class {
    func pageTitleViewIndex(titleView:PageTitleView, selectedIndex index:Int)
}

private let kScrollLineH : CGFloat  = 2
//未选中颜色
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
//选中颜色
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,128,0)

class PageTitleView: UIView {
    
    // MARK:- 定义属性
    private var titles : [String]
    weak var delegate : PageTitleViewDelegate?
    //选中下标值
    private var currentIndex = 0
    // MARK:- 设置懒加载属性
    private lazy var titleLabels : [UILabel] = [UILabel]()
    private lazy var scrollView :UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator=false
        scrollView.scrollsToTop=false
        scrollView.bounces=false
        return scrollView
    }()
    //滑块
    private lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor=UIColor.orange
        return scrollLine
    }()
    //自定义构造函数
    init(frame: CGRect, titles: [String]){
        self.titles=titles
        super.init(frame:frame)
        //设置ui界面
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
// MARK:- 设置UI
extension PageTitleView {
    //设置UIsccrollview
    private func setupUI(){
        //添加scrollview
        addSubview(scrollView)
        scrollView.frame=bounds
        //添加label
        setupTitleLabels()
        //添加滚动滑块
        setupBottomLineAndScrollLine()
        
    }
    // MARK:- 添加label
    private func setupTitleLabels(){
        //设置labelframe
        let labelW :CGFloat = frame.width / CGFloat(titles.count)
        let labelH :CGFloat = frame.height - kScrollLineH
        let labelY :CGFloat = 0
        for (index,title) in titles.enumerated(){
            //创建uilabel
            let label=UILabel()
            //设置label属性
            label.text=title
            label.tag=index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor=UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            //设置label的frame
            let labelX :CGFloat = labelW * CGFloat(index)
            label.frame=CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            //讲label添加到scrollview中
            scrollView.addSubview(label)
            titleLabels.append(label)
            //添加label手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    // MARK:- 设置添加滑块
    private func setupBottomLineAndScrollLine(){
        //添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor=UIColor.lightGray
        let lineH :CGFloat = 0.5
        bottomLine.frame=CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        scrollView.addSubview(bottomLine)
        //添加滑块到scroll
        guard let firstLabel = titleLabels.first else{ return }
        firstLabel.textColor=UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        scrollView.addSubview(scrollLine)
        scrollLine.frame=CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}
// MARK:- 监听label点击
extension PageTitleView {
    @objc private func titleLabelClick(tapGes : UITapGestureRecognizer){
        //获取当前点击的label
        guard let currentLabel = tapGes.view as? UILabel else{ return }
        //获取之前label
        let oldLabel = titleLabels[currentIndex]
        //交换颜色 选中状态
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        //保存选中下标
        currentIndex = currentLabel.tag
        //滚动条处理
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.2, animations:{self.scrollLine.frame.origin.x=scrollLineX})
        //通知代理 处理pagecontentview做事情
        delegate?.pageTitleViewIndex(titleView: self, selectedIndex: currentIndex)
    }
}
// MARK:- 对外暴露的方法 用于接收pagecontentview的参数
extension PageTitleView {
    func setTitleWithProgress(progress: CGFloat,sourceIndex: Int, targetIndex: Int){
        //取出sourcelabel(来源)和targetlabel(目标)
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        //滑块滑动处理
        //总共滑动距离
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        //现滑动距离
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        //颜色渐变
        //颜色变化范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        //记录最新的index
        currentIndex = targetIndex
    }
}
