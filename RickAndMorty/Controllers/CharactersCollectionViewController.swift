//
//  CollectionViewController.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import UIKit

private let reuseIdentifier = "characterCell"

class CharactersCollectionViewController: UICollectionViewController {
    
    //MARK: - Private properties
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    private var characters: [Character] = []
    
    //MARK: - Overrided functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCharacters()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "characterInfo" {
            guard let tabBarVC = segue.destination as? UITabBarController
                  , let controllers = tabBarVC.viewControllers else { return }
            for controller in controllers {
                if let characterInfoVC = controller as? CharacterInfoViewController {
                    guard let sender = sender as? Character else { return }
                    characterInfoVC.character = sender
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath)
        guard let characterCell = cell as? CharacterCollectionViewCell else { return cell }
        characterCell.configure(from: characters[indexPath.row])
        return characterCell
    }
    
    //MARK: - Private functions
    private func fetchCharacters() {
        NetworkManager.shared.loadModel(service: CharacterManager.getAllCharacters, decodeTo: SubjectsList<Character>.self) { result in
            switch result {
            case .success(let response):
                self.characters = response.results
                self.collectionView.reloadData()
            case .fail(let error):
                print(error)
            }
        }
    }
}

extension CharactersCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInsets.right * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
