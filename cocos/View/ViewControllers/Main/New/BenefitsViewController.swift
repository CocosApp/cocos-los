//
//  BenefitsViewController.swift
//  cocos
//
//  Created by MIGUEL on 7/08/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll
import Firebase

class BenefitsViewController: BaseUIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var discountList : [CardEntity] = []{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    let controller = PlacesController.controller
    let user : UserEntity = UserEntity.retriveArchiveUser()!
    let kcardPlacesIdentifier : String = "cardPlacesIdentifier"
    var discountSelect : CardEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startService()
    }
    
    fileprivate func startService(){
        self.showActivityIndicator()
        controller.getDiscounts(user.token, success: { (card) in
            self.hideActivityIndicator()
            self.discountList = card
        }) { (error:NSError) in
            self.hideActivityIndicator()
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }
    
    fileprivate func setupTableView(){
        tableView.addInfiniteScroll { (tableView) -> Void in
            // update table view
            self.nextPage()
            // finish infinite scroll animation
            tableView.finishInfiniteScroll()
        }
    }
    
    fileprivate func nextPage(){
        controller.getNextDiscounts(user.token, success: { (card) in
            self.discountList.append(contentsOf: card)
        }) { (error:NSError) in
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kcardPlacesIdentifier {
            if let vc = segue.destination as? PlacesByCardViewController {
                vc.cardId = String(self.discountSelect.id)
                vc.cardName = self.discountSelect.name
            }
        }
    }
    
}

extension BenefitsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discountList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscountPlaceCell") as! DiscountPlaceCell
        cell.nameDiscount.text = discountList[indexPath.row].name
        if discountList[indexPath.row].photo != ""{
            cell.backgroundDiscount.af_setImage(withURL: URL(string: discountList[indexPath.row].photo)!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.discountSelect = self.discountList[indexPath.row]
        //Analytics
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let actualDate = formatter.string(from: date)
        let params = ["id_discount":discountSelect.id,"name_discount":discountSelect.name,"id_user":user.id,"name_user":user.fullName,"date":actualDate,"label":"detail_discount","so":"ios"] as [String:Any]
        Analytics.logEvent("detail_discount", parameters: params)
        
        performSegue(withIdentifier: kcardPlacesIdentifier, sender: self)
    }
}
