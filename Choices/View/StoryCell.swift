//
//  StoryCell.swift
//  Choices
//
//  Created by MertcanAkyürek on 27.07.2023.
//

import UIKit

protocol StoryCellDelegate: AnyObject {
    func storyCellDidTap(option: Option)
}

class StoryCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionStackView: UIStackView!
    @IBOutlet weak var option1: OptionView!
    @IBOutlet weak var option2: OptionView!
    
    var options: [OptionView] {
        return [option1, option2]
    }
    
    weak var delegate: StoryCellDelegate?
    
    internal var story: Story?
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    func setup(with story: Story) {
        self.story = story
        
        titleLabel.animation(typing: story.detail, duration: 0.5, completion: { [weak self] in
            UIView.animate(withDuration: 0.2) {
                self?.optionStackView.alpha = story.options.isEmpty ? 0 : 1
            }
        })
        
        for (index, item) in story.options.enumerated() {
            let option = story.options[index]
            
            var optionView = options[index]
            optionView.button.tag = index
            optionView.titleLabel.text = item.detail
            optionView.button.addTarget(self, action: #selector(handleTapOptionButton(_:)), for: .touchUpInside)
            optionView.layer.cornerRadius = 12
            optionView.clipsToBounds = true
        }
    }
    
    @objc func handleTapOptionButton(_ sender: UIButton) {
        guard var story = story else { return }
        
        let option = story.options[sender.tag]
        story.selectedIndex = sender.tag
        delegate?.storyCellDidTap(option: option)
        
        options.forEach({
            $0.titleLabel.text = ""
            $0.backgroundColor = .label
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        optionStackView.alpha = 0
        titleLabel.text = ""
        options.forEach({
            $0.titleLabel.text = ""
            $0.backgroundColor = .label
        })
    }
}


