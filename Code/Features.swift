//
//  Features.swift
//  AraProje
//
//  Created by YED on 29/12/16.
//  Copyright © 2016 YED. All rights reserved.
//

import Foundation


public var features = Features.sharedInstance

public class Features {
    
    public static let sharedInstance = Features()
    
    // Minimum Reduction
    
    func minimumReduction(rawData: [Double]) -> Double {
        
        var j = 0
        while (rawData[j] < rawData[j+1]) {
            j = j + 1
        }
        
        var minRed = rawData[j] - rawData[j+1]
        
        for l in j+1...(rawData.count-2) {
            if rawData[l] > rawData[l+1] {
                let foundMinRed = rawData[l] - rawData[l+1]
                if foundMinRed < minRed {
                    minRed = foundMinRed
                }
            }
        }
        
        return minRed
        
    }
    
    
    // Maximum Reduction
    
    func maximumReduction(rawData: [Double]) -> Double {
        
        var j = 0
        while (rawData[j] < rawData[j+1]) {
            j = j + 1
        }
        
        var maxRed = rawData[j] - rawData[j+1]
        
        for l in j+1...(rawData.count-2) {
            if rawData[l] > rawData[l+1] {
                let foundMaxRed = rawData[l] - rawData[l+1]
                if foundMaxRed > maxRed {
                    maxRed = foundMaxRed
                }
            }
        }
        
        return maxRed
        
    }
    
    
    
    
    // Minimum Increase
    
    func minimumIncrease(rawData: [Double]) -> Double {
        
        var j = 0
        while (rawData[j] > rawData[j+1]) {
            j = j + 1
        }
        
        var minInc = rawData[j+1] - rawData[j]
        
        for l in j+1...(rawData.count-2) {
            if rawData[l] < rawData[l+1] {
                let foundMinInc = rawData[l+1] - rawData[l]
                if foundMinInc < minInc {
                    minInc = foundMinInc
                }
            }
        }
        
        return minInc
        
    }
    
    
    // Maximum Increase
    
    func maximumIncrease(rawData: [Double]) -> Double {
        
        var j = 0
        while (rawData[j] > rawData[j+1]) {
            j = j + 1
        }
        
        var maxInc = rawData[j+1] - rawData[j]
        
        for l in j+1...(rawData.count-2) {
            if rawData[l] < rawData[l+1] {
                let foundMaxInc = rawData[l+1] - rawData[l]
                if foundMaxInc > maxInc {
                    maxInc = foundMaxInc
                }
            }
        }
        
        return maxInc
        
    }
    
    
    
    // Minimum Value
    
    func minimumValue(rawData: [Double]) -> Double {
        
        return rawData.min()!
        
    }
    
    
    // Maximum Value
    
    func maximumValue(rawData: [Double]) -> Double {
        
        return rawData.max()!
        
    }
    
    
    //Range
    
    func range(rawData: [Double]) -> Double {
        
        let min = minimumValue(rawData: rawData)
        let max = maximumValue(rawData: rawData)
        
        return (max - min)
        
        
    }
    
    
    // Sum
    
    func sum(rawData: [Double]) -> Double {
        return rawData.reduce(0, +)
    }
    
    
    // Arithmetic Mean
    
    func arithmeticMean(rawData: [Double]) -> Double? {
        let count = Double(rawData.count)
        if count == 0 { return nil }
        return sum(rawData: rawData) / count
    }
    
    // Square Mean
    
    func squareMean(rawData: [Double]) -> Double {
        var sqTotal = 0.0
        for item in rawData {
            sqTotal = sqTotal + pow(item, 2.0)
        }
        let tmp = sqTotal / Double(rawData.count)
        return tmp
        
    }
    
    
    // Geometric Mean
    
    func geometricMean(rawData: [Double]) -> Double {
        
        let n = Double(rawData.count)
        
        var m = 0;
        var geometricTotal = 1.0
        var theResult = 1.0
        for _ in 0...3 {
            
            for a in m...(m + 99) {
                geometricTotal = geometricTotal * rawData[a]
            }
            theResult = theResult * pow(abs(geometricTotal), 1/n)
            geometricTotal = 1.0;
            m = m + 100
            
        }
        
        return theResult
        
    }
    
    
    // Harmonic Mean
    
    func harmonicMean(rawData: [Double]) -> Double {
        
        var hrmTotal = 0.0
        for item in rawData {
            hrmTotal = hrmTotal + (1.0/item)
        }
        let n = Double(rawData.count)
        
        return n/hrmTotal
        
    }
    
    
    // Quadratic Mean
    
    func quadraticMean(rawData: [Double]) -> Double {
        
        let total = squareMean(rawData: rawData)
        
        return sqrt(total)
        
    }
    
    
    // Median
    
    func median(rawData: [Double]) -> Double? {
        let count = Double(rawData.count)
        if count == 0 { return nil }
        let sorted = sort(rawData: rawData)
        
        if count.truncatingRemainder(dividingBy: 2) == 0 {
            // Even number of items - return the mean of two middle values
            let leftIndex = Int(count / 2 - 1)
            let leftValue = sorted[leftIndex]
            let rightValue = sorted[leftIndex + 1]
            return (leftValue + rightValue) / 2
        } else {
            // Odd number of items - take the middle item.
            return sorted[Int(count / 2)]
        }
    }
    
    
    func sort(rawData: [Double]) -> [Double] {
        return rawData.sorted { $0 < $1 }
    }
    
    
    
    // Variance
    
    func variance(rawData: [Double]) -> Double? {
        let count = Double(rawData.count)
        if count < 2 { return nil }
        
        if let avgerageValue = arithmeticMean(rawData: rawData) {
            let numerator = rawData.reduce(0) { total, value in
                total + pow(avgerageValue - value, 2)
            }
            
            return numerator / (count - 1)
        }
        
        return nil
    }
    
    
    
    // Standard Deviation
    
    func standardDeviation(rawData: [Double]) -> Double? {
        if let varianceSample = variance(rawData: rawData) {
            return sqrt(varianceSample)
        }
        
        return nil
    }
    
    
    // Coefficient Of Variance
    
    func coefficientVariance(rawData: [Double]) -> Double {
        
        let std = standardDeviation(rawData: rawData)!
        let mean = arithmeticMean(rawData: rawData)!
        
        return std/mean
        
    }
    
    
    // Kurtosis
    
    func kurtosis(rawData: [Double]) -> Double {
        
        let mean = arithmeticMean(rawData: rawData)!
        var totalPay = 0.0
        for x in rawData {
            totalPay = totalPay + pow((x - mean), 4)
        }
        
        var totalPayda = 0.0
        for x in rawData {
            totalPayda = totalPayda + pow((x - mean), 2)
        }
        
        totalPayda = pow(totalPayda, 2)
        
        return Double(rawData.count)*totalPay/totalPayda
    }
    
    
    
    // Skewness
    
    func skewness(rawData: [Double]) -> Double {
        
        let mean = arithmeticMean(rawData: rawData)!
        let n = Double(rawData.count)
        
        var totalPay = 0.0
        for x in rawData {
            totalPay = totalPay + pow((x - mean), 3)
        }
        
        
        var totalPayda = 0.0
        for x in rawData {
            totalPayda = totalPayda + pow((x - mean), 2)
        }
        totalPayda = pow(totalPayda, 3/2)
        
        return sqrt(n)*totalPay/totalPayda
    }
    
    
    // Interqurtile Range
    
    func interquartileRange(rawData: [Double]) -> Double {
        
        let med = median(rawData: rawData)!
        let sorted = sort(rawData: rawData)
        
        var i = 0
        var array_1: [Double] = []
        var item = sorted[i]
        while item < med {
            array_1.append(item)
            i = i + 1
            item = sorted[i]
        }
        let q1 = median(rawData: array_1)!
        
        if item == med {
            i = i + 1
        }
        
        var array_2: [Double] = []
        while i<rawData.count  {
            item = sorted[i]
            array_2.append(item)
            i = i + 1
        }
        let q3 = median(rawData: array_2)!
        
        return (q3 - q1)
    }
    
}

