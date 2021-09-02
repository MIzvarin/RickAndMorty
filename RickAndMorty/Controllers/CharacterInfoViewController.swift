//
//  CharacterInfoViewController.swift
//  RickAndMorty
//
//  Created by Максим Изварин on 02.09.2021.
//

import UIKit

class CharacterInfoViewController: UIViewController {

    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(character?.name)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
