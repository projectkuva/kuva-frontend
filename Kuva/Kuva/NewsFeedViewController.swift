//
//  NewsFeedViewController.swift
//  
//
//  Created by Shane DeWael on 2/28/17.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class NewsFeedViewController: PrimaryViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityTable: UITableView!
    
    var activities: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityTable.accessibilityIdentifier = "activitytab"

        // Do any additional setup after loading the view.
        self.activityTable.delegate = self
        self.activityTable.dataSource = self
        self.activityTable.rowHeight = UITableViewAutomaticDimension
        self.activityTable.estimatedRowHeight = 50
        getData()
        self.activityTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        let tok = super.getToken()
        let headers = ["Authorization": "Bearer \(tok!)"]
        
        Alamofire.request("http://kuva.jakebrabec.me/api/user/newsfeed", headers: headers).responseJSON { res in
            
            let json = JSON(res.value)
            self.activities = json["data"].array!
            
            self.activityTable.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityTableViewCell

        var type = activities[indexPath.row]["type"].stringValue
        var user = activities[indexPath.row]["user"]["name"].stringValue
        var action:String? = nil
        if (type == "comment") {
            action = " commented on your photo"
        } else if (type == "like") {
            action = " liked your photo"
        } else {
            action = ""
        }
        var actionString = NSMutableAttributedString(string:action!)
        var attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17)]
        var userString = NSMutableAttributedString(string:user, attributes:attrs)
        userString.append(actionString)
        cell.activityAction.attributedText = userString
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
