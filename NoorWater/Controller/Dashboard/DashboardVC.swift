//
//  DashboardVC.swift
//  NoorWater
//
//  Created by Asfand Hafeez on 15/04/2021.
//

import UIKit
import KYDrawerController
import SDWebImage
import Alamofire
class DashboardVC: UIViewController, PushViewDelegate {
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productCV: UICollectionView!
    @IBOutlet weak var equipmentCV: UICollectionView!
    @IBOutlet weak var topOfferCV: UICollectionView!
    let menuTapGesture = UITapGestureRecognizer()
    var  slider = [
        "http://new.noorwaters.com/assets/images/app_slider/1.png",
        "http://new.noorwaters.com/assets/images/app_slider/2.png",
        "http://new.noorwaters.com/assets/images/app_slider/3.png",
        "http://new.noorwaters.com/assets/images/app_slider/4.png",
        "http://new.noorwaters.com/assets/images/app_slider/5.png",
        "http://new.noorwaters.com/assets/images/app_slider/6.png",
        "http://new.noorwaters.com/assets/images/app_slider/7.png",
        "http://new.noorwaters.com/assets/images/app_slider/8.png",
        "http://new.noorwaters.com/assets/images/app_slider/9.jpg",
        "http://new.noorwaters.com/assets/images/app_slider/10.jpg",
        "http://new.noorwaters.com/assets/images/app_slider/11.jpg"
    ]
    var product = [ResultData]()
    var equipment = [ResultData]()
    var topOffer = [ResultData]()
    let nofityBtn = UIButton()
    
    let bellBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       title = ApiService.instance.user!.name
        transparentNavBar()
        
        setBannerUpCollectionView()
        ApiService.instance.pushDelegate = self
        
        getProductApiCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavbar()
        
    }
    
    func getProductApiCall()  {
        self.startActivityIndicator()
        guard let id = ApiService.instance.user else { return  }
        let param  = [
            "module":"get_products",
            "from":"app",
            "user_id":id.id
        ] as [String: Any]
        
        AF.request( "\(BASE_URL)process", method: .post, parameters: param).response { response in
            debugPrint(response)
            if let data = response.data{
                print(data.prettyPrintedJSONString ?? "no data")
                                
                do {
                    
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonPetitions = try decoder.decode(GetProduct.self, from: data)
                  
                    for cat in jsonPetitions.ProductsByCategory {
                        
                        switch cat.category {
                            case "Water":
                                self.product = cat.products
                        case "Equipments":
                            self.equipment = cat.products
                        case "Promotions":
                            self.topOffer = cat.products
                            default:
                                break
                            }
                        
                    }
                    
                    self.productCV.reloadData()
                    self.equipmentCV.reloadData()
                    self.topOfferCV.reloadData()
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                self.stopActivityIndicator()
                
            }
            
        }
       

    }
    func setUpNavbar() {
        let menuView = UIView(frame: CGRect(x: 0, y:0, width: 60, height:60))
        let image = UIImage(named: "burger")
        let imageView = UIImageView(image: image!)
        imageView.contentMode = .scaleAspectFill

            imageView.frame = CGRect(x: -15, y: 0, width: 60, height: 50)
//        nofityBtn.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        nofityBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        bellBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        bellBtn.setImage(UIImage(named: "notification"), for: .normal)
//        if ApiService.instance.cartQuantity.count == 0 {
            
            nofityBtn.setImage(UIImage(named: "shopping-cart"), for: .normal)
//        }else {
//            nofityBtn.setImage(UIImage(named: "shopping-cart"), for: .normal)
//        }
        
        nofityBtn.addTarget(self, action: #selector(cartBtnTapped), for: .touchUpInside)
        
        
        bellBtn.addTarget(self, action: #selector(bellBtnTapped), for: .touchUpInside)
        nofityBtn.imageView?.contentMode = .scaleAspectFit
        
        bellBtn.imageView?.contentMode = .scaleAspectFit
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: nofityBtn),UIBarButtonItem(customView: bellBtn)]
        
        menuView.layer.zPosition = 999
        menuView.addSubview(imageView)
        let barButtonItem = UIBarButtonItem(customView: menuView)
//        let rightBarBtnItem = UIBarButtonItem(customView: bellBtn)
        barButtonItem.action = #selector(menuBtnTapped)
        navigationItem.leftBarButtonItem = barButtonItem
//        navigationItem.rightBarButtonItem = rightBarBtnItem
        menuView.addGestureRecognizer(menuTapGesture)
        menuTapGesture.addTarget(self, action: #selector(menuBtnTapped))
//        bellBtn.addTarget(self, action: #selector(bellBtnTapped), for: .touchUpInside)
        
    }
   @IBAction func menuBtnTapped()  {
    if let drawerController = navigationController?.parent as? KYDrawerController {
               drawerController.setDrawerState(.opened, animated: true)
           }
    }

    
    @IBAction func bellBtnTapped()  {
        let vc  = NotificationVC.instantiate(type: .main)
        pushVC(vc)
     }
    
    @IBAction func cartBtnTapped()  {
        let vc  = ShoppingCartVC.instantiate(type: .main)
        pushVC(vc)
     }

    
    func pushVCFromSideMenu(int: Int) {
        switch int {
        case 0 :
            ApiService.instance.setDashBoardRootVC()
            
        case 1 :
            let vc =  OrderVC()
            pushVC(vc)
            
        case 2 :
            let vc =  WalletVC.instantiate(type: .main)
            pushVC(vc)
        case 4:
            let vc =  UpdateProfileVC.instantiate(type: .main)
            pushVC(vc)
            
        case 5:
            let vc =  NotificationVC.instantiate(type: .main)
            pushVC(vc)
            
        case 3:
            let vc =  SavedAddress.instantiate(type: .main)
            pushVC(vc)
            
            
        case 6:
            let vc =  FeedbackVC.instantiate(type: .main)
            pushVC(vc)
            
        case 7:
            let vc =  ContactUsVC.instantiate(type: .main)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        case 8:
            
            ApiService.instance.resetDefaults()
            ApiService.instance.setLoginRootVC()
            
        default:
            break
        }
    }
    

    func setBannerUpCollectionView()  {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        productCV.delegate = self
        productCV.dataSource = self
        
        equipmentCV.delegate = self
        equipmentCV.dataSource = self
        
        topOfferCV.delegate = self
        topOfferCV.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.isPagingEnabled = true
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.minimumLineSpacing = 10
        layout1.scrollDirection = .horizontal
        layout1.minimumInteritemSpacing = 0
        productCV.setCollectionViewLayout(layout1, animated: true)
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.minimumLineSpacing = 10
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = 0
        equipmentCV.setCollectionViewLayout(layout2, animated: true)
        let layout3 = UICollectionViewFlowLayout()
        layout3.minimumLineSpacing = 10
        layout3.scrollDirection = .horizontal
        layout3.minimumInteritemSpacing = 0
        topOfferCV.setCollectionViewLayout(layout3, animated: true)
        topOfferCV.isPagingEnabled = true
        
    }

}

extension DashboardVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
        return slider.count
        }else if collectionView == self.equipmentCV {
            return equipment.count
        }else if collectionView == self.topOfferCV {
            return topOffer.count
        }
        else if collectionView == self.productCV {
            return product.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BannerCell
            cell.sliderImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.sliderImage.sd_setImage(with: URL(string: slider[indexPath.item]), placeholderImage: nil, options: [.progressiveLoad])
            return cell
        }else if collectionView == self.productCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCell
            cell.resuslt  = product[indexPath.item]
            return cell
        }else if collectionView == self.equipmentCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCell
            cell.resuslt  = equipment[indexPath.item]
            return cell
        }else  if collectionView == self.topOfferCV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TopOfferCell
            cell.resuslt  = topOffer[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width:  self.collectionView.frame.width , height: 161)
        }else if collectionView == self.topOfferCV {
            return CGSize(width:  self.topOfferCV.frame.width , height: 180)
        }
        return CGSize(width:  110 , height: 160)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.productCV:
            let vc = ProductDetailVC.instantiate(type: .main) as! ProductDetailVC
            vc.product = product[indexPath.item]
            pushVC(vc)
        case self.equipmentCV:
            let vc = ProductDetailVC.instantiate(type: .main) as! ProductDetailVC
            vc.product = equipment[indexPath.item]
            pushVC(vc)
        case self.topOfferCV:
            let vc = ProductDetailVC.instantiate(type: .main) as! ProductDetailVC
            vc.product = topOffer[indexPath.item]
            pushVC(vc)
            
        default:
            break
        }
    }
}

class BannerCell: UICollectionViewCell {
    @IBOutlet weak var sliderImage: UIImageView!
    
}


class ProductCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    var resuslt : ResultData! {
        didSet {
    
            image.sd_imageIndicator = SDWebImageActivityIndicator.gray
            image.sd_setImage(with: URL(string: resuslt.image), placeholderImage: nil, options: [.progressiveLoad])
            priceLbl.text = "AED " + resuslt.price
            quantityLbl.text = resuslt.unit
            nameLbl.text = resuslt.name
        }
    }
}


class TopOfferCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    var resuslt : ResultData! {
        didSet {
            image.sd_imageIndicator = SDWebImageActivityIndicator.gray
            image.sd_setImage(with: URL(string: resuslt.image), placeholderImage: nil, options: [.progressiveLoad])
            priceLbl.text =  "AED "  + resuslt.price
            nameLbl.text = resuslt.name
        }
    }
}


