//
//  PictureTableViewCell.swift
//  Space
//
//  Created by Preeteesh Remalli on 04/09/21.
//

import UIKit
var cache = NSCache<AnyObject, AnyObject>()

class PictureTableViewCell: UITableViewCell {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var pictureTitle: UILabel!

    @IBOutlet weak var pictureDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ picture: AstronomyPictureViewModel){   
        self.pictureTitle.text = picture.title
        self.pictureDescription.text = picture.explanation
        
        if let image = cache.object(forKey: picture.title as AnyObject){
            self.pictureImageView.image = image as? UIImage
        }else{
            DispatchQueue.global(qos: .background).async { [self] in
      
                if let data = picture.picImage{
                    DispatchQueue.main.async {
                        self.pictureImageView.image = UIImage(data: data)
                        cache.setObject(UIImage(data: data) as AnyObject, forKey: picture.title as AnyObject)
                    }
                }
                
            }
        }
    }

}
