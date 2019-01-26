//
//  ScheduleTableViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 08/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Viewcontroller for the chore schedule.
//  Calculates the number of cells and schedules the residents.
//  The number of weeks is arbitrary, try shaking...
//

import UIKit


class ScheduleTableViewController: UITableViewController {
    
    // MARK: - Variables
    var weekdays = [Int]()
    var numberOfWeeks = 6
    
    var counter = 0

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    /// calcs the coming x weeks for section headers
    func calculateSections() {
        let calendar = Calendar.current
        var date = Date()
        
        for _ in 1...numberOfWeeks {
            let weekday = calendar.component(.weekOfYear, from: date)
            weekdays.append(weekday)
            
            // increment week
            date = calendar.date(byAdding: .day, value: 7, to: date, wrappingComponents: false)!
        }
    }
    

    // MARK: - Table view data source
    
    /// returns number of weekdays for number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return weekdays.count
    }
    
    /// sets title of section to weeknumber
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Week \(weekdays[section])"
    }

    /// returns number of chores for rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChoreModelController.chores.count
        
    }

    /// dequeues and configures cell for schedules
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath)
        
        // cell title to chore title
        cell.textLabel?.text = ChoreModelController.chores[indexPath.row].title
        
        // cell detail to the resident scheduled
        let peopleIndex = getCellID(with: indexPath) % HouseModelController.residents.count
        cell.detailTextLabel?.text = HouseModelController.residents[peopleIndex]
        
        return cell
    }
    
    /// calcs the number (minus 1) of the cell needed for scheduling
    func getCellID(with indexPath: IndexPath) -> Int {
        let sectionNumber = indexPath.section * ChoreModelController.chores.count
        let rowNumber = indexPath.row
        return sectionNumber + rowNumber
        
        /*
         indexPath [0,0] to indexPath [1,2] are 6 cells (3 cells per section)
         The section int is multiplied with chore count to see which cell number (minus 1) it has in the view
         */
    }
}
