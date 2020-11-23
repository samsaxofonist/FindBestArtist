//
//  MyOrdersViewController.swift
//  BestArtist
//
//  Created by Andrii Kravchenko on 15.10.20.
//  Copyright © 2020 kievkao. All rights reserved.
//

import UIKit
import ARSLineProgress

class MyOrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var orders = [Order]()
    let loader = MyOrdersLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.title = "My Orders"

        ARSLineProgress.show()
        loader.loadMyOrders(completion: { loadedOrders in
            ARSLineProgress.hide()
            self.orders = loadedOrders
            self.tableView.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        let order = orders[indexPath.row]
        cell.setupWithOrder(order)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orders[indexPath.row]
        let orderDetailsVC = self.storyboard?.instantiateViewController(identifier: "OrderDetailsViewController") as! OrderDetailsViewController
        orderDetailsVC.order = order
        self.navigationController?.pushViewController(orderDetailsVC, animated: true)
    }
}
