//
//  ScrollVC.swift
//  Space
//
//  Created by Preeteesh Remalli on 06/09/21.
//

import UIKit
import WebKit


class ScrollVC: UIViewController{
   
    @IBOutlet weak var outer: UIImageView!
    @IBOutlet weak var inner: UIImageView!
    override func viewDidLoad() {
         super.viewDidLoad()
 
      }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //titleLbl.text = self.user?.username
        // Animate orbits to slowly rotate
        outer.startRotating(duration: 25, clockwise: false, delay: 1)
        inner.startRotating(duration: 20, clockwise: true, delay: 1)
    }
    }
    
    


