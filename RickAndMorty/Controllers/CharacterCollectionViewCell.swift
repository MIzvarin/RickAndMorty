//
//  CharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IB Outlets
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterStatusAndSpeciesLabel: UILabel!
    @IBOutlet weak var lastKnownLocationLabel: UILabel!
    @IBOutlet weak var firstSeenInLabel: UILabel!
    
    //MARK: - Public functions
    func configure(from character: Character) {
        NetworkManager.shared.loadData(from: character.image) { data in
            self.characterImageView.image = UIImage(data: data)
        }
        characterNameLabel.text = character.name
        characterStatusAndSpeciesLabel.text = character.statusAndSpeciesText
        lastKnownLocationLabel.text = character.location?.name ?? "Undefinied"
        if let firstEpisodeURL = character.episode.first {
            NetworkManager.shared.loadModelFromURL(from: firstEpisodeURL, decodeTo: Episode.self) { result in
                switch result {
                case .success(let episode):
                    self.firstSeenInLabel.text = episode.name
                case .fail(let error):
                    print(error)
                }
            }
        }
    }
    
}
