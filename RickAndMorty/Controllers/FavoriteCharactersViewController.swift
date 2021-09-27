//
//  FavoriteCharactersViewController.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 26.09.2021.
//

import UIKit

class FavoriteCharactersViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    //MARK: - Private properties
    private var favoriteCharacters: [FavoriteCharacters] = StorageManager.shared.fetchFavotiteCharacters()
    private var displayedCharacter: Character? {
        willSet {
            characterDescription.text = newValue?.description
            NetworkManager.shared.loadData(from: newValue!.image, completion: { data in
                self.characterImage.image = UIImage(data: data)
            })
        }
    }
    
    //MARK: - IB Outlets
    @IBOutlet weak var characterImage: CharacterImageView!
    @IBOutlet weak var characterDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSwipeActions()
        if !favoriteCharacters.isEmpty {
            setDisplayedCharacter(from: favoriteCharacters.first!)
        } else {
            characterDescription.text = "No favorite characters"
        }
    }
    
    //MARK: - Private functions
    private func setDisplayedCharacter(from character: FavoriteCharacters) {
        guard let url = character.url else { return }
        NetworkManager.shared.loadModel(from: url, decodeTo: Character.self) { result in
            switch result {
            case .success(let response):
                self.displayedCharacter = response
            case .fail(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func swipeHandler(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right:
            setDisplayedCharacter(from: favoriteCharacters[1])
        case .left:
            setDisplayedCharacter(from: favoriteCharacters[0])
        default:
            break
        }
    }
    
    private func configureSwipeActions() {
        let rightSwipeActionRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        let leftSwipeActionRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        rightSwipeActionRecognizer.direction = .right
        leftSwipeActionRecognizer.direction = .left
        view.addGestureRecognizer(rightSwipeActionRecognizer)
        view.addGestureRecognizer(leftSwipeActionRecognizer)
    }
    
}
