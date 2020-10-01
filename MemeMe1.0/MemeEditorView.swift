//
//  MemeEditorView.swift
//  MemeMe1.0
//
//  Created by Cédric Morier-Roy on 2020-10-01.
//

import UIKit

class MemeEditorView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    //MARK: Text attributes
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeWidth:  -3.0,
        NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeColor: UIColor.black,
        ]
    
    private let defaultTopText = "TOP"
    private let defaultBottomText = "BOTTOM"
    private var topDefaultErased = false
    private var bottomDefaultErased = false

    //MARK: OUTLETS
    //nav bar button outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //image view
    @IBOutlet weak var imageView: UIImageView!
    
    //Text field outlets
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    //Toolbar button outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    
    //Navbar/toolbar outlets
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    //MARK: General functions
    func enableShare(_ isEnabled: Bool)
    {
        shareButton.isEnabled = isEnabled
    }
    
    func resetText()
    {
        //set default text
        topText.text! = defaultTopText
        bottomText.text! = defaultBottomText
        topDefaultErased = false
        bottomDefaultErased = false
    }
    
    //MARK: LIFECYCLE FUNCTIONS
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Set text attributes
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        //get rid of text border
        topText.borderStyle = .none
        bottomText.borderStyle = .none
        
        //center text
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        
        resetText()
        
        //set text delegates
        topText.delegate = self
        bottomText.delegate = self
        
        //disable sharing function
        enableShare(false)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //Disable camera button if there is no camera on device.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Keyboard handling
    func subscribeToKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //NOTE: Only show and hide keyboard if the bottom text is editing
    @objc func keyboardWillShow(_ notification:Notification)
    {
        if bottomText.isEditing
        {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification)
    {
        if bottomText.isEditing
        {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: Toolbar actions/functions
    @IBAction func selectImageFromLibrary()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromCamera()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: {() in self.enableShare(true)})
    }
    
    //MARK: Navbar actions/functions
    @IBAction func cancel()
    {
        resetText()
        imageView.image = UIImage()
        enableShare(false)
    }
    
    @IBAction func share()
    {
        let controller = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
    
        controller.completionWithItemsHandler = { (activity, success, items, error) in  self.save()}
        
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: Saving the meme
    func save()
    {
        // Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, origImage: imageView.image!, memedImage: generateMemedImage())
        
        print("No use for meme yet.")
    }
    
    //MARK: Generating meme image
    func generateMemedImage() -> UIImage {
        
        //hide bars
        toolbar?.isHidden = true
        navbar?.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show bars
        toolbar?.isHidden = false
        navbar?.isHidden = false
        
        return memedImage
    }
    
    //MARK: UITextfield Delegate methods
    //Clear text field when the user starts typing (only the first time around)
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.text == defaultTopText && !topDefaultErased
        {
            textField.text = ""
            topDefaultErased = true
        }
        else if textField.text == defaultBottomText && !bottomDefaultErased
        {
            textField.text = ""
            bottomDefaultErased = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
}
