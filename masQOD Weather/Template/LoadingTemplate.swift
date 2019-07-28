//
//  LoadingTemplate.swift
//  masQOD Weather
//
//  Created by Qodir Masruri on 28/07/19.
//  Copyright © 2019 Moonlay Technologies. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol ErrorProtocol {
    var action: String {get set}
    var errorModal: UIAlertController? {get set}
    
    func showError(errorMessage: String)
}

protocol KeyboardAdaptProtocol{
    var scrollView: UIScrollView {get set}
    
}

extension UIViewController {
    
    
    func popupAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func extractErrorMessage(resultError: JSON) -> String
    {
        var errorMessage: String = ""
        if let errorInfo = resultError["error"].string
        {
            errorMessage = errorInfo
        }
        if let errorInfo = resultError["errors"].dictionary{
            var errorMessages: [String] = []
            //If json is .Dictionary
            for (_,subJson):(String, JSON) in errorInfo {
                //Do something you want
                errorMessages.append(subJson.stringValue)
            }
            errorMessage = errorMessages.joined(separator: "\n")
        }
        if let errorInfo = resultError["message"].string{
            if errorInfo != ""{
                errorMessage = errorInfo
            }
            
        }
        
        return errorMessage
    }
    
    func errorCompletion(result: JSON, repo: Repository)
    {
        stopLoading()
        
        if let tableController = self as? UITableViewController{
            tableController.refreshControl?.endRefreshing()
        }
        
        if let controller = self as? ErrorProtocol{
            controller.showError(errorMessage: extractErrorMessage(resultError: result))
        }
        _ = repo.baseUrl
    }
    
    func startLoading(withRightSpinner: Bool = true)
    {
        stopLoading()
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        indicator.startAnimating()
        indicator.isHidden = false
        
        if(withRightSpinner)
        {
            let spinner = UIBarButtonItem()
            spinner.customView = indicator
            spinner.tag = 99
            
            if self.navigationItem.rightBarButtonItems != nil
            {
                self.navigationItem.rightBarButtonItems?.append(spinner)
            }
            else
            {
                self.navigationItem.rightBarButtonItem = spinner
            }
        }
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func stopLoading()
    {
        UIApplication.shared.endIgnoringInteractionEvents()
        if self.navigationItem.rightBarButtonItems != nil
        {
            var items = self.navigationItem.rightBarButtonItems!
            
            
            var selectedIndex = -1
            var index = 0
            for component in items {
                if(component.tag == 99)
                {
                    selectedIndex = index
                }
                index = index + 1
            }
            if(selectedIndex != -1)
            {
                items.remove(at: selectedIndex)
            }
            
            
            if items.count == 0
            {
                self.navigationItem.rightBarButtonItems = nil
            }
            else
            {
                self.navigationItem.rightBarButtonItems = items
            }
        }
        else
        {
            if self.navigationItem.rightBarButtonItem?.tag == 99
            {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func popupAlertInfo(with title: String, content: String, OkCallback: @escaping (() -> Void))
    {
        let popupAlert = UIAlertController(title: title, message: content, preferredStyle: UIAlertController.Style.alert)
        
        popupAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            OkCallback()
        }))
        
        present(popupAlert, animated: true, completion: nil)
    }
    
    func confirmationYesNo(with title: String, content: String, OkCallback: @escaping (() -> Void), CancelCallback: @escaping (() -> Void))
    {
        let refreshAlert = UIAlertController(title: title, message: content, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            OkCallback()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            CancelCallback()
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func replaceRootViewController(controller: UIViewController)
    {
        UIApplication.shared.keyWindow!.rootViewController = controller
    }
    
}
