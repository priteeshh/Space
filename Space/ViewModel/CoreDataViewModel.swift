//
//  CoreDataViewModel.swift
//  Space
//
//  Created by Preeteesh Remalli on 07/09/21.
//

import UIKit
import CoreData
struct CoreDataViewModel{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveItem(_ picture: AstronomyPictureViewModel, _ category : Category, _ completion : (Bool) -> ()){
        let newItem = Item(context: self.context)
        newItem.title = picture.title
        newItem.done = false
        newItem.url = picture.url
        newItem.media_type = picture.media_type
        newItem.hdurl = picture.hdurl
        newItem.explanation = picture.explanation
        newItem.date = picture.date
        newItem.copyright = picture.copyright
        newItem.parentCategory = category
        newItem.image = picture.picImage
        do {
            try context.save()
            completion(true)
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadCategories() -> [Category] {
        var categories = [Category]()

        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        return categories
    }
    
    func saveCategories(_ newValue : String, _ completion : (Bool) -> ()) {
        var categories = loadCategories()
        let newCategory = Category(context: self.context)
        newCategory.name = newValue
        categories.append(newCategory)

        do {
            try context.save()
            completion(true)
        } catch {
            print("Error saving category \(error)")
        }
    }
    
}
