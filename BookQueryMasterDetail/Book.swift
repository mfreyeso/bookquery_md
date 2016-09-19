//
//  Book.swift
//  BookQueryMasterDetail
//
//  Created by Mario on 18/09/16.
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
    
    func modifyCoverURL(url: String?){
        if url != nil {
            self.coverUrl = url
        }else{
            var isbnFormat :String = ""
            for element in self.codeISBN!.characters.split("-").map(String.init){
                isbnFormat = isbnFormat + element
            }
            self.coverUrl = "http://covers.openlibrary.org/b/isbn/" + isbnFormat + "-L.jpg"
        }
    }
    
    func getDataImage(){
        let url = NSURL(string: coverUrl!)
        if let dataImage = NSData(contentsOfURL: url!) {
            coverImage = UIImage(data: dataImage)
        }
    }
    
}