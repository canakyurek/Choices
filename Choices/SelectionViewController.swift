//
//  SelectionViewController.swift
//  Choices
//
//  Created by MertcanAkyürek on 28.07.2023.
//

import UIKit
import FirebaseDatabase
import FirebaseDatabaseSwift

class SelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private lazy var listRef = Database.database().reference().child("story-list").child("story-list")
    
    private lazy var episodeRef = Database.database().reference()
    
    var source = [Episode]()
    
    var stories = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        listRef.getData { [weak self] error, snapshot in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            guard let children = snapshot?.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            self?.source = children.compactMap { snapshot in
                return try? snapshot.data(as: Episode.self)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension SelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
        let episode = source[indexPath.row]
        cell.titleLabel.text = episode.name
        cell.dateLabel.text = episode.created
        cell.detailLabel.text = episode.detail
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = source[indexPath.row]
        episodeRef.child("\(episode.ID)").child("stories").getData { [weak self] error, snapshot in
            
            guard error == nil else {
                return
            }
            
            guard let children = snapshot?.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            self?.stories = children.compactMap { snapshot in
                return try? snapshot.data(as: Story.self)
            }
            
            DispatchQueue.main.async {
                self?.performSegue(withIdentifier: "storySegue", sender: indexPath)
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard stories.count > 0 else {
            return
        }
        
        guard let indexPath = sender as? IndexPath else {
            return
        }
        
        let episode = source[indexPath.row]
        
        if segue.identifier == "storySegue" {
            guard let destination = segue.destination as? ViewController else {
                return
            }
            
            destination.stories = stories
            destination.title = episode.name
        }
    }
}
