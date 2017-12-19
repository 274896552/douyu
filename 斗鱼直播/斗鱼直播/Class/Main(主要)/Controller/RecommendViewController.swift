//
//  RecommendViewController.swift
//  斗鱼直播
//
//  Created by schindler name on 2017/12/18.
//  Copyright © 2017年 hrx. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10
private let kItemW = (kWidth - 3 * kItemMargin) / 2
private let kItemH = kItemW * 3 / 4
private let kPrettyItemH = kItemW * 4 / 3
private let kHeaderViewH : CGFloat = 50
private let kHeaderViewID = "kHeaderViewID"
//普通sellID
private let kNormacellID = "kNormacellID"
//颜值sellID
private let kPrettycellID = "kPrettycellID"
class RecommendViewController: UIViewController {
    // MARK:- 懒加载属性 也就是collection view
    private lazy var collectionView: UICollectionView = { [unowned self] in
        //uicollectionview 得先创建布局 所以这里第一步先创建布局
        //流水布局
        let layout = UICollectionViewFlowLayout()
        //设置高宽
        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        //行间距
        layout.minimumLineSpacing = 0
        //设置layout内边距
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        //item间距
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kWidth, height: kHeaderViewH)
        //创建uicollectionview
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName:"CollectionNurmalCell",bundle:nil), forCellWithReuseIdentifier: kNormacellID)
        collectionView.register(UINib(nibName:"CollectionPrettyCell",bundle:nil), forCellWithReuseIdentifier: kPrettycellID)
        collectionView.register(UINib(nibName:"CollectionReusableView",bundle:nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

}
// MARK:- 设置ui
extension RecommendViewController {
    //设置ui
    private func setupUI(){
        //将collectionview添加到uiview中
        view.addSubview(collectionView)
    }
}
// MARK:- 遵守uicollectionview数据源协议
extension RecommendViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //设置一共有多少组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    //设置每组有多少条数据
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        return 4
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取cell
        let cell : UICollectionViewCell!
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettycellID, for: indexPath)
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormacellID, for: indexPath)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath)
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1{
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        return CGSize(width: kItemW, height: kItemH)
    }
}
