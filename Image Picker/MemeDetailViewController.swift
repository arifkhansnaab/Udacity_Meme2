//
//  TableDetailViewController.swift
//  Meme v2.0
//
//  Created by Arif Khan on 4/3/16.
//  Copyright © 2016 Snnab. All rights reserved.
//


import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
    
    var topText = ""
    var bottomText = ""
    var image : UIImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //topLabel.text = topText
        //bottomLabel.text = bottomText
        memeImage.image = image
        memeImage.contentMode = .ScaleAspectFit
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}
