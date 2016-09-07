//
//  MasterViewController.swift
//  BookQueryMasterDetail
//
//  Created by Mario on 4/09/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    private var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "BookQuery"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    
    func requestData(codeISBN: String) ->Book?{
        var book :Book? = nil
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + codeISBN
        let url = NSURL(string: urls)
        let data = NSData(contentsOfURL: url!)
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)
            let result = json as! NSDictionary
            let keyBook = "ISBN:" + codeISBN
            if let valuesBook = result[keyBook] {
                book = buildBook(valuesBook as! NSDictionary, code: codeISBN)
            }
        }catch _ {
            print("Error")
        }
        return book
        
    }
    
    func buildBook(data: NSDictionary, code: String) ->Book{
        var authorsValue = "The data not contain authors"
        var title :String = "The data not contain title"
        var cover :String? = nil
        
        if (data.valueForKey("authors") != nil) {
            authorsValue = ""
            let authors = data["authors"] as! NSArray as Array
            for var author in authors{
                author = author as! NSDictionary
                let name = author["name"] as! NSString as String
                authorsValue = authorsValue + name + " "
            }
        }
        
        if (data.valueForKey("title") != nil){
            title = data["title"] as! NSString as String
        }
        
        if (data.valueForKey("cover") != nil){
            let coverDict = data["cover"] as! NSDictionary
            cover = coverDict["large"] as! NSString as String
        }
        
        let bookObject = Book(title: title, authors: authorsValue, code: code)
        if cover != nil{
            bookObject.modifyCoverURL(cover!)
        }
        return bookObject
        
    }
    
    
    
    func insertNewObject(sender: AnyObject) {
        let alertController = UIAlertController(title: "New Search", message: "Insert a ISBN code", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Search", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            let code = firstTextField.text!
            
            if code != ""{
                if Reachability.isConnectedToNetwork(){
                    let bookObtained :Book? = self.requestData(code)
                    if bookObtained != nil {
                        
                        bookObtained!.getDataImage()
                        self.books.insert(bookObtained!, atIndex: 0)
                        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        
                        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("DetailBookController") as! DetailViewController
                        
                        controller.book = self.books[0]
                        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                        controller.navigationItem.leftItemsSupplementBackButton = true
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                    else{
                        let alertController = UIAlertController(title: "Error in Request", message: "The data were not obtained.", preferredStyle: UIAlertControllerStyle.Alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                            print("OK button tapped")
                        })
                        alertController.addAction(okAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                    }
                }else{
                    let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                        print("OK button tapped")
                    })
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
            }else{
                let alertController = UIAlertController(title: "Error", message: "You must write the ISBN code.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in
                    print("OK button tapped")
                })
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Code ISBN"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.books[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.book = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.books[indexPath.row]
        // TODO render Title of Book
        cell.textLabel!.text = object.title
    }
    
}