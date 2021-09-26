//
//  FavoriteCharactersViewController.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 26.09.2021.
//

import UIKit

class FavoriteCharactersViewController: UIViewController {
    
    
    //MARK: - Private properties
    private let favoriteCharacters: [FavoriteCharacters] = StorageManager.shared.fetchFavotiteCharacters()
    
    //MARK: - IB Outlets
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSwipeActions()
        if !favoriteCharacters.isEmpty {
            fetchCharacterData(from: favoriteCharacters.first!)
        } else {
            characterDescription.text = "No favorite characters"
        }
    }
    
    //MARK: - Private functions
    private func fetchCharacterData(from character: FavoriteCharacters) {
        guard let url = character.url else { return }
        NetworkManager.shared.loadModel(from: url, decodeTo: Character.self) { result in
            switch result {
            case .success(let response):
                self.fillCharacterInfo(from: response)
            case .fail(let error):
                print(error)
            }
        }
    }
    
    private func fillCharacterInfo(from character: Character) {
        characterDescription.text = character.description
        NetworkManager.shared.loadData(from: character.image, completion: { result in
            self.characterImage.image = UIImage(data: result)
        })
    }
    
    @objc private func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        print("Start")
        switch sender.direction {
        case .right:
            print("right")
        case .left:
            print("left")
        default:
            print("nothing")
        }
    }
    
    private func configureSwipeActions() {
        let rightSwipeActionRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        rightSwipeActionRecognizer.direction = .right
        let leftSwipeActionsRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        leftSwipeActionsRecognizer.direction = .left
        view.addGestureRecognizer(rightSwipeActionRecognizer)
        view.addGestureRecognizer(leftSwipeActionsRecognizer)
    }
    

}
