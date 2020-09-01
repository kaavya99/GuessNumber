//
//  GameHistoryController.swift
//  GuessTheNumber
//
//  Created by Kaavya Singhal on 9/1/20.
//  Copyright © 2020 Kaavya Singhal. All rights reserved.
//

import UIKit

class GameHistoryController: UITableViewController {
    
    var user: User
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
    }
    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension GameHistoryController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\tGame \(indexPath.row+1)\t\t\t\t\t\t\t\(user.games[indexPath.row]) tries"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.games.count
    }
}
