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
    private let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private var charactes: [Character] = []
    
    //MARK: - Overrided functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCharacters()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath)
        guard let characterCell = cell as? CharacterCollectionViewCell else { return cell }
        return characterCell

    }
    
    //MARK: - Private functions
    private func fetchCharacters() {
        NetworkManager.shared.loadData(service: CharacterManager.getAllCharacters, decodeTo: SubjectsList<Character>.self) { result in
            switch result {
            case .success(let response):
                self.charactes = response.results
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
