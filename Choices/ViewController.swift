//
//  ViewController.swift
//  Choices
//
//  Created by MertcanAkyürek on 27.07.2023.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var stories = [Story]()
    var source = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = title
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StoryCell", bundle: nil),
                           forCellReuseIdentifier: "StoryCell")
        
        tableView.beginUpdates()
        source.append(stories[0])
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        tableView.endUpdates()
        
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Warning", message: "Nowhere to go from here. ChatGPT and the developer are to blame. At least no crush :)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @IBAction private func actionBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryCell.reuseIdentifier) as? StoryCell else {
            return UITableViewCell()
        }
        let story = source[indexPath.row]
        cell.setup(with: story)
        cell.delegate = self
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.visibleSize.height
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = tableView.contentOffset
        visibleRect.size = tableView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = tableView.indexPathForRow(at: visiblePoint)
            else { return }
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension ViewController: StoryCellDelegate {
    func storyCellDidTap(option: Option) {
        let story = stories.first(where: {
            $0.ID == option.target
        })
        
        guard let story = story else {
            presentAlert()
            return
        }
        
        tableView.beginUpdates()
        source.append(story)
        let indexPath = IndexPath(row: source.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
}

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
