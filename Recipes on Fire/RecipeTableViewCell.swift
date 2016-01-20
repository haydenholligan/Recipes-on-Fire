//
//  RecipeTableViewCell.swift
//  Recipes on Fire
//
//  Created by Hayden on 2016-01-19.
//  Copyright © 2016 Hayden Holligan. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
