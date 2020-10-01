//
//  MemeEditorView.swift
//  MemeMe1.0
//
//  Created by Cédric Morier-Roy on 2020-10-01.
//

import UIKit

class MemeEditorView: UIViewController {

    //nav bar button outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //Image view outlet
    @IBOutlet weak var imageView: UIImageView!
    
    //Text field outlets
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    //Toolbar button outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //Disable camera button if there is no camera on device.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
                
    }
    


}

