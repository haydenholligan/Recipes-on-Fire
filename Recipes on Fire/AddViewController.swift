//
//  AddViewController.swift
//  Recipes on Fire
//
//  Created by Hayden on 2016-01-18.
//  Copyright © 2016 Hayden Holligan. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore
class AddViewController: UIViewController, NSFetchedResultsControllerDelegate,
                         UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                         UITextViewDelegate {
    
    var recipe: Recipe? = nil
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet var name: UITextField!
    @IBOutlet var ingredients: UITextView!
    @IBOutlet var instructions: UITextView!
    
    @IBOutlet var recipeImage: UIImageView!
    
    
    @IBOutlet var addFromCameraButton: UIButton!
    @IBOutlet var addFromImageButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        if recipe != nil {
            name.text = recipe?.name
            ingredients.text = recipe?.ingredients
            instructions.text = recipe?.instructions
            recipeImage.image = UIImage(data: (recipe?.image)!)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ingredients.setContentOffset(CGPointZero, animated: false)
        instructions.setContentOffset(CGPointZero, animated: false)
    }
    
    func setupAppearance() {
        ingredients.layer.cornerRadius = 4.0
        ingredients.layer.borderColor = UIColor.blackColor().CGColor
        ingredients.layer.borderWidth = 1.0
        
        instructions.layer.cornerRadius = 4.0
        instructions.layer.borderColor = UIColor.blackColor().CGColor
        instructions.layer.borderWidth = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.recipeImage.image = image
    }
    
    //TODO
    @IBAction func crementerPressed(sender: UIButton) {
        if sender.tag == 1 {
            //recipe?.numberTimesMade! = recipe?.numberTimesMade! + 1
        } else if sender.tag == -1 {
            
        }
    }
    
    @IBAction func addImage(sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        if sender.tag == 1 {
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        } else if sender.tag == 2 {
            pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        pickerController.allowsEditing = true
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }

    @IBAction func saveRecipe(sender: UIBarButtonItem) {
        if recipe != nil {
            editRecipe()
        } else {
            createNewRecipe()
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func createNewRecipe() {
        let entityDescription = NSEntityDescription.entityForName("Recipe", inManagedObjectContext: managedObjectContext)
        let recipe = Recipe(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        recipe.name = name.text
        recipe.ingredients = ingredients.text
        recipe.instructions = instructions.text
        if (recipeImage.image != nil) {
            recipe.image = UIImagePNGRepresentation(recipeImage.image!)
        } else {
            recipe.image = UIImagePNGRepresentation(UIImage(named: "Placeholder Dark")!)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Couldn't create new recipe")
        }
    }
    
    func editRecipe() {
        recipe?.name = name.text
        recipe?.ingredients = ingredients.text
        recipe?.instructions = instructions.text
        recipe!.image = UIImagePNGRepresentation(recipeImage.image!)
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Couldn't edit recipe")
        }
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)

    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text == "Ingredients" ||
            textView.text == "Instructions" {
                textView.text = ""
        }
        return true
    }

}
