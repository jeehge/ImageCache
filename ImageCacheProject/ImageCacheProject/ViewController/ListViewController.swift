//
//  ListViewController.swift
//  ImageCacheProject
//
//  Created by JH on 25/10/2019.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit

enum ExampleName: Int {
    case diskCache
    case memoryCache
}

enum ItemMenu: CustomStringConvertible {
    case diskCache
    case memoryCache
    
    var description: String {
        switch self {
        case .diskCache:
            return "NSCache Disk Cache Example"
        case .memoryCache:
            return "NSCache Disk Memory Example"
        }
    }
}

class ListViewController: BaseViewController {

    // MARK: - Property
    @IBOutlet weak var tableview: UITableView!
    
    let items: [ItemMenu] = [ItemMenu.diskCache, ItemMenu.memoryCache]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
    }
    
    // MARK: - Initialize
    func initTableView() {
        tableview.delegate = self
        tableview.dataSource = self
    }

}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableview.dequeueReusableCell(withIdentifier: "itemCell")!
        cell.textLabel?.text = items[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case ExampleName.diskCache.rawValue:
            let diskCacheVC = DiskCacheViewController.viewController(name: "Main")
            navigationController?.pushViewController(diskCacheVC, animated: true)
        case ExampleName.memoryCache.rawValue:
            let memoryCacheVC = MemoryCacheViewController.viewController(name: "Main")
            navigationController?.pushViewController(memoryCacheVC, animated: true)
        default:
            print("11")
        }
    }
    
}

