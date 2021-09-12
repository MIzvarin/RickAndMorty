//
//  CharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Public properties
    var character: Character?
    private var heartImage: UIImage {
        if (character!.isFavorite) {
            return UIImage(systemName: "heart.fill")!
        } else {
            return UIImage(systemName: "heart")!
        }
    }
    //MARK: - IB Outlets
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterStatusAndSpeciesLabel: UILabel!
    @IBOutlet weak var lastKnownLocationLabel: UILabel!
    @IBOutlet weak var firstSeenInLabel: UILabel!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    
    //MARK: - Public functions
    func configure() {
        guard let character = character else { return }
        NetworkManager.shared.loadData(from: character.image) { data in
            self.characterImageView.image = UIImage(data: data)
        }
        characterNameLabel.text = character.name
        characterStatusAndSpeciesLabel.text = character.statusAndSpeciesText
        addToFavoriteButton.setImage(heartImage, for: .normal)
        lastKnownLocationLabel.text = character.location?.name ?? "Undefinied"
        if let firstEpisodeURL = character.episode.first {
            NetworkManager.shared.loadModel(from: firstEpisodeURL, decodeTo: Episode.self) { result in
                switch result {
                case .success(let episode):
                    self.firstSeenInLabel.text = episode.name
                case .fail(let error):
                    print(error)
                }
            }
        }
    }
    
    //MARK: - IB Actions
    @IBAction func addToFavoriteBtnPressed(_ sender: UIButton) {
        guard let character = character else { return }
        character.isFavorite ? removeFromFavorites() : addToFavorite()
        character.isFavorite = !character.isFavorite
        sender.setImage(heartImage, for: .normal)
    }
    
    //MARK: - Private functions
    private func addToFavorite() {
        let favoriteCharacter = FavoriteCharacters(context: StorageManager.shared.context)
        favoriteCharacter.url = character!.url
        character?.isFavorite = true
        StorageManager.shared.saveContext()
    }
    
    private func removeFromFavorites() {
        guard let characterForRemove = StorageManager.shared.fetchCharacterByURL(url: character!.url) else { return }
        character?.isFavorite = false
        StorageManager.shared.remove(character: characterForRemove)
    }
}
