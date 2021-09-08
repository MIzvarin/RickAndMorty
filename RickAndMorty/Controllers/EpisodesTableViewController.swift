//
//  EpisodesTableViewController.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 06.09.2021.
//

import UIKit

class EpisodesTableViewController: UITableViewController {
    
    private var selectedEpisode: Episode?
    var character: Character?
    var episodes: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        character?.episode.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
        let episodeURL = character?.episode[indexPath.row]
        guard let episodeURL = episodeURL else { return cell }
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: cell.frame.height - 1, width: cell.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        cell.layer.addSublayer(bottomLine)
        cell.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        var content = cell.defaultContentConfiguration()
        content.textProperties.color = .white
        NetworkManager.shared.loadModel(from: episodeURL, decodeTo: Episode.self) { result in
            switch result {
            case .success(let episode):
                self.episodes.append(episode)
                content.text = episode.name
                cell.contentConfiguration = content
            case .fail(let error):
                print(error)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEpisode = episodes[indexPath.row]
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedEpisode = selectedEpisode else { return }
//        if let charactersVC = segue.description as? CharactersCollectionViewController {
//            charactersVC.characters = selectedEpisode.characters
//        }
    }
}
