//
//  AddViewController.swift
//  Recipes on Fire
//
//  Created by Hayden on 2016-01-18.
//  Copyright © 2016 Hayden Holligan. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    
    var recipe: Recipe? = nil

    @IBOutlet var name: UITextField!
    @IBOutlet var ingredients: UITextView!
    @IBOutlet var instructions: UITextView!
    @IBOutlet var numberTimesMade: UILabel!
    
    @IBOutlet var recipeImage: UIImageView!
    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func crementerPressed(sender: UIButton) {
        
    }
    
    @IBAction func addImage(sender: UIButton) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
