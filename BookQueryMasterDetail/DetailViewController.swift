//
//  DetailViewController.swift
//  BookQueryMasterDetail
//
//  Created by Mario on 4/09/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var coverBook: UIImageView!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var titleBook: UILabel!


    var detailItem: AnyObject?

    
    override func viewWillAppear(animated: Bool) {
        if let detail = self.detailItem {
            titleBook.text = detail.valueForKey("title")!.description
            authors.text = detail.valueForKey("authors")!.description
            let image = UIImage(data: detail.valueForKey("image") as! NSData)
            coverBook.image = image
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

