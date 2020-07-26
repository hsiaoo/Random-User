//
//  InfoTableViewController.swift
//  random user
//
//  Created by H.W. Hsiao on 2020/7/26.
//  Copyright © 2020 H.W. Hsiao. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {

    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

}
