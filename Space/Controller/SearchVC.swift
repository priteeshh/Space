//
//  SearchVC.swift
//  Space
//
//  Created by Preeteesh Remalli on 04/09/21.
//

import UIKit
import CoreData
import AVKit
import WebKit

class SearchVC:UIViewController {
    @IBOutlet weak var activtyIndicator: UIActivityIndicatorView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
    let CDhelp = CoreDataViewModel()
    var picture : AstronomyPictureViewModel?
    var webPlayer: WKWebView!

    var savedImageData : NSData?
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var selectedDate : String? {
        didSet{
            let serviceCall = AstronomyServiceCall()
            serviceCall.getPictureOfTheDay(date: selectedDate ?? Date().getFormattedDate(format: "yyyy-MM-dd")) { [self] pic in
                if let result = pic, result.title == "", result.url == ""{
                    
                    let alert = UIAlertController(title: "Error", message: "Not able to find Picture details for the selected day please try with other date!!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    picture = pic
                }
                self.configure()

            }
        }
    }
    
    var selectedPicture : AstronomyPictureViewModel? {
        didSet{
            self.picture = selectedPicture
        }
    }
    var savedPicture : Item? {
        didSet{
            let picture = AstronomyPictureModel(title: savedPicture?.title, url: savedPicture?.url, media_type: savedPicture?.media_type, hdurl: savedPicture?.hdurl, explanation: savedPicture?.explanation, date: savedPicture?.date, copyright: savedPicture?.copyright)
            self.picture = AstronomyPictureViewModel(picture)
            self.navigationItem.rightBarButtonItem = nil
            savedImageData = savedPicture?.image as NSData?
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        self.configure()
        self.activtyIndicator.startAnimating()
        self.activtyIndicator.isHidden = false
        
    }
    func configure(){
        DispatchQueue.main.async { [self] in
            self.titleLabel.text = picture?.title
            self.dateLabel.text = "Date: \(picture?.date ?? "")"
            self.descriptionLabel.text = picture?.explanation
            if picture?.media_type == "video"{
                let webConfiguration = WKWebViewConfiguration()
                        webConfiguration.allowsInlineMediaPlayback = true
                        
                        DispatchQueue.main.async {
                            self.webPlayer = WKWebView(frame: self.pictureImageView.bounds, configuration: webConfiguration)
                            self.pictureImageView.addSubview(self.webPlayer)
                            
                            guard let videoURL = URL(string: (picture?.url)!) else { return }
                            let request = URLRequest(url: videoURL)
                            self.webPlayer.load(request)
                            self.activtyIndicator.stopAnimating()
                            self.activtyIndicator.isHidden = true
                        }
            }else{
                
                if let savedImageDa = savedImageData{
                    self.pictureImageView.image = UIImage(data: savedImageDa as Data)
                    self.activtyIndicator.stopAnimating()
                    self.activtyIndicator.isHidden = true
                }else{
                    DispatchQueue.global(qos: .background).async { [self] in
                        if let image = cache.object(forKey: picture?.title as AnyObject){
                            DispatchQueue.main.async {
                                self.pictureImageView.image = image as? UIImage
                                self.activtyIndicator.stopAnimating()
                                self.activtyIndicator.isHidden = true
                            }
                        }else{
                            if let data = picture?.picImage{
                                DispatchQueue.main.async {
                                    self.pictureImageView.image = UIImage(data: data)
                                    self.activtyIndicator.stopAnimating()
                                    self.activtyIndicator.isHidden = true
                                }
                                cache.setObject(UIImage(data: data) as AnyObject, forKey: picture?.title as AnyObject)
                                
                            }
                        }
                    }
                }
            
            }
        }
    }
    
    @IBAction func addToFavorite(_ sender: Any) {
        categories = CDhelp.loadCategories()
        self.activtyIndicator.startAnimating()
        self.activtyIndicator.isHidden = false
        let alertView = UIAlertController(
            title: "Select item from list",
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert)
        let pickerView = UIPickerView(frame:CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        alertView.view.addSubview(pickerView)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: { [self] _ in
            let component = 0
            let row = pickerView.selectedRow(inComponent: component)
            _ = pickerView.delegate?.pickerView?(pickerView, titleForRow: row, forComponent: component)
            if let savePicture = picture{
                CDhelp.saveItem(savePicture, self.categories[row]) { isSuccess in
                    if isSuccess{
                        self.activtyIndicator.startAnimating()
                        self.activtyIndicator.isHidden = false
                        print("Saved successfully")
                    }
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertView.addAction(action)
        alertView.addAction(cancelAction)
        present(alertView, animated: true, completion: {
            pickerView.frame.size.width = alertView.view.frame.size.width
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FullImageVC
        destinationVC.url = (picture?.hdurl)!
    }
}
extension SearchVC : UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
}
