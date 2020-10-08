//
//  SentMemeCollectionViewController.swift
//  MemeMe2.0
//
//  Created by Cédric Morier-Roy on 2020-10-07.
//

import UIKit

class SentMemeCollectionViewController : SentMemeViewController
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //set the table view delegates
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("here collection")
        collectionView!.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
            super.viewWillTransition(to: size, with: coordinator)
        
            if UIDevice.current.orientation.isLandscape
            {
                adaptCellDimension(.portrait)
            }
            else
            {
                adaptCellDimension(.landscapeRight)
            }
    }
    
    func adaptCellDimension(_ orientation:UIDeviceOrientation)
    {
        let space:CGFloat = 3.0
        let dimension:CGFloat
        //adapt to portrait
        if(orientation.isLandscape)
        {
            dimension = (view.frame.size.height - (2 * space)) / 3.0
        }
        else //adapt to landscape
        {
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        }
        
        print(dimension)
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}

extension SentMemeCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! CustomCollectionViewCell

        cell.imageView?.image = memes[indexPath.row].memedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
            let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
            detailController.meme = memes[indexPath.row]
            navigationController?.pushViewController(detailController, animated: true)
    }
}
