//
//  CustomTableViewCell.swift
//  AssignmentIOS
//
//  Created by User on 14/04/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.borderColor = UIColor(red: 225 / 255, green: 225 / 255, blue: 223 / 255, alpha: 1).cgColor
        containerView.layer.borderWidth = 1
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
        containerView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        containerView.layer.shadowRadius = 2.0
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.masksToBounds = false
    }
    
    var personDataModel: Person? {
        didSet {
            configureCell()
        }
    }

    func configureCell() {
        nameLabel.text = "\(personDataModel?.name ?? "")"
        genderLabel.text = "\(personDataModel?.gender?.capitalized ?? "")"
        eyeColorLabel.text = "\(personDataModel?.eyeColor?.capitalized ?? "")"
        hairColorLabel.text = "\(personDataModel?.hairColor?.capitalized ?? "")"
        massLabel.text = "\(personDataModel?.mass ?? "")"
    }
    
}
