//
//  BookmarkTableViewController.swift
//  Bookmarks REST Client
//
//  Created by Brook Li on 3/28/18.
//  Copyright © 2018 Brook Li. All rights reserved.
//

import UIKit

class BookmarkTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var bookmarks = [Bookmark]()
    
    // MARK: Actions
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if usernameTextField.text != nil{
            getDataFromRest(usernameTextField.text!)
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        loadSampleData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath) as? BookmarkTableViewCell else{
            fatalError("The cell is not an instance of BookmarkTableViewCell.")
        }
        let bookmark = bookmarks[indexPath.row]
        cell.descriptionLabel.text = bookmark.description
        cell.uriLabel.text = bookmark.uri
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private methods
    private func loadSampleData(){
        let sample = Bookmark(id: 0, uri: "http://www.sampleurl.com", description: "Sample description")
        bookmarks = [sample]
    }
    
    private func getDataFromRest(_ username: String){
        let endpoint = "http://192.168.1.4:8080/\(username)/bookmarks"
        guard let url = URL(string: endpoint) else{
            fatalError("Error creating URL")
        }
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            guard error == nil else{
                DispatchQueue.main.async {
                    self.titleLabel.text = "Error occurred while retriving data."
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                fatalError("Reponse returned from HTTP request is not of type HTTPURLResponse.")
            }
            if(httpResponse.statusCode >= 400 && httpResponse.statusCode < 500){
                DispatchQueue.main.async {
                    self.titleLabel.text = "User not found."
                }
                return
            }
            guard let responseData = data else{
                DispatchQueue.main.async {
                    self.titleLabel.text = "No data returned by server."
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let newBookmarks = try decoder.decode([Bookmark].self, from: responseData)
                self.bookmarks = newBookmarks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.titleLabel.text = "Displaying bookmarks for user: \(username)"
                }
            }
            catch{
                DispatchQueue.main.async {
                    self.titleLabel.text = "Error decoding data from server."
                }
            }
        })
        task.resume()
    }

}
