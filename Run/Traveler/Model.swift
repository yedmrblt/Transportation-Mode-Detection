//
//  Model.swift
//  Traveler
//
//  Created by YED on 05/01/17.
//  Copyright © 2017 YED. All rights reserved.
//

import Foundation

public var model = MLModel.sharedInstance

public class MLModel {
    public static let sharedInstance = MLModel()
    
    func model_20(data: [[String : Double]]) -> String {
        
        if data[0]["AX-SqMean"]! <= 0.000546 {
            
            if data[3]["AZ-StdDev"]! <= 0.013789 {
                return "Met-Mar"
            } else {
                
                if data[2]["AY-InqRan"]! <= 0.01386 {
                    
                    if data[0]["AX-SqMean"]! <= 0.000227 {
                        return "Met-Mar"
                    } else {
                        return "Tramvay"
                    }
                } else {
                    return "Hafif Rayli"
                }
            }
            
        } else {
            
            if data[0]["AX-SqMean"]! <= 0.082719 {
                
                if data[4]["GZ-SqMean"]! <= 0.008267 {
                    
                    if data[1]["AX-Kurtosis"]! <= 4.910941 {
                        return "Araba"
                    } else {
                        return "Oto-Mbus"
                    }
                    
                } else {
                    return "Araba"
                }
                
            } else {
                return "Yurume"
            }
            
        }
        
    }
    
    
    func model_40(data: [[String : Double]]) -> String {
        
        
        if data[0]["AX-SqMean"]! <= 0.000526 {
            if data[0]["AX-SqMean"]! <= 0.000262 {
                if data[2]["AZ-Variance"]! <= 0.000366 {
                    return "Met-Mar"
                } else {
                    if data[1]["AX-GeoMean"]! <= 0.00482 {
                        return "Hafif Rayli"
                    } else {
                        return "Met-Mar"
                    }
                }
            } else {
                if data[1]["AX-GeoMean"]! <= 0.006298 {
                    return "Tramvay"
                } else {
                    return "Hafif Rayli"
                }
            }
        } else {
            if data[0]["AX-SqMean"]! <= 0.038388 {
                if data[3]["GZ-StdDev"]! <= 0.088418 {
                    if data[4]["MaxInc"]! <= 0.176386 {
                        return "Araba"
                    } else {
                        return "Oto-Mbus"
                    }
                } else {
                    return "Araba"
                }
            } else {
                return "Yurume"
            }
        }
        
    
    }
    
    
    
    
    func model_60(data: [[String : Double]]) -> String {
        
        
        if data[0]["AX-SqMean"]! <= 0.000505 {
            if data[1]["AX-Kurtosis"]! <= 8.499728 {
                if data[2]["AX-Max"]! <= 0.118292 {
                    return "Hafif Rayli"
                } else {
                    return "Met-Mar"
                }
            } else {
                if data[0]["AX-SqMean"]! <= 0.00022 {
                    return "Met-Mar"
                } else {
                    return "Tramvay"
                }
            }
        } else {
            if data[0]["AX-SqMean"]! <= 0.026475 {
                if data[3]["GZ-Max"]! <= 0.764727 {
                    if data[1]["AX-Kurtosis"]! <= 5.242786 {
                        return "Araba"
                    } else {
                        return "Oto-Mbus"
                    }
                } else {
                    return "Araba"
                }
            } else {
                return "Yurume"
            }
        }
        
        
    }
    
    
}
