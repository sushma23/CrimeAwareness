//
//  CrimeDetail.swift
//  Awareness
//
//  Created by Sushma on 3/30/16.
//  Copyright © 2016 Sush. All rights reserved.
//

import Foundation
import MapKit

//crimeDetail Model inheriting from MKAnnotation
class CrimeDetail: NSObject, MKAnnotation {
    
    func pinColor() -> UIColor  {
        switch rank {
        case 0:
            return UIColor.Awareness.Red
        case 1:
            return UIColor.Awareness.PureRed
        case 2:
            return UIColor.Awareness.PureOrange
        case 3:
            return UIColor.Awareness.StrongOrangeA
        case 4:
            return UIColor.Awareness.StrongOrangeB
        case 5:
            return UIColor.Awareness.StrongYellowA
        case 6:
            return UIColor.Awareness.StrongYellowB
        default:
            return UIColor.Awareness.PureGreen
        }
    }
    
    var title: String?
    var locationName: String = ""
    var discipline: String = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var date: NSDate?
    var district: String = ""
    var rank: Int = -1
    
    var subtitle: String? {
        return locationName
    }
}

