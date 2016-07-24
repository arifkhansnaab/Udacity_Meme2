//
//  ViewController.swift
//  Image Picker
//
//  Created by Arif Khan on 9/9/15.
//  Copyright (c) 2015 Snnab. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
   
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextBox: UITextField!
    @IBOutlet weak var bottomTextBox: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showActivityController(sender: AnyObject) {
        var memedImage: UIImage
        memedImage = generateMemedImage()
        
        //Create UI View Controller
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        //Completion handler to ensure that only in case of success we persist data in AppDelegate
        activityController.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if (success) {
                //Save only in case user didn't cancel out
                self.save()
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
        topTextBox.clearsOnBeginEditing = true
        bottomTextBox.clearsOnBeginEditing = true
        
        //Set the text field delegate, so that return key bring down the keyboard
        topTextBox.delegate = self
        bottomTextBox.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        setupTextField(topTextBox, defaultText: "TOP")
        setupTextField(bottomTextBox, defaultText: "BOTTOM")
        
        subscribeToKeyboardNotifications()
    }
    
    func setupTextField(textField: UITextField, defaultText: String) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSStrokeWidthAttributeName: -3.0,
            ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.text = defaultText
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickImageFromLibrary(sender: AnyObject) {
        pickImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        pickImage(UIImagePickerControllerSourceType.Camera)
    }
    
    func pickImage(imageControllerSourceType: UIImagePickerControllerSourceType)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = imageControllerSourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextBox.isFirstResponder(){
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
         if bottomTextBox.isFirstResponder(){
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .ScaleAspectFit
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func save() {
        var memedImage: UIImage
        memedImage = generateMemedImage()
        
       
        let meme = Meme(topText: topTextBox.text!, bottomText: bottomTextBox.text!, originalImage: imagePickerView.image, memedImage: memedImage)
        
        //Add image to memes array
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide the toolbar
        tabBarController?.tabBar.hidden = true
        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show the toolbar
        tabBarController?.tabBar.hidden = false
        
        return memedImage
    }
}

