//
//  DetailViewController.swift
//  BookQueryMasterDetail
//
//  Created by Mario on 4/09/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var book :Book?
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var coverBook: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        detailDescriptionLabel.text = book!.title!
        authorLabel.text = book!.authors!
        
        if book!.coverImage != nil {
            coverBook.image = book!.coverImage
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Information"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

