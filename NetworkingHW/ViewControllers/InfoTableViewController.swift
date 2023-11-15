//
//  InfoTableViewController.swift
//  NetworkingHW
//
//  Created by testing on 15.11.2023.
//

import UIKit

final class InfoTableViewController: UITableViewController {
    private var showInform: [ShowInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 130
        fetchInfo()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showInform.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        guard let cell = cell as? InfoCell else { return UITableViewCell() }
        
        let showInfo = showInform[indexPath.row]
        cell.configure(with: showInfo)
        
        return cell
    }
}
    extension InfoTableViewController {
        func fetchInfo() {
            URLSession.shared.dataTask(with: Link.infoURL.url) { [weak self] data, _, error in
                guard let data = data else {
                    print(error ?? "")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self?.showInform = try decoder.decode([ShowInfo].self, from: data)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }




