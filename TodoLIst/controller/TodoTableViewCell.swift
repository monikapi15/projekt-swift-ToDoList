//
//  TodoTableViewCell.swift
//  TodoLIst
//
//  Created by Monika Piątkowska on 10/06/2022.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusCheckMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        statusCheckMark.tintColor = UIColor(named: "SecondaryColor")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(data: ToDoItem) {
        titleLabel.text = data.text
        
        if data.status {
            statusCheckMark.tintColor = UIColor(named: "PrimaryColor")
        }
    }
}
