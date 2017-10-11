//
//  ViewController.swift
//  Bitcoin Price Checker
//
//  Created by Joanne Lim on 9/10/17.
//  Copyright © 2017 Vositive Solutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var currency = ["NOK","USD","GBP","AUD","SEK","SGD"]
    var baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var finalURL = ""
    var selectedCurrency = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }

    //Alamofire networking
    func getBitcoinData(url:String){
        Alamofire.request(url, method:.get).responseJSON { response in
            if response.result.isSuccess {
                print("Alamofire worked")
                let bitcoinJSON: JSON = JSON(response.result.value!)
                self.updateBitcoinData(json: bitcoinJSON)
            } else {
                print("Error: \(String(describing:response.result.error))")
                self.priceLabel.text = "Connection Error, please try again later"
            }
        }
    }
    
    //SwiftyJSON parsing data
    func updateBitcoinData(json:JSON){
        if let bitcoinResult = json["ask"].double {
            priceLabel.text = selectedCurrency + " " + String(bitcoinResult)
        } else {
            self.priceLabel.text = "Price not available, please try again later"
        }
    }
    
}

//Pickerview protocol
extension ViewController: UIPickerViewDataSource,UIPickerViewDelegate{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseUrl + currency[row]
        selectedCurrency = currency[row]
        getBitcoinData(url: finalURL)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: currency[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
    }
}
