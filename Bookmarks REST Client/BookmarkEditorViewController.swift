//
//  BookmarkEditorViewController.swift
//  Bookmarks REST Client
//
//  Created by Brook Li on 4/4/18.
//  Copyright © 2018 Brook Li. All rights reserved.
//

import UIKit

class BookmarkEditorViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Properties
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var uriField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: Actions
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let username = usernameField.text ?? ""
        let uri = uriField.text ?? ""
        let description = descriptionField.text ?? ""
        if !username.isEmpty && !uri.isEmpty && !description.isEmpty{
            postData(username: username, uri: uri, description: description)
        }
        else{
            statusLabel.text = "All fields must be filled"
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        usernameField.text = ""
        uriField.text = ""
        descriptionField.text = ""
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    private func postData(username: String, uri: String, description: String){
        let outgoingBookmark = OutgoingBookmark(uri: uri, description: description)
        let encoder = JSONEncoder()
        let endpoint = "http://192.168.1.4:8080/\(username)/bookmarks"
        guard let url = URL(string: endpoint) else{
            fatalError("Error creating URL")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let json = try encoder.encode(outgoingBookmark)
            urlRequest.httpBody = json
        }
        catch{
            fatalError("Error encoding JSON from OutgoingBookmark struct.")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            guard error == nil else{
                DispatchQueue.main.async {
                    self.statusLabel.text = "Error occurred while sending data."
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                fatalError("Response return from HTTP request is not of HTTPURLResponse.")
            }
            if httpResponse.statusCode >= 400 && httpResponse.statusCode < 500 {
                DispatchQueue.main.async {
                    self.statusLabel.text = "User not found."
                }
            }
            else if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300{
                DispatchQueue.main.async {
                    self.statusLabel.text = "Bookmark successfully added."
                }
            }
        })
        task.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
