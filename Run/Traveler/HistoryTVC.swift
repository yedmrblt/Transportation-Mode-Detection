//
//  HistoryTVC.swift
//  Traveler
//
//  Created by YED on 06/01/17.
//  Copyright © 2017 YED. All rights reserved.
//

import UIKit
import CoreData

class HistoryTVC: UITableViewController {
    
    @IBOutlet var windowFrame: UISegmentedControl!
    
    var modesName: [String] = []
    var modesCount: [Int] = []
    var modesStart: [Int] = []
    var modesFinish: [Int] = []
    var modesStartDate: [NSDate] = []
    var modesFinishDate: [NSDate] = []
    
    var th_1 = 0
    var th_2 = 0.0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity = ""
    var entityForDetail = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = support.hexStringToUIColor(hex: "#2B2E3A")
        self.navigationController?.navigationBar.isTranslucent = false
        self.windowFrame.tintColor = support.hexStringToUIColor(hex: "#2B2E3A")
        
        if windowFrame.selectedSegmentIndex == 0 { entity = "ImprovedPredictions_20"; entityForDetail = "RawPredictions_20"; th_1 = 21; th_2 = 22.0 }
        else if windowFrame.selectedSegmentIndex == 1 { entity = "ImprovedPredictions_40"; entityForDetail = "RawPredictions_40"; th_1 = 41; th_2 = 42.0 }
        else if windowFrame.selectedSegmentIndex == 2 { entity = "ImprovedPredictions_60"; entityForDetail = "RawPredictions_60"; th_1 = 61; th_2 = 62.0 }
        
        //fetch()
        
    }

    @IBAction func windowFrameChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 { entity = "ImprovedPredictions_20"; entityForDetail = "RawPredictions_20"; th_1 = 21; th_2 = 22.0 }
        else if sender.selectedSegmentIndex == 1 { entity = "ImprovedPredictions_40"; entityForDetail = "RawPredictions_40"; th_1 = 41; th_2 = 42.0 }
        else if sender.selectedSegmentIndex == 2 { entity = "ImprovedPredictions_60"; entityForDetail = "RawPredictions_60"; th_1 = 61; th_2 = 62.0 }
        
        modesName.removeAll()
        modesCount.removeAll()
        modesStart.removeAll()
        modesFinish.removeAll()
        modesStartDate.removeAll()
        modesFinishDate.removeAll()
        
        fetch()
        self.tableView.reloadData()
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        modesName.removeAll()
        modesCount.removeAll()
        modesStart.removeAll()
        modesFinish.removeAll()
        modesStartDate.removeAll()
        modesFinishDate.removeAll()
        fetch()
        self.tableView.reloadData()
    }
    
    
    func fetch() {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: self.context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let results: Array = try self.context.fetch(fetchRequest) as! [RawPredictionMO]
            print(results.count)
            if (results.count > 0) {
                listHistory(results: results)
                
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    
    func listHistory(results: [RawPredictionMO]) {
        
        var index = 1
        var mode = results[0].mode
        
        var firstIndex = 0
        var lastIndex = -1
        
        
        
        while index < results.count {
            
            let early_indexDate = NSDate().timeIntervalSince(results[index - 1].datetime as! Date)
            let late_indexDate = NSDate().timeIntervalSince(results[index].datetime as! Date)
            
            if (early_indexDate - late_indexDate) > th_2 {
                firstIndex = lastIndex + 1
                lastIndex = index - 1
                let first = NSDate().timeIntervalSince(results[firstIndex].datetime as! Date)
                let second = NSDate().timeIntervalSince(results[lastIndex].datetime as! Date)
                let seconds = Int(first - second) + th_1 - (lastIndex - firstIndex + 1)
                
                print("\(seconds) - \(mode!)")
                
                
                modesName.append(mode!)
                modesCount.append(seconds)
                modesStart.append(firstIndex)
                modesFinish.append(lastIndex)
                modesStartDate.append(results[firstIndex].datetime! as NSDate)
                modesFinishDate.append(results[lastIndex].datetime! as NSDate)
                
                
                mode = results[index].mode
                firstIndex = lastIndex + 1
                index = index + 1
                
            } else {
                index = index + 1
            }
            
            
            
        }
        
        if index == results.count {
            firstIndex = lastIndex + 1
            lastIndex = index - 1
            let first = NSDate().timeIntervalSince(results[firstIndex].datetime as! Date)
            let second = NSDate().timeIntervalSince(results[lastIndex].datetime as! Date)
            let seconds = Int(first - second) + th_1 - (lastIndex - firstIndex + 1)
            
            print("\(seconds) - \(mode!)")
            
            modesName.append(mode!)
            modesCount.append(seconds)
            modesStart.append(firstIndex)
            modesFinish.append(lastIndex)
            modesStartDate.append(results[firstIndex].datetime! as NSDate)
            modesFinishDate.append(results[lastIndex].datetime! as NSDate)

            
        }
        
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return modesName.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        switch modesName[indexPath.row] {
        case "Araba":
            cell.cell_icon.image = #imageLiteral(resourceName: "car")
        case "Met-Mar":
            cell.cell_icon.image = #imageLiteral(resourceName: "subway")
        case "Oto-Mbus":
            cell.cell_icon.image = #imageLiteral(resourceName: "bus")
        case "Tramvay":
            cell.cell_icon.image = #imageLiteral(resourceName: "tramvay")
        case "Hafif Rayli":
            cell.cell_icon.image = #imageLiteral(resourceName: "hafif")
        case "Yurume":
            cell.cell_icon.image = #imageLiteral(resourceName: "walk")
        default:
            break
        }
        
        let seconds = (modesCount[indexPath.row] % 3600) % 60
        let minute = (modesCount[indexPath.row] % 3600) / 60
        _ = modesCount[indexPath.row] / 3600
        
        cell.lblDuration.text = "\(minute) min \(seconds) sec"
        
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "historyDetail", sender: self)
    }
    
    
    
    
    @IBOutlet var chart: UIBarButtonItem!
    
    
    @IBAction func chart(_ sender: Any) {
        performSegue(withIdentifier: "chartDetail", sender: self)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "historyDetail" {
            let destination = segue.destination as! HistoryDetailTVC
            
            destination.modeStart = modesStart[(tableView.indexPathForSelectedRow?.row)!]
            destination.modeFinish = modesFinish[(tableView.indexPathForSelectedRow?.row)!]
            destination.entity_raw = entityForDetail
            destination.entity_improved = entity
            
        } else if segue.identifier == "chartDetail" {
            
            let destination = segue.destination as! ChartVC
            
            destination.modesName = self.modesName
            destination.modesCount = self.modesCount
            destination.modesStartDate = self.modesStartDate
            destination.modesFinishDate = self.modesFinishDate
        }
        
        
        
        
        
        
    }
    

}
