//
//  NetworkingManager.swift
//  Awareness
//
//  Created by Sushma on 3/30/16.
//  Copyright © 2016 Sush. All rights reserved.
//

import Foundation

enum HTTPMethod: Int {
    case Post = 0,
    Get = 1,
    Put = 2,
    Delete = 3
}

class NetworkingManager: NSObject {
    
    class var baseURL: String {
        return "https://data.sfgov.org/resource/tmnf-yvry.json"
    }
    
    class func request(httpmethod: HTTPMethod,
          completionClosure:(code: Int, message: String?, response: AnyObject?) -> ()) {
            request(httpmethod, currentHttpPath: "", parameterPath: [:], httpBody: [:], customHeaders: [:]) { (code, message, response) -> () in
                completionClosure(code: code, message: message, response: response)
            }
    }
    
    class func request(httpmethod: HTTPMethod,
                  currentHttpPath: String,
                    parameterPath: [String: AnyObject],
                         httpBody: AnyObject,
                    customHeaders: [String: String],
                completionClosure:(code: Int, message: String?, response: AnyObject?) -> ()) {
        
        let httpOptions = ["POST", "GET", "PUT", "DELETE"]
        var requestBodyData: NSData?
        
        var path = baseURL + currentHttpPath
        
        if parameterPath.count > 0 {
            var pathToAppendToCurrentPath: String = "";
            
            for key in parameterPath.keys {
                if !pathToAppendToCurrentPath.isEmpty {
                    pathToAppendToCurrentPath += "/"
                }
                pathToAppendToCurrentPath = (parameterPath[key]! as! String) as String
            }
            
            if pathToAppendToCurrentPath.characters.count != 1 {
                path = path + pathToAppendToCurrentPath
            }
        }
        
        let url: NSURL = NSURL(string: path)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        if httpBody.count > 0 {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                requestBodyData = try NSJSONSerialization.dataWithJSONObject(httpBody, options: NSJSONWritingOptions())
                
                do {
                    try NSJSONSerialization.JSONObjectWithData(requestBodyData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    
                } catch let error as NSError? {
                    completionClosure(code: 0, message: "Error with getting JSON data", response: (error?.userInfo)!)
                }
            } catch let error1 as NSError? {
                completionClosure(code: 0, message: "Error with JSON", response: (error1?.userInfo)!)
                return
            }
        } // if parameters
        
        request.HTTPMethod = httpOptions[httpmethod.rawValue]
        request.HTTPBody = requestBodyData
        
        if customHeaders.count > 0 {
            for key in customHeaders.keys {
                request.setValue(customHeaders[key], forHTTPHeaderField:key)
            }
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse?, data: NSData?, connectionError: NSError?) -> Void in
            if let error = connectionError {
                completionClosure(code: error.code, message: error.localizedDescription, response: error.userInfo)
            } else {
                
                do {
                    
                    let httpResponse = (response as! NSHTTPURLResponse).statusCode
                    
                    if data?.length == 0  && httpResponse == 200 {
                        //Success but response body is null
                        completionClosure(code: 200, message:"Success" , response: 0)
                        
                    }else{
                        
                        let responseDictionary  = try  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        if  responseDictionary.isKindOfClass(NSDictionary){
                            
                            completionClosure(code: httpResponse, message: responseMessage(responseDictionary as! NSDictionary,code: httpResponse) , response: responseDictionary as! NSDictionary)
                            
                        } else {
                            completionClosure(code: httpResponse, message:"Success" , response: responseDictionary)
                        }
                    }
                    
                } catch  let error as NSError {
                    completionClosure(code: error.code, message: error.localizedDescription, response: nil)
                }
            }
        }
    }
    
    //check if error in the message
    class func responseMessage(response: NSDictionary, code: Int) -> String {
        
        if let val = response["error"] {
            return val as! String
        } else if code == 422{
            return response["message"]?.valueForKey("message") as! String
        }
        else {
            return "Success"
        }
    }


}
