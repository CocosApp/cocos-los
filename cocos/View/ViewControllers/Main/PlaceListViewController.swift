//
//  PlaceListViewController.swift
//  cocos
//
//  Created by MIGUEL on 12/04/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class PlaceListViewController : UIViewController {
    @IBOutlet weak var listTableView : UITableView!
    var lat : Double!
    var long : Double!
    var placesList : [PlacesEntity] = []{
        didSet{
            listTableView.reloadData()
        }
    }
    var subcategoryId:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFakeLocation()
    }
    
    func getFakeLocation(){
        self.lat = -12.072369
        self.long = -77.068706
        self.loadList()
    }
    
    private func loadList(){
        let user : UserEntity = UserEntity.retriveArchiveUser()!
        let controller = PlaceListController.controller
        let subcategory : String = String(subcategoryId)
        let latitude : String = String(lat)
        let longitude : String = String(long)
        controller.loadList(user.token, subcategoryId: subcategory,latitude: latitude,longitude: longitude, success: { (places) in
            self.placesList = places
        }) { (error:NSError) in
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }
    
}

extension PlaceListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeListCell") as! PlaceListCell
        cell.lblTitle.text = placesList[indexPath.row].name
        cell.backgroundImageView?.af_setImage(withURL: URL(string: placesList[indexPath.row].photo)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}