//
//  PredicterVC.swift
//  Traveler
//
//  Created by YED on 05/01/17.
//  Copyright © 2017 YED. All rights reserved.
//

import UIKit
import CoreMotion
import CoreData


struct LowPassFilter {
    
    /// Current signal value
    var value: Double
    
    /// A scaling factor in the range 0.0..<1.0 that determines
    /// how resistant the value is to change
    let filterFactor: Double
    
    /// Update the value, using filterFactor to attenuate changes
    mutating func update(newValue: Double) -> Double {
        value = filterFactor * value + (1.0 - filterFactor) * newValue
        
        return value
    }
}




class PredicterVC: UIViewController {
    @IBOutlet var btnStart: UIBarButtonItem!
    @IBOutlet var windowFrame: UISegmentedControl!
    @IBOutlet var instantTransportationMode: UIImageView!
    @IBOutlet var btnStop: UIBarButtonItem!
    @IBOutlet var lblnfo: UILabel!
    
    var counterFromThree = 4
    var counter = 0
    var counterMax: Int!
    var timer2 = Timer()
    var timer = Timer()
    let motionManager = CMMotionManager()
    var filter = true
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Sensor Data Arrays
    var ax: [Double] = [];
    var ay: [Double] = [];
    var az: [Double] = [];
    var gx: [Double] = [];
    var gy: [Double] = [];
    var gz: [Double] = [];
    var featureVector: [[String : Double]] = []
    
    // Low Pass Filter Structure Value
    var smoothAccX: LowPassFilter!
    var smoothAccY: LowPassFilter!
    var smoothAccZ: LowPassFilter!
    var smoothGyroX: LowPassFilter!
    var smoothGyroY: LowPassFilter!
    var smoothGyroZ: LowPassFilter!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.btnStart.tintColor = support.hexStringToUIColor(hex: "#2B2E3A")
        self.btnStop.tintColor = support.hexStringToUIColor(hex: "#2B2E3A")
        self.windowFrame.tintColor = support.hexStringToUIColor(hex: "#2B2E3A")
        self.btnStop.isEnabled = false
        
        
        
        
    }

   
    @IBAction func start(_ sender: UIBarButtonItem) {
        
        btnStart.isEnabled = false
        btnStop.isEnabled = true
        windowFrame.isEnabled = false
        windowFrame.isUserInteractionEnabled = false
        switch windowFrame.selectedSegmentIndex {
        case 0:
            counterMax = 21
        case 1:
            counterMax = 41
        case 2:
            counterMax = 61
        default:
            counterMax = 0
        }
        refreshArrays()
        initLowPassFilter()
        timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PredicterVC.countFromThree), userInfo: nil, repeats: true)
        
        
    }
       
    @IBAction func stop(_ sender: UIBarButtonItem) {
        btnStart.isEnabled = true
        btnStop.isEnabled = false
        windowFrame.isEnabled = true
        windowFrame.isUserInteractionEnabled = true
        stopCollectingData()
        editCollectedData()
    }
    
    
    func countFromThree() {
        counterFromThree = counterFromThree - 1
        lblnfo.text = "\(counterFromThree)"
        if counterFromThree == 0 {
            timer2.invalidate()
            counterFromThree = 4
            startCollectingData(updateInterval: 0.01)
        }
    }
    
    
    func count() {
        counter = counter + 1
        if counter == counterMax {
            counter = 0
            
            makePrediction()
            
            
            print(ax.count)
            print(ay.count)
            print(az.count)
            print(gx.count)
            print(gy.count)
            print(gz.count)
        }
        
    }
    
    
    func startProcess() {
        refreshArrays()
        initLowPassFilter()
        lblnfo.text = "Hesaplanıyor..."
        startCollectingData(updateInterval: 0.01)
    }
    
    // Refresh Arrays Which Contains Sensor Data
    
    func refreshArrays() {
        
        ax.removeAll()
        ay.removeAll()
        az.removeAll()
        gx.removeAll()
        gy.removeAll()
        gz.removeAll()
        featureVector.removeAll()
        
    }
    
    func initLowPassFilter() {
        self.smoothAccX = LowPassFilter(value: 0.0, filterFactor: 0.85)
        self.smoothAccY = LowPassFilter(value: 0.0, filterFactor: 0.85)
        self.smoothAccZ = LowPassFilter(value: 0.0, filterFactor: 0.85)
        
        self.smoothGyroX = LowPassFilter(value: 0.0, filterFactor: 0.85)
        self.smoothGyroY = LowPassFilter(value: 0.0, filterFactor: 0.85)
        self.smoothGyroZ = LowPassFilter(value: 0.0, filterFactor: 0.85)
        
    }
    
    func resizeArrays() {
        
        let size = (windowFrame.selectedSegmentIndex + 1)*2000
        
        ax = Array(ax.prefix(size))
        ay = Array(ay.prefix(size))
        az = Array(az.prefix(size))
        
        gx = Array(gx.prefix(size))
        gy = Array(gz.prefix(size))
        gz = Array(gz.prefix(size))
        
        
    }
    
    func checkArrays(sensorDataArrays: [[Double]]) {
        
        for array in sensorDataArrays {
            if array.count < 2000 {
                createAlert(title: "Error", message: "Sensor data arrays siz is lower than expect!")
            }
        }
        
    }
    
    
    // MARK: - Start Collecting Data
    
    func startCollectingData(updateInterval: Double) {
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PredicterVC.count), userInfo: nil, repeats: true)
        
        
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = updateInterval
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (data, error) in
                
                if error != nil {
                    self.createAlert(title: "Error", message: "Sensor Error")
                } else {
                    
                    if self.filter {
                        self.ax.append(self.smoothAccX.update(newValue: (data?.userAcceleration.x)!))
                        self.ay.append(self.smoothAccY.update(newValue: (data?.userAcceleration.y)!))
                        self.az.append(self.smoothAccZ.update(newValue: (data?.userAcceleration.z)!))
                        
                        self.gx.append(self.smoothGyroX.update(newValue: (data?.rotationRate.x)!))
                        self.gy.append(self.smoothGyroY.update(newValue: (data?.rotationRate.y)!))
                        self.gz.append(self.smoothGyroZ.update(newValue: (data?.rotationRate.z)!))
                    } else {
                        self.ax.append((data?.userAcceleration.x)!)
                        self.ay.append((data?.userAcceleration.y)!)
                        self.az.append((data?.userAcceleration.z)!)
                        
                        self.gx.append((data?.rotationRate.x)!)
                        self.gy.append((data?.rotationRate.y)!)
                        self.gz.append((data?.rotationRate.z)!)
                    }
                    
                    
                    
                }
                
            })
        } else {
            createAlert(title: "Error", message: "Device Motion is not available!")
        }
        
    }
    
    
    func stopCollectingData() {
        
        motionManager.stopDeviceMotionUpdates()
        timer.invalidate()
        counter = 0
        lblnfo.text = "Sonlandı!"
        
        
    }
    
    
    func featureExtract() {
        
        if windowFrame.selectedSegmentIndex == 0 {
            let ax_sqmean = features.squareMean(rawData: ax)
            let ax_kurtosis = features.kurtosis(rawData: ax)
            let ay_inqrange = features.interquartileRange(rawData: ay)
            let az_stddev = features.standardDeviation(rawData: az)!
            let gz_sqmean = features.squareMean(rawData: gz)
            
            featureVector.append(["AX-SqMean" : ax_sqmean])     //0
            featureVector.append(["AX-Kurtosis" : ax_kurtosis]) //1
            featureVector.append(["AY-InqRan" : ay_inqrange])   //2
            featureVector.append(["AZ-StdDev" : az_stddev])     //3
            featureVector.append(["GZ-SqMean" : gz_sqmean])     //4
            
        } else if windowFrame.selectedSegmentIndex == 1 {
            
            let ax_geomean = features.geometricMean(rawData: ax)
            let ax_sqmean = features.squareMean(rawData: ax)
            let az_variance = features.variance(rawData: az)
            let gz_stddev = features.standardDeviation(rawData: gz)!
            let gz_maxinc = features.maximumIncrease(rawData: gz)
            
            featureVector.append(["AX-SqMean" : ax_sqmean])         //0
            featureVector.append(["AX-GeoMean" : ax_geomean])       //1
            featureVector.append(["AZ-Variance" : az_variance!])    //2
            featureVector.append(["GZ-StdDev" : gz_stddev])         //3
            featureVector.append(["GZ-MaxInc" : gz_maxinc])         //4
            
        } else if windowFrame.selectedSegmentIndex == 2 {
            let ax_sqmean = features.squareMean(rawData: ax)
            let ax_kurtosis = features.kurtosis(rawData: ax)
            let ax_max = features.maximumValue(rawData: ax)
            let gz_max = features.maximumValue(rawData: gz)
            
            
            featureVector.append(["AX-SqMean" : ax_sqmean])         //0
            featureVector.append(["AX-Kurtosis" : ax_kurtosis])     //1
            featureVector.append(["AX-Max" : ax_max])               //2
            featureVector.append(["GZ-Max" : gz_max])               //3
            
            
        }
        
        
        
    }
    
    
    func makePrediction() {
        motionManager.stopDeviceMotionUpdates()
        timer.invalidate()
        checkArrays(sensorDataArrays: [ax, ay, az, gx, gy, gz])
        resizeArrays()
        
        featureExtract()
        
        var mode: String = ""
        
        if windowFrame.selectedSegmentIndex == 0 {
            mode = model.model_20(data: featureVector)
            
        } else if windowFrame.selectedSegmentIndex == 1 {
            mode = model.model_40(data: featureVector)
            
        } else if windowFrame.selectedSegmentIndex == 2 {
            mode = model.model_60(data: featureVector)
            
        }
        
        
        switch mode {
        case "Araba":
            instantTransportationMode.image = #imageLiteral(resourceName: "car")
        case "Met-Mar":
            instantTransportationMode.image = #imageLiteral(resourceName: "subway")
        case "Oto-Mbus":
            instantTransportationMode.image = #imageLiteral(resourceName: "bus")
        case "Tramvay":
            instantTransportationMode.image = #imageLiteral(resourceName: "tramvay")
        case "Hafif Rayli":
            instantTransportationMode.image = #imageLiteral(resourceName: "hafif")
        case "Yurume":
            instantTransportationMode.image = #imageLiteral(resourceName: "walk")
        default:
            break
        }
        
        let newdata = NSEntityDescription.insertNewObject(forEntityName: "Buffer", into: context) as! RawPredictionMO
        newdata.setValue(mode, forKey: "mode")
        newdata.setValue(NSDate(), forKey: "datetime")
        do {
            try newdata.managedObjectContext?.save()
        } catch {
            createAlert(title: "Error", message: "Data cannot save!")
        }
        print(mode)
        startProcess()
        
    }
    
    
    func createAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
        
        
    }
    

    
    
    
    
    // MARK: - Edit Collected Data
    
    func editCollectedData() {
        
        var entity = ""
        var trashHold = 0
        if windowFrame.selectedSegmentIndex == 0 {
            trashHold = 22
            entity = "RawPredictions_20"
        } else if windowFrame.selectedSegmentIndex == 1 {
            trashHold = 42
            entity = "RawPredictions_40"
        } else if windowFrame.selectedSegmentIndex == 2 {
            trashHold = 62
            entity = "RawPredictions_60"
        }
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Buffer", in: self.context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let results: Array = try self.context.fetch(fetchRequest) as! [RawPredictionMO]
            print(results.count)
            if (results.count > 0) {
                for result in results {
                    print(result.datetime!)
                    print(result.mode!)
                }
                
                editYurumeResults(results: results, trashHold: trashHold, entity: entity)
                
                
                
            }
            
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
    }
    
    
    func editYurumeResults(results: [RawPredictionMO], trashHold: Int, entity: String) {
        
        
        if results.count >= 3 {
            
            for i in 0...(results.count-3) {
                var split = [results[i], results[i+1], results[i+2]]
                
                var k = 0
                
                for element in split {
                    let index = split.index(of: element)!
                    
                    
                    
                    if split[index].mode! == "Yurume" {
                        k = k + 1
                    } else {
                        if index != 0 {
                            let first = NSDate().timeIntervalSince(split[index-1].datetime as! Date)
                            let second = NSDate().timeIntervalSince(split[index].datetime as! Date)
                            let duration = Int(first - second)
                            if duration > trashHold {
                                k = 0
                                break
                                
                            }
                        }
                    }
                    
                    
                }
                if k == 2 {
                    for element in split {
                        element.mode = "Yurume"
                    }
                }
                
                
                
            }
            
        }
        
        print("********AAAA*************")
        
        for result in results {
            print(result.datetime!)
            print(result.mode!)
        }
        
        
        for element in results {
            let newdata = NSEntityDescription.insertNewObject(forEntityName: entity, into: context) as! RawPredictionMO
            newdata.setValue(element.mode, forKey: "mode")
            newdata.setValue(element.datetime, forKey: "datetime")
            do {
                try newdata.managedObjectContext?.save()
            } catch {
                createAlert(title: "Error", message: "Data cannot save!")
            }
        }
        
        editAllResults(results: results)
        
        
        
        
        
    }
    
    func removeBuffer() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Buffer")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            createAlert(title: "Error", message: "Data cannot delete!")
        }
        
    }
    
    
    func editAllResults(results: [RawPredictionMO]) {
        var firstIndex:Int!
        var secondIndex:Int!
        
        var entity = ""
        
        if windowFrame.selectedSegmentIndex == 0 {
            
            entity = "ImprovedPredictions_20"
        } else if windowFrame.selectedSegmentIndex == 1 {
            
            entity = "ImprovedPredictions_40"
        } else if windowFrame.selectedSegmentIndex == 2 {
            
            entity = "ImprovedPredictions_60"
        }
        
        var index = 0
        var fail = 0
        while index < results.count {
            
            if results[index].mode == "Yurume" {
                let tmp_first = index
                
                firstIndex = findFinish(start: tmp_first, results: results)
                secondIndex = findSecondIndex(start: firstIndex, results: results)
                editBetweenIndexes(start: firstIndex, end: secondIndex, results: results, check: true)
                index = secondIndex + 1
               
               
               
                
            } else {
                index = index + 1
                fail = fail + 1
            }
        }
        
        if fail == results.count {
            editBetweenIndexes(start: 0, end: results.count, results: results, check: false)
        }
        
        print("********BBB*************")
        for result in results {
            print(result.datetime!)
            print(result.mode!)
        }
        
        
        for element in results {
            let newdata = NSEntityDescription.insertNewObject(forEntityName: entity, into: context) as! RawPredictionMO
            newdata.setValue(element.mode, forKey: "mode")
            newdata.setValue(element.datetime, forKey: "datetime")
            do {
                try newdata.managedObjectContext?.save()
            } catch {
                createAlert(title: "Error", message: "Data cannot save!")
            }
        }
        
        removeBuffer()
        
        
    }
    
    
    func checkIsSequential(index: Int, results: [RawPredictionMO]) -> Bool {
        
        if results.count >= index + 3 {
            for i in index...index + 2 {
                if results[i].mode != "Yurume" {
                    return false
                }
            }
        }
        
        return true
        
    }
    
    
    func findFinish(start: Int, results: [RawPredictionMO]) -> Int {
        var index = start
        while index < results.count && results[index].mode == "Yurume"   {
            index = index + 1
        }
        if index == results.count {
            return index - 1
        }
        
        return index
        
    }
    
    func findSecondIndex(start: Int, results: [RawPredictionMO]) ->Int {
        
        for index in start...(results.count-1) {
            if results[index].mode == "Yurume" {
                if checkIsSequential(index: index, results: results) {
                    return index
                }
            }
        }
        return results.count-1
    }
    
    
    func editBetweenIndexes(start: Int, end: Int, results: [RawPredictionMO], check: Bool) {
        var modeCountArray: [Int] = [0, 0, 0, 0, 0] // Araba, Met-Mar, Oto-Mbus, Tramvay, Hafif
        var s: Int!
        var e: Int!
        var end_2: Int!
        if end == results.count {
            end_2 = end - 1
        } else {
            end_2 = end
        }
        
        var trashHold = 0.0
        
        if windowFrame.selectedSegmentIndex == 0 {
            trashHold = 70.0
        }
        else if windowFrame.selectedSegmentIndex == 1 {
            trashHold = 130.0
        } else if windowFrame.selectedSegmentIndex == 2 {
            trashHold = 190.0
        }
        
        //Sonradan Eklendi
        let first = NSDate().timeIntervalSince(results[start].datetime as! Date)
        let second = NSDate().timeIntervalSince(results[end_2].datetime as! Date)
        if (first - second) < trashHold && check {
            for index in start...end{
                results[index].mode = "Yurume"
            }
        } else {
            
            if start != results.count - 1 {
                s = start + 1
                e = end - 1
                
                
                
                
            } else  {
                s = start
                e = end
            }
            
            for index in s...e {
                
                switch results[index].mode! {
                case "Araba":
                    modeCountArray[0] = modeCountArray[0] + 1
                case "Met-Mar":
                    modeCountArray[1] = modeCountArray[1] + 1
                case "Oto-Mbus":
                    modeCountArray[2] = modeCountArray[2] + 1
                case "Tramvay":
                    modeCountArray[3] = modeCountArray[3] + 1
                case "Hafif":
                    modeCountArray[4] = modeCountArray[4] + 1
                default:
                    break
                }
            }
            var maxMode: String = ""
            let max = modeCountArray.max()!
            switch modeCountArray.index(of: max)! {
            case 0:
                maxMode = "Araba"
            case 1:
                maxMode = "Met-Mar"
            case 2:
                maxMode = "Oto-Mbus"
            case 3:
                maxMode = "Tramvay"
            case 4:
                maxMode = "Hafif"
            default:
                break
            }
            
            if s != results.count - 1 {
                for index in s...e {
                    results[index].mode = maxMode
                }
                
            }
            
        }
        
        
        // Düzenlenmiş verileri kaydet
        // Buffer kullan
        
        
        
        
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
