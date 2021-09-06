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
    private var selectedCharacter: Character?
    
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
            guard let selectedCharacter = selectedCharacter else { return }
            tabBarVC.navigationItem.title = selectedCharacter.name
            for controller in controllers {
                if let characterInfoVC = controller as? CharacterInfoViewController {
                    characterInfoVC.character = selectedCharacter
                } else if let episodesVC = controller as? EpisodesTableViewController {
                    episodesVC.episodes = getCharactersEpisodes(from: selectedCharacter)
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
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedCharacter = characters[indexPath.row]
        return true
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
    
    private func getCharactersEpisodes(from character: Character) -> [Episode]{
        var episodes: [Episode] = []
        for episodeURL in character.episode {
            NetworkManager.shared.loadModel(from: episodeURL, decodeTo: Episode.self) { result in
                switch result {
                case .success(let episode):
                    episodes.append(episode)
                case .fail(let error):
                    print(error.localizedDescription)
                }
            }
        }
        return episodes
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
