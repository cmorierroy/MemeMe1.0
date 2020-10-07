//
//  SentMemeViewController.swift
//  MemeMe2.0
//
//  Created by Cédric Morier-Roy on 2020-10-05.
//

import UIKit

class SentMemeViewController : UIViewController
{
    var memes: [Meme]!
    {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
}


