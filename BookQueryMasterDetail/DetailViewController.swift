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
    
    
    override func viewWillAppear(animated: Bool) {
        detailDescriptionLabel.text = book!.title!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

