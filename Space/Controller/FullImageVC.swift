//
//  FullImageVC.swift
//  Space
//
//  Created by Preeteesh Remalli on 04/09/21.
//

import UIKit

class FullImageVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var url : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = try? Data(contentsOf: URL(string: (self.url))!){
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
