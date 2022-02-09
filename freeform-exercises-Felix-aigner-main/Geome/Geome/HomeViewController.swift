//
//  ViewController.swift
//  Geome
//
//  Created by Felix-Xaver Aigner on 12.01.22.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var reusableCellIdentifier = "postGameCell"
    var postGames: [GameModel]?
    
    @IBOutlet var tableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let games = postGames else {return 1}
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableCellIdentifier, for: indexPath)
        cell.textLabel?.text = "post game"
        guard let games = postGames else {return cell}
        cell.textLabel?.text = games[indexPath.row].name
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        tableview.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //reload from core data
        self.retrievePostGameData()
        self.tableview.reloadData()
    }

    func retrievePostGameData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Game>(entityName: "Game")
            
            do {
                let results = try context.fetch(fetchRequest)
                var gameList: [GameModel] = []
                for result in results {
                    let gameObj = GameModel(name: result.name ?? "", img_url: result.img_url ?? "", points: result.points ?? "0", guessedLat: result.guessed_lat, guessedLong: result.guessed_long, pictureLat: result.picture_lat, pictureLong: result.picture_long, timeElapsed: result.time_elapsed ?? "0")
                    gameList.append(gameObj)
                }
                self.postGames = gameList
            } catch {
                print("could not retrieve")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GameDetailSegue") {
            if let postGameController = segue.destination as? PostGameDetailViewController{
                if let selected = self.tableview.indexPathForSelectedRow, let games = postGames {
                    postGameController.game = games[selected.row]
                }
            }
            
        }
    }

}

