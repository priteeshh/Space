//
//  FavoriteCategoryVC.swift
//  Space
//
//  Created by Preeteesh Remalli on 06/09/21.
//

import UIKit
import CoreData

class FavoriteCategoryVC: UITableViewController {
    
    var categories = [Category]()
    let CDhelp = CoreDataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = CDhelp.loadCategories()
        tableView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FavoritePicturesVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in
            
            CDhelp.saveCategories(textField.text!) { isSuccess in
                print("Saved categery")
                self.categories = CDhelp.loadCategories()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
        
    }
}
extension FavoriteCategoryVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
}
