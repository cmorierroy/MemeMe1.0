//
//  MemeDetailViewController.swift
//  MemeMe2.0
//
//  Created by Cédric Morier-Roy on 2020-10-07.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme:Meme = Meme(topText: "", bottomText: "", origImage: UIImage(), memedImage: UIImage())
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        imageView.image = meme.memedImage
    }

}
