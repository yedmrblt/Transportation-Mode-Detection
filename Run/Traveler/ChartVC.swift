//
//  ChartVC.swift
//  Traveler
//
//  Created by YED on 10/01/17.
//  Copyright © 2017 YED. All rights reserved.
//

import UIKit
import Charts

class ChartVC: UIViewController {
    
    
    var modesName: [String] = []
    var modesCount: [Int] = []
    var modesStartDate: [NSDate] = []
    var modesFinishDate: [NSDate] = []
    
    var chartDataPoints: [String] = []
    var chartDataValues: [Int] = []
    
    let datePicker_1 = UIDatePicker()
    let datePicker_2 = UIDatePicker()
    
    @IBOutlet var pieChartView: PieChartView!
    
    @IBOutlet var firstDate: UITextField!
    @IBOutlet var secondDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func createAlert(title: String, message: String) {
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
        
        
    }
    
    
    @IBAction func ara(_ sender: Any) {
        
        
        if firstDate.text != "" && secondDate.text != "" {
            
            let order = NSCalendar.current.compare(datePicker_1.date, to: datePicker_2.date as Date, toGranularity: .day)
            
            if order == .orderedDescending {
                createAlert(title: "Hata", message: "Hatalı tarih aralığı!")
            } else {
                chartDataPoints.removeAll()
                chartDataValues.removeAll()
                
                
                editModes(modesName: modesName, modesCount: modesCount)
                setChart(dataPoints: chartDataPoints, values: chartDataValues)
            }
            
        } else {
            createAlert(title: "Uyarı", message: "Lütfen tarih bilgisi giriniz!")
        }
        
        
       
        
        
    }
    
    
    func editModes(modesName: [String], modesCount: [Int]) {
        
        var first: Int!
        var last: Int!
        
        
        print(modesStartDate)
        print(modesFinishDate)
        
        if modesName.count != 0 {
            
           
            
            
            for i in 0...(modesStartDate.count - 1) {
                
                
                let order = NSCalendar.current.compare(datePicker_1.date, to: modesStartDate[i] as Date, toGranularity: .day)
                
                if order == .orderedAscending || order == .orderedSame {
                    first = i
                    break
                }
                
                
            }
            
            
            for i in 0...(modesFinishDate.count - 1) {
                
                
                let order = NSCalendar.current.compare(datePicker_2.date, to: modesFinishDate[i] as Date, toGranularity: .day)
                
                if order == .orderedAscending || order == .orderedSame {
                    last = i
                    
                } else if order == .orderedDescending {
                    
                    if i == modesFinishDate.count - 1 {
                        last = i
                    }
                }
                
            }
            
            
            
            
            if first != nil && last != nil {
                print(first)
                print(last)
                for i in first...last {
                    if chartDataPoints.contains(modesName[i]) {
                        let index = chartDataPoints.index(of: modesName[i])
                        chartDataValues[index!] = chartDataValues[index!] + modesCount[i]
                    } else {
                        chartDataPoints.append(modesName[i])
                        chartDataValues.append(modesCount[i])
                    }
                }
            } else {
                createAlert(title: "Uyarı", message: "Girdiğiniz tarihler arasında kayıt bulunmamaktadır!")
            }
            
        } else {
            createAlert(title: "Uyarı", message: "Girdiğiniz tarihler arasında kayıt bulunmamaktadır!...")
        }
        
        
       
        
        
        
        
        
    }
    
    
    func setChart(dataPoints: [String], values: [Int]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: Double(values[i]), label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Ulaşım Türleri")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        pieChartView.animate(xAxisDuration: 2.0)
        
        
    }
    
    
    @IBAction func datePicker1(_ sender: UITextField) {
        
        datePicker_1.datePickerMode = UIDatePickerMode.date
        firstDate.inputView = datePicker_1
        datePicker_1.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
    }
    
    
    
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        firstDate.text = formatter.string(from: sender.date)
        
        
    }
    
    @IBAction func datePicker2(_ sender: UITextField) {
        
        datePicker_2.datePickerMode = UIDatePickerMode.date
        secondDate.inputView = datePicker_2
        datePicker_2.addTarget(self, action: #selector(datePickerChanged2(sender:)), for: .valueChanged)
    }
    
    func datePickerChanged2(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        secondDate.text = formatter.string(from: sender.date)
        
        
    }
    
    func closekeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closekeyboard()
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
