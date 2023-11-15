//
//  ViewController.swift
//  NetworkingHW
//
//  Created by testing on 10.11.2023.
//

import UIKit

enum UserAction: CaseIterable {
    case fetchArtworkFirst
    case fetchArtworkSecond
    case fetchArtworkThird
    case fetchInfoFilm
    
    var title: String {
        switch self {
        case .fetchArtworkFirst:
            return "Fetch Photos"
        case .fetchArtworkSecond:
            return "Fetch Posts"
        case .fetchArtworkThird:
            return "Fetch Todos"
        case .fetchInfoFilm:
            return "Info Film"
        }
    }
}

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    var massege: String {
        switch self {
        case .success:
            return "You can see the result in the Debug area"
        case .failed:
            return "You can see error in the Debug area"
        }
    }
}

//MARK: - Private Methods
final class ArtworkController: UICollectionViewController {
    
    private let userActons = UserAction.allCases
    private let networkManager = NetworkManager.shared
    
    // MARK: - Private Methods
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.title, message: status.massege, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo" {
            guard let infoVC = segue.destination as? InfoTableViewController else { return }
            infoVC.fetchInfo()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ArtworkController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath) as? UserActionCell else { return UICollectionViewCell() }
        
        cell.userActionLabel.text = userActons[indexPath.item].title
        
        return cell
    }
}

//MARK: - CollectionViewDelegate
extension ArtworkController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActons[indexPath.item]
        
        switch userAction {
        case .fetchArtworkFirst:
            performSegue(withIdentifier: "showImage", sender: nil)
        case .fetchArtworkSecond:
            fetchArtworkSecond()
        case .fetchArtworkThird:
            fetchArtworkThird()
        case .fetchInfoFilm:
            performSegue(withIdentifier: "showInfo", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
    
    private func fetchArtworkSecond() {
        networkManager.fetch([Post].self, from: Link.postsURL.url) { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print(post)
                    self.showAlert(withStatus: .success)
                case .failure(_):
                    self.showAlert(withStatus: .failed)
                }
            }
        }
    }
    
    private func fetchArtworkThird() {
        networkManager.fetch([Todos].self, from: Link.todosURL.url) { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let todos):
                    print(todos)
                    self.showAlert(withStatus: .success)
                case .failure(_):
                    self.showAlert(withStatus: .failed)
                }
            }
        }
    }
}



