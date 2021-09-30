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
    private var currentIndex: Int = 0
    
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
        let index = favoriteCharacters.firstIndex(of: character)!
        NetworkManager.shared.loadModel(from: url, decodeTo: Character.self) { result in
            switch result {
            case .success(let response):
                self.displayedCharacter = response
                self.currentIndex = index
            case .fail(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func swipeHandler(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right:
            let index = currentIndex == 0 ? favoriteCharacters.count - 1 : currentIndex - 1
            setDisplayedCharacter(from: favoriteCharacters[index])
        case .left:
            let index = currentIndex == favoriteCharacters.count - 1 ? 0 : currentIndex + 1
            setDisplayedCharacter(from: favoriteCharacters[index])
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
