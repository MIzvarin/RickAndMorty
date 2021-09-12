//
//  FavoriteCharactersCollectionViewController.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 12.09.2021.
//

import UIKit


class FavoriteCharactersCollectionViewController: UICollectionViewController {
    
    //MARK: - Private properties
    private var favoriteCharacters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFavoriteCharacters()
        setupNavigationBar()
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteCharacters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCharacterCell", for: indexPath)
        guard let characterCell = cell as? CharacterCollectionViewCell else { return cell }
        let character = favoriteCharacters[indexPath.row]
        characterCell.character = character
        characterCell.configure()
        characterCell.tag = indexPath.row
        return characterCell
    }
    
    //MARK: - Private functions

    private func fetchFavoriteCharacters() {
        let favoriteCharacters = StorageManager.shared.fetchFavotiteCharacters()
        for favoriteCharacter in favoriteCharacters {
            NetworkManager.shared.loadModel(from: favoriteCharacter.url!, decodeTo: Character.self) { result in
                switch result {
                case .success(let response):
                    self.favoriteCharacters.append(response)
                    self.collectionView.reloadData()
                case .fail(let error):
                    print(error)
                }
            }
        }
    }

}


