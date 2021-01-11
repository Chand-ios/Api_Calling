//
//  HomeViewController.swift
//  PrahemTest
//
//  Created by Mac on 06/10/20.
//

import UIKit
import Alamofire
@available(iOS 13.0, *)

class HomeViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!

    var categoryModel = CategoryModel.self

    var Arr = ["STORE","PICKUP","ASSISTANT"]
    var dataArr :[[String:Any]] = []
    var AssistantArr :[[String:Any]] = []
    var storeArr :[[String:Any]] = []
    var pickupArr :[[String:Any]] = []
    var objectsArray:[TableViewCellModel] = []


    let parameters = [
            "customerId ": " CST-100567",
            
        ]
    let headers:HTTPHeaders?  = ["Content-Type" :   "application/json"]
    let url = "http://142.93.213.31:7771/api/customer/categories_list"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        
        tableview.separatorStyle = .none
        
        let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableview.register(cellNib, forCellReuseIdentifier: "tableviewcellid")
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 550
        
    }
    
    func getData() {
        AF.request(URL.init(string: url)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                print(response.result)

                switch response.result {

                case .success(_):
                    if let json = response.value
                    {
                      print(json)
                        let category = json as! [String:Any]
                       // print("categoryyyyyy :",(category))
                        let data = category["data"] as! [String:Any]
                        let AssistantArr = data["AssistantX"]
                        let pickupArr = data["PickupX"]
                        let storeArr = data["StoreX"]
                        let storeimage = data["defaultsxinnerpicurl"] as! String
                        let assistimage = data["defaultaxinnerpicurl"] as! String
                        let pickupimage = data["defaultpxinnerpicurl"] as! String
                       // print("datayyyyyy :",(data))
                        self.objectsArray = [
                            TableViewCellModel(
                                category: "Store",imageUrl: storeimage,
                                details: [CategoryModel(details: storeArr as? [[String:Any]])]
                            ),TableViewCellModel(
                                category: "Pick Up",imageUrl: pickupimage,
                                details: [CategoryModel(details: pickupArr as? [[String:Any]])]),
                                TableViewCellModel(
                                    category: "Assistant",imageUrl: assistimage,
                                    details: [CategoryModel(details: AssistantArr as? [[String:Any]])])]
                        print(self.objectsArray)
                        self.tableview.reloadData()

                    }
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
   

}
}

@available(iOS 13.0, *)

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.objectsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewcellid", for: indexPath) as? TableViewCell {
            // Show SubCategory Title
//            let subCategoryTitle = colorsArray.objectsArray[indexPath.section].subcategory
            let imageUrl = self.objectsArray[indexPath.section].imageUrl
            cell.imaggge.contentMode = .scaleToFill
            cell.imaggge.downloaded(from: imageUrl, contentMode: .scaleAspectFill )
            // Pass the data to colletionview inside the tableviewcell
            let rowArray = self.objectsArray[indexPath.section].details[indexPath.row].details
            print(rowArray!)
            cell.updateCellWith(row: rowArray!)

            // Set cell's delegate
            
            cell.selectionStyle = .none
            return cell
       }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    // Category Title
   /* func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
       // headerView.backgroundColor = UIColor.colorFromHex("#BC224B")
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 0, width: 200, height: 44))
       // headerView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.text = self.objectsArray[section].category
        return headerView
    }*/
}


