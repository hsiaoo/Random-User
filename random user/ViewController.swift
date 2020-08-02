//
//  ViewController.swift
//  random user
//
//  Created by H.W. Hsiao on 2020/7/26.
//  Copyright © 2020 H.W. Hsiao. All rights reserved.
//

import UIKit

struct  user: Decodable {
    var name: String?
    var email: String?
    var number: String?
    var image: String?
}

struct AllData: Decodable {
    var results: [SingleData?]
}

struct SingleData: Decodable {
    var name: Name?
    var email: String?
    var phone: String?
    var picture: Picture?
}

struct Name: Decodable {
    var first: String?
    var last: String?
}

struct Picture: Decodable {
    var large: String?
}


class ViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBAction func makeNewUser(_ sender: Any) {
        if isDownloading == false {
            downloadInfo()
        }
    }
    
    var infoViewController: InfoTableViewController?
    var isDownloading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadInfo()

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
        //將image字串存入imageAddress
        if let imageAddress = user.image {
            //將imageAddress字串轉型成URL
            if let imageURL = URL(string: imageAddress) {
                //使用URLSession下載imageURL
                let task = URLSession(configuration: .default).dataTask(with: imageURL, completionHandler: {
                    (url, response, error) in
                    if error != nil {
                        DispatchQueue.main.async {
                            self.popAlert(withTitle: "Sorry")
                            self.isDownloading = false
                        }
                        
                        return
                    }
                    //成功下載後，設定顯示圖片
                    if let okURL = url {
                        if let downloadImage = UIImage(data: okURL) {
                            DispatchQueue.main.async {
                                self.userImage.image = downloadImage
                                self.isDownloading = false
                            }
                        }
                    }
                })
                task.resume()
                isDownloading = true
            }
        }
    }
    
    func downloadInfo() {
        if let url = URL(string: "https://randomuser.me/api/") {
            let task = URLSession(configuration: .default).dataTask(with: url, completionHandler: {
                (data, response, error) in
                if error != nil {
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009 {
                        DispatchQueue.main.async {
                            self.popAlert(withTitle: "No Internet Connection")
                            self.isDownloading = false
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.popAlert(withTitle: "Sorry")
                            self.isDownloading = false
                        }
                    }
                    
                    return
                }
                
                if let loadedData = data {
                    do {
                        let okData = try JSONDecoder().decode(AllData.self, from: loadedData)
                        let firstname = okData.results[0]?.name?.first
                        let lastname = okData.results[0]?.name?.last
                        let fullname: String? = {
                            guard let okFirstname = firstname, let okLastname = lastname else { return nil }
                            return okFirstname + " " + okLastname
                        }()
                        let email = okData.results[0]?.email
                        let phone = okData.results[0]?.phone
                        let picture = okData.results[0]?.picture?.large
                        let aUser = user(name: fullname, email: email, number: phone, image: picture)
                        DispatchQueue.main.async {
                            self.settingInfo(user: aUser)
                            self.isDownloading = false
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.popAlert(withTitle: "Sorry")
                            self.isDownloading = false
                        }
                    }
                }
            })
            task.resume()
            isDownloading = true
        }
    }
    
    func popAlert(withTitle title: String) {
        let errorAlert = UIAlertController(title: title, message: "Please try again later.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(errorAlert, animated: true, completion: nil)
    }
    


}

