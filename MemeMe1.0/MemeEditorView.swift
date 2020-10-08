//
//  MemeEditorView.swift
//  MemeMe2.0
//
//  Created by Cédric Morier-Roy on 2020-10-01.
//

import UIKit

class MemeEditorView: UIViewController
{
    //MARK: Text attributes
    private let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeWidth:  -3.0,
        NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeColor: UIColor.black,
        ]
    
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    var topDefaultErased = false
    var bottomDefaultErased = false

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
    func toggleBars(isHidden: Bool)
    {
        toolbar?.isHidden = isHidden
        navbar?.isHidden = isHidden
    }
    
    func enableShare(_ isEnabled: Bool)
    {
        shareButton.isEnabled = isEnabled
    }
    
    private func configureTextFieldAttributes(_ textField: UITextField)
    {
        textField.defaultTextAttributes = memeTextAttributes
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    private func resetText(_ textField: UITextField, _ defaultText:String)
    {
        textField.text! = defaultText
        
        if defaultText == defaultTopText
        {
            topDefaultErased = false
        }
        else if defaultText == defaultBottomText
        {
            bottomDefaultErased = false
        }
        else
        {
            print("ERROR: Invalid default text.")
        }
    }
    
    private func configure(_ textField: UITextField, with defaultText: String)
    {
        
        configureTextFieldAttributes(textField)
        resetText(textField, defaultText)
    }
    
    //MARK: LIFECYCLE FUNCTIONS
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configure(topText, with: defaultTopText)
        configure(bottomText, with: defaultBottomText)
        
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
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: Toolbar actions/functions
    @IBAction func selectImageFromLibrary()
    {
        pickAnImage(from: .photoLibrary)
    }
    
    @IBAction func selectImageFromCamera()
    {
        pickAnImage(from: .camera)
    }
    
    private func pickAnImage(from source: UIImagePickerController.SourceType)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Navbar actions/functions
    @IBAction private func cancel()
    {
        resetText(topText, defaultTopText)
        resetText(bottomText, defaultBottomText)
        
        imageView.image = UIImage()
        enableShare(false)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func share()
    {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
    
        controller.completionWithItemsHandler =
            { (activity, success, items, error) in
                if success
                {
                    self.save(memedImage)
                }
            }
        
        self.present(controller, animated: true, completion: nil)
    }
    
    //MARK: Saving the meme
    private func save(_ memedImage: UIImage)
    {
        // Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, origImage: imageView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //MARK: Generating meme image
    func generateMemedImage() -> UIImage {
        
        //hide bars
        toggleBars(isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show bars
        toggleBars(isHidden: false)
        
        return memedImage
    }
}
