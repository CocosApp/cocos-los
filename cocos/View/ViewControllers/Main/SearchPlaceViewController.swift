//
//  SearchPlaceViewController.swift
//  cocos
//
//  Created by MIGUEL on 22/04/18.
//  Copyright © 2018 MIGUEL. All rights reserved.
//

import UIKit

class SearchPlaceViewController : UIViewController {
    @IBOutlet weak var searchPlaceTableView: UITableView!
    var list : [PlacesEntity] = [] {
        didSet{
            searchPlaceTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupList()
    }
    
    func setupList(){
        let controller = SearchPlaceController.controller
        controller.searchPlace(success: { (places) in
            self.list = places
        }) { (error) in
            self.showErrorMessage(withTitle: error.localizedDescription)
        }
    }
}

extension SearchPlaceViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchPlaceListCell") as! SearchPlaceListCell
        let place = list[indexPath.row]
        cell.titlePlaceLabel.text = place.name
        if place.photo != ""{
            cell.backgroundPlaceImage.af_setImage(withURL: URL(string: place.photo)!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}