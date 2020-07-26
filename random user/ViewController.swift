//
//  ViewController.swift
//  random user
//
//  Created by H.W. Hsiao on 2020/7/26.
//  Copyright © 2020 H.W. Hsiao. All rights reserved.
//

import UIKit

struct  user {
    var name: String?
    var email: String?
    var number: String?
    var image: String?
}


class ViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    var infoViewController: InfoTableViewController?
    
    let aUser = user(name: "King", email: "abc@gmail.com", number: "0900-987-654", image: "http://pic.me")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingInfo(user: aUser)


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //若把程式碼放在viewDidLoad裡，再以iphone8模擬器開啟時，會看到圖片的圓角形狀怪異，解決辦法是將程式碼改放在viewDidAppear裡，畫面出現後，再根據比例切出圓角，這樣在所有機型上才能顯示出漂亮圓角
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreInfo" {
            infoViewController = segue.destination as? InfoTableViewController
        }
    }
    
    func settingInfo(user: user) {
        userNameLabel.text = user.name
        infoViewController?.phoneLabel.text = user.number
        infoViewController?.emailLabel.text = user.email
    }


}

