//
//  SentMemeTableViewController.swift
//  MemeMe2.0
//
//  Created by Cédric Morier-Roy on 2020-10-05.
//

import UIKit

class SentMemeTableViewController : SentMemeViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //set the table view delegates
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        //make sure all memes appear
        tableView!.reloadData()
    }
}

extension SentMemeTableViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //create as many rows as there are memes in the meme array
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")
        
        cell!.textLabel?.text = memes[indexPath.row].topText
        cell!.detailTextLabel?.text = memes[indexPath.row].bottomText
        cell?.imageView?.image = memes[indexPath.row].memedImage
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
    }
}
