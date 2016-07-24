//
//  CollectionViewController.swift
//  MemeMe v1.0
//
//  Created by Arif Khan on 3/15/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView!.reloadData()
    }
    
    @IBAction func AddMeme(sender: AnyObject) {
        performSegueWithIdentifier("SendMemeSegue", sender: self)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        return appDelegate.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
       
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        let labelTop = cell.viewWithTag(1) as! UILabel
        labelTop.text = appDelegate.memes[indexPath.row].topText
        
        let image = cell.viewWithTag(2) as! UIImageView
        image.image = appDelegate.memes[indexPath.row].originalImage
        
        let labelBottom = cell.viewWithTag(3) as! UILabel
        labelBottom.text = appDelegate.memes[indexPath.row].bottomText
        
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("SendDataSegue", sender: self)
    }
    
    //Added segue to provide detail view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SendDataSegue" {
            
            if let destination = segue.destinationViewController as? MemeDetailViewController {
                
                for item in self.collectionView!.visibleCells() as [UICollectionViewCell] {
                    let indexpath : NSIndexPath = self.collectionView!.indexPathForCell(item as UICollectionViewCell)!
                    let cell : UICollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexpath)! as UICollectionViewCell
                    
                    let labelTop = cell.viewWithTag(1) as! UILabel
                    destination.topText = labelTop.text!
                    
                    let imageView = cell.viewWithTag(2) as! UIImageView
                    destination.image = imageView.image
                    
                    let labelBottom = cell.viewWithTag(3) as! UILabel
                    destination.bottomText = labelBottom.text!
                }
            }
        }
    }
    
 }
