//
//  ViewController.swift
//  Space
//
//  Created by Preeteesh Remalli on 03/09/21.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var astronomyPicturesTableVIew: UITableView!
    @IBOutlet weak var scrollViewHolder: UIView!
    var pictures = AstronomyPictureListViewModel(pictures: nil)
    
    
    let imagelist = ["1.jpeg", "2.jpeg", "3.jpeg", "4.jpeg", "5.jpeg"]
    var scrollView = UIScrollView()
    var yPosition:CGFloat = 0
    var scrollViewContentSize:CGFloat=0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        let serviceCall = AstronomyServiceCall()
        serviceCall.getPictures { pics in
            DispatchQueue.main.async { [self] in
                pictures = pics
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.astronomyPicturesTableVIew.reloadData()
            }
        }
        showScrollView()
        scheduledTimerWithTimeInterval()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        let myDatePicker: UIDatePicker = UIDatePicker()
        myDatePicker.datePickerMode = .date
        myDatePicker.maximumDate = Date()
        myDatePicker.preferredDatePickerStyle = .wheels
        myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        alertController.view.addSubview(myDatePicker)
        let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            
            let formate = myDatePicker.date.getFormattedDate(format: "yyyy-MM-dd")
            print(formate)
            
            
            self.performSegue(withIdentifier: "searchVC", sender: formate)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SearchVC
        if (sender as? String) != nil {
            destinationVC.selectedDate = sender as? String
        }
        else {
            destinationVC.selectedPicture = sender as? AstronomyPictureViewModel
        }
    }
}
extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
extension HomeVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.totalPictures() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath) as? PictureTableViewCell
        cell?.configureCell(pictures.pictureAtIndex(indexPath.row))
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "searchVC", sender: pictures.pictureAtIndex(indexPath.row))
    }
}
extension HomeVC{
    func showScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.size.height, width: self.view.frame.width, height: scrollViewHolder.frame.height))
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        for  i in stride(from: 0, to: imagelist.count, by: 1) {
            var frame = CGRect.zero
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(i)
            frame.origin.y = 0
            frame.size = self.scrollView.frame.size
            self.scrollView.isPagingEnabled = true
            
            let myImage:UIImage = UIImage(named: imagelist[i])!
            let myImageView:UIImageView = UIImageView()
            myImageView.image = myImage
            myImageView.contentMode = UIView.ContentMode.scaleToFill
            myImageView.frame = frame
            
            scrollView.addSubview(myImageView)
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(imagelist.count), height: self.scrollView.frame.size.height)
    }
    @objc func animateScrollView() {
        let scrollWidth = scrollView.bounds.width
        let currentXOffset = scrollView.contentOffset.x
        
        let lastXPos = currentXOffset + scrollWidth
        if lastXPos != scrollView.contentSize.width {
            scrollView.setContentOffset(CGPoint(x: lastXPos, y: 0), animated: true)
        }
        else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    func scheduledTimerWithTimeInterval(){
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.animateScrollView), userInfo: nil, repeats: true)
    }
}
