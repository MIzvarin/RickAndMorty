//
//  CollectionViewController.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 01.09.2021.
//

import UIKit

class CharactersCollectionViewController: UICollectionViewController {
    
    //MARK: - Private properties
    private var characters: SubjectsList<Character>? {
        didSet {
            if characters?.info.prev == nil {
                prevCharactersPage.isEnabled = false
            } else {
                prevCharactersPage.isEnabled = true
            }
            if characters?.info.next == nil {
                nextCharactersPage.isEnabled = false
            } else {
                nextCharactersPage.isEnabled = true
            }
        }
    }
    
    //MARK: - IB Outlets
    @IBOutlet weak var nextCharactersPage: UIBarButtonItem!
    @IBOutlet weak var prevCharactersPage: UIBarButtonItem!
    
    //MARK: - Overrided functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCharacters()
        setupNavigationBar()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tabBarVC = segue.destination as? UITabBarController
              , let controllers = tabBarVC.viewControllers
              , let characterCollectionCell = sender as? CharacterCollectionViewCell
              , let selectedCharacter = characters?.results[characterCollectionCell.tag]  else { return }
        tabBarVC.navigationItem.title = selectedCharacter.name
        for controller in controllers {
            if let characterInfoVC = controller as? CharacterInfoViewController {
                characterInfoVC.character = selectedCharacter
            } else if let episodesVC = controller as? EpisodesTableViewController {
                episodesVC.character = selectedCharacter
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters?.results.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath)
        guard let characterCell = cell as? CharacterCollectionViewCell else { return cell }
        guard let character = characters?.results[indexPath.row] else { return cell }
        characterCell.character = character
        characterCell.configure()
        characterCell.tag = indexPath.row
        return characterCell
    }
    
    //MARK: - IBActions
    @IBAction func changeCharactersPage(_ sender: UIBarButtonItem) {
        guard let loadFrom = sender.tag == 1 ? characters?.info.next : characters?.info.prev else { return }
        NetworkManager.shared.loadModel(from: loadFrom, decodeTo: SubjectsList<Character>.self) { result in
            switch result {
            case .success(let response):
                self.setResponseData(response: response)
            case .fail(let error):
                print(error)
            }
        }
    }
    
    //MARK: - Private functions
    private func fetchCharacters() {
        NetworkManager.shared.loadModel(service: CharacterManager.getAllCharacters, decodeTo: SubjectsList<Character>.self) { result in
            switch result {
            case .success(let response):
                self.setResponseData(response: response)
            case .fail(let error):
                print(error)
            }
        }
    }

    private func setResponseData(response: SubjectsList<Character>) {
        characters = response
        collectionView.reloadData()
    }
    
}

