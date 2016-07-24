//
//  TableViewController.swift
//  MemeMe v1.0
//
//  Created by Arif Khan on 3/1/16.
//  Copyright © 2016 Snnab. All rights reserved.
//

import UIKit
import Foundation


class MemeTableViewController:  UITableViewController {
    
    @IBAction func AddMeme(sender: AnyObject) {
        performSegueWithIdentifier("SendMemeSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView!.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
    
        return appDelegate.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
    
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell!.textLabel?.text = appDelegate.memes[indexPath.row].topText
        cell!.imageView?.image = appDelegate.memes[indexPath.row].originalImage
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       self.performSegueWithIdentifier("SendDataSegue", sender: self)
    }
    
    //Added segue to provide detail view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print (segue.identifier)
        
         if segue.identifier == "SendDataSegue" {
            
        if let destination = segue.destinationViewController as? MemeDetailViewController {
            let path = tableView.indexPathForSelectedRow
            let cell = tableView.cellForRowAtIndexPath(path!)
            destination.topText = (cell?.textLabel?.text!)!
            destination.image = (cell?.imageView?.image)!
            }
        }
     
    }
    
}
