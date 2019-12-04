//
//  ViewController.swift
//  Stock_Market_App
//
//  Created by Jeel Patel on 2019-12-04.
//  Copyright © 2019 Jeel Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!

    @IBOutlet weak var stockTextInput: UITextField!
    
    //MARK: IBActions
    //neglect this one
    @IBAction func symbol_input(_ sender: UITextField) {    }
    
    //Action function
    @IBAction func stockSearchTapped(_ sender: UIButton) {
        getStockData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getStockData() {
        
        let API_KEY = "XYTWT16LRSPT3A38"
        let session = URLSession.shared
        let quoteURL = URL(string:"https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=\(stockTextInput.text ?? "")&apikey=\(API_KEY)")!
        
        let dataTask = session.dataTask(with: quoteURL) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error:\n\(error)")
            } else {
                if let data = data {
                    let dataString = String(data: data, encoding: String.Encoding.utf8)
                    print("All the quote data:\n\(dataString!)")
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                        if let quoteDictionary = jsonObj.value(forKey: "Global Quote") as? NSDictionary {
                            DispatchQueue.main.async {
                                if let symbol = quoteDictionary.value(forKey: "01. symbol") {
                                    self.symbolLabel.text = symbol as? String
                                }
                                if let open = quoteDictionary.value(forKey: "02. open") {
                                    self.openLabel.text = open as? String
                                }
                                if let high = quoteDictionary.value(forKey: "03. high") {
                                    self.highLabel.text = high as? String
                                }
                                if let low = quoteDictionary.value(forKey: "04. low") {
                                    self.lowLabel.text = low as? String
                                }
                                if let price = quoteDictionary.value(forKey: "05. price") {
                                    self.priceLabel.text = price as? String
                                }
                            }
                        } else {
                            print("Error: unable to find quote")
                            DispatchQueue.main.async {
                                self.resetLabels()
                            }
                        }
                    } else {
                        print("Error: unable to convert json data")
                        DispatchQueue.main.async {
                            self.resetLabels()
                        }
                    }
                } else {
                    print("Error: did not receive data")
                    DispatchQueue.main.async {
                        self.resetLabels()
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func resetLabels() {
        symbolLabel.text = ""
        openLabel.text = ""
        highLabel.text = ""
        lowLabel.text = ""
        priceLabel.text = ""
    }

}

