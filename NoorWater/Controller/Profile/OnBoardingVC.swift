//
//  OnBoardingVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 25/04/2021.
//

import UIKit

class OnBoardingVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var onboarginData =  [OnBoaring]()
    override func viewDidLoad() {
        super.viewDidLoad()

        onboarginData = [
            OnBoaring(name: "Make an Order", image: UIImage(named: "1")!, detail: "Select , Product,Delivery you Want , Schedule Delivery"),
            OnBoaring(name: "Delivery", image: UIImage(named: "2")!, detail: "Select , Product,Delivery you Want , Schedule Delivery"),
            OnBoaring(name: "Reward", image: UIImage(named: "3")!, detail: "Select , Product,Delivery you Want , Schedule Delivery"),
        
        ]
        pageControl.numberOfPages = onboarginData.count
        pageControl.isUserInteractionEnabled = false
        setupCollectionView()
        ApiService.instance.updateUserInApiService()
        
    }
    func setupCollectionView()  {
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        let cellSize = CGSize(width:   self.view.frame.width , height: UIScreen.main.bounds.height)
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.isPagingEnabled = true
    }
   @IBAction func skipBtnTapped()  {
//    if let user = ApiService.instance.user {
        ApiService.instance.setDashBoardRootVC()
//    }else {
//        ApiService.instance.setLoginRootVC()
//    }
    
    }
}

extension OnBoardingVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboarginData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnboardingCell
        let data = onboarginData[indexPath.row]
        cell.bgImage.image = data.image
        cell.titleLbl.text = data.name
        cell.detailText.text = data.detail
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        pageControl.currentPage  = Int(scrollView.contentOffset.x / width)
    }
    
    
}
class OnboardingCell: UICollectionViewCell {
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailText: UILabel!
}

struct OnBoaring {
    let name: String
    let image : UIImage
    let detail: String
}
