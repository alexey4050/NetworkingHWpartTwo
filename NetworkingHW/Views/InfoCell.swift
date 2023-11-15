//
//  InfoCellTableViewCell.swift
//  NetworkingHW
//
//  Created by testing on 15.11.2023.
//

import UIKit

final class InfoCell: UITableViewCell {

    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var numberInfoLabel: UILabel!
    @IBOutlet weak var nameInfoLabel: UILabel!
    @IBOutlet weak var primaryDataLabel: UILabel!
    @IBOutlet weak var episodeInfoLabel: UILabel!
    @IBOutlet weak var endData: UILabel!
    
    private let networkManager = NetworkManager.shared
    
    func configure(with info: ShowInfo) {
        numberInfoLabel.text = "Number: \(info.number)"
        nameInfoLabel.text = "Name: \(info.name)"
        primaryDataLabel.text = "Primary data: \(info.premiereDate)"
        episodeInfoLabel.text = "Episode info: \(info.episodeOrder)"
        endData.text = "End data \(info.endDate)"
        
        DispatchQueue.global().async {
            guard let stringUrl = info.url else { return }
            guard let imageUrl = URL(string: stringUrl) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                self.infoImage.image = UIImage(data: imageData)
            }
        }
    }
}
