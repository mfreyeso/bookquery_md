//
//  Book.swift
//  BookQueryMasterDetail
//
//  Created by Mario on 5/09/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit
import Foundation

class Book {
    var title :String? = nil
    var authors :String? = nil
    var coverUrl :String? = nil
    var codeISBN :String? = nil
    var coverImage : UIImage? = nil
    
    init(title: String, authors :String, code: String){
        self.title = title
        self.authors = authors
        self.codeISBN = code
    }
    
    func modifyCoverURL(url: String){
        self.coverUrl = url
    }
    
    func getDataImage(){
        if coverUrl != nil {
            let url = NSURL(string: coverUrl!)
            if let dataImage = NSData(contentsOfURL: url!) {
                coverImage = UIImage(data: dataImage)
            }
        }
    }
    
    
}