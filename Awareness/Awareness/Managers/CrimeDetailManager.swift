//
//  CrimeDetailManager.swift
//  Awareness
//
//  Created by Sushma on 3/30/16.
//  Copyright © 2016 Sush. All rights reserved.
//

import Foundation
import MapKit

class CrimeDetailManager: NSObject {
    
    func getCrimeData(closure:(message: String?, response: [CrimeDetail]) -> ()) {
        NetworkingManager.request(HTTPMethod.Get) { (code, message, response) -> () in
            
            guard response is NSArray else {
                closure(message: "BadData", response: [])
                return
            }
            closure(message: "Success", response: self.createCrimeDetailObject(response as! NSArray))
        }
    }
    
    
    //create the crimeDetailObject
    func createCrimeDetailObject(response: NSArray) -> [CrimeDetail] {
        var crimeDataArr = [CrimeDetail]()
        var dictOfDistrictAndCount = [String: Int]()
        var dictOfDistrictAndRank = [String: Int]()
       
        for crimeData in response {
            let crimeDetail = CrimeDetail()
            
            if let title = crimeData["pddistrict"] as? String {
                crimeDetail.title = title
                crimeDetail.district = title
            }
            
            if let address = crimeData["address"] as? String {
                crimeDetail.locationName = address
            }
            
            let latitude = crimeData["y"] as? String
            let longitude = crimeData["x"] as? String
            
            
            crimeDetail.coordinate = CLLocationCoordinate2D(latitude: Double(latitude!)!,longitude: Double(longitude!)!)
            
            //add it to the array only if the data is within 30 days
            if Helper.isDateWithinPast30Days((crimeData["date"] as? String)!) {
                crimeDataArr.append(crimeDetail)
                
                //since cannot write group by and count and no api available for same
                // get count of crimes in each district and add it to the dictionary
                if var val = dictOfDistrictAndCount[crimeDetail.district] {
                    dictOfDistrictAndCount[crimeDetail.district] = ++val
                } else {
                    dictOfDistrictAndCount[crimeDetail.district] = 1
                }
            }
        }
    
        //sort the dictionary in desecending order
        let sortedDict = dictOfDistrictAndCount.sort(Helper.sortByValue)
       
        //create a dictionary of district and rank by max number of crimes
        var i = 0
        for val in sortedDict {
            dictOfDistrictAndRank[val.0] = i++
        }
      
        //assign the rank to each crimedetail record
        for crime in crimeDataArr {
            crime.rank = dictOfDistrictAndRank[crime.district]!
        }
        
        return crimeDataArr
    }    
}
