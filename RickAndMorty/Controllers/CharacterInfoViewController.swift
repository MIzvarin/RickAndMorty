//
//  CharacterInfoViewController.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 02.09.2021.
//

import UIKit

class CharacterInfoViewController: UIViewController {
    
    //MARK: - Public properties
    var character: Character?
    
    //MARK: - IB Outlets
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Overrided functions
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let character = character else { return }
        fillCharacterInfo(from: character)
    }
    
    private func addToFavorite() {
        let favoriteCharacter = FavoriteCharacters(context: StorageManager.shared.context)
        favoriteCharacter.url = character?.url
        StorageManager.shared.saveContext()
    }
    
    private func removeFromFavorite() {
        
    }
    
    
    //MARK: - Private functions
    private func fillCharacterInfo(from character: Character) {
        descriptionLabel.text = character.description
        NetworkManager.shared.loadData(from: character.image) { data in
            self.characterImage.image = UIImage(data: data)
        }
    }

}
