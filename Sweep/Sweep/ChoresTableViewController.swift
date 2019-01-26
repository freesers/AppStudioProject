//
//  ChoresTableViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 08/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//
//  Handles the tableview of the chores, shows all chores
//  and shows when its due and by whom
//

import UIKit
import UserNotifications


class ChoresTableViewController: UITableViewController, CellSubclassDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NewChoresDelegate {
    
    // MARK: - variables
    @IBOutlet weak var addChoreButton: UIBarButtonItem!
    
    var tempIndexPath: IndexPath?
    var currentTitle: String!
    var currentImage: UIImage!
    var firstLoad = true
    
    let notificationController = NotificationController()
    
    // create notification for user is up this week
    var residentsDue = [String]() {
        didSet {
            notificationController.checkIfUserIsUp(usersDue: residentsDue)
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCell()
        ChoreModelController.delegate = self
      
        // show edit/add buttons only if user is administrator
        if !Bool(UserModelController.currentUser.isAdministrator)! {
            addChoreButton.isEnabled = false
            addChoreButton.tintColor = UIColor.clear
        } else {
            self.navigationItem.leftBarButtonItem = editButtonItem
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    /// return number of chores for rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChoreModelController.chores.count
        
    }
    
    /// configures chore cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoreCell", for: indexPath) as! ChoreTableViewCell
        
        let residents = HouseModelController.residents
        
        let chore = ChoreModelController.chores[indexPath.row]
        cell.choreTitleLabel.text = chore.title
        cell.choreImageView.image = chore.photo
        cell.choreDueDateLabel.text = "Due: \(getDateString())"
        cell.chorePersonDueLabel.text = "By \(residents[indexPath.row % residents.count ])"
        cell.choreDaysLeft.text = "Days left: \(ChoreModelController.daysInterval(date: Date()))"
        cell.delegate = self
        
        // set residents due for chores
        if !residentsDue.contains(residents[indexPath.row % residents.count]) {
            residentsDue.append(residents[indexPath.row % residents.count])
        }
        return cell
    }
    
    /// can edit rows if user is administrator
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if Bool(UserModelController.currentUser.isAdministrator)! {
            return true
        } else {
            return false
        }
    }
    
    /// deletes row from tableview, server, and directory
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chore = ChoreModelController.chores[indexPath.row]
            
            // delete chore from server
            ChoreModelController.getChoreID(choreName: chore.title) { (id) in
                ChoreModelController.deleteChore(with: id, completion: {
                    print("Chore Deleted")
                })
            }
            
            // remove from model and update tableview
            ChoreModelController.chores.remove(at: indexPath.row)
            ChoreModelController.saveChoresDirectory()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /// animates first load of cells
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if firstLoad {
            cell.alpha = 0
            
            // fades in animation
            UIView.animate(
                withDuration: 0.5,
                delay: 0.05 * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
            })
            firstLoad = false
        }
    }
    
    /// registers custom cell from nibFile
    func registerTableViewCell() {
        let choreCell = UINib(nibName: "ChoreTableViewCell", bundle: nil)
        self.tableView.register(choreCell, forCellReuseIdentifier: "ChoreCell")
    }
    
    /// delegate method that reloads data after server results
    func reloadCells() {
        tableView.reloadData()
    }
    
    // MARK: - Cell interaction
    
    /// present imagepicker when button pressed
    func cleanedButtonPressed(cell: ChoreTableViewCell) {
        presentImagePicker()
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        
        // store index for use in imagepicker
        tempIndexPath = indexPath
    }
    
    /// present imageViewController
    func imageTapped(cell: ChoreTableViewCell) {
        self.currentTitle = cell.choreTitleLabel.text
        self.currentImage = cell.choreImageView.image
        performSegue(withIdentifier: "imageSegue", sender: nil)
    }
    
    /// presents imagepicker with given functions
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.cameraDevice = .rear
        
        self.present(imagePicker, animated: true)
    }
    
    // MARK: - ImagePicker
    
    /// store new image when user selects photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        // setup new image and save to directory
        if let index = tempIndexPath {
            ChoreModelController.chores[index.row].photo = image
            ChoreModelController.saveChoresDirectory()
        }
        
        // dismiss picker and update server
        picker.dismiss(animated: true) {
            guard let index = self.tempIndexPath?.row else { return }
            ChoreModelController.getChoreID(choreName: ChoreModelController.chores[index].title, completion: { (id) in
                ChoreModelController.mutateChore(chore: ChoreModelController.chores[index], id: id)
            })
        }
    }
    
    // MARK: - Helpers
    
    /// creates custom string from date
    func getDateString() -> String {
        let date = ChoreModelController.dueDate
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "nl_NL")
        
        // style-example: Zo 27 januari
        dateformatter.setLocalizedDateFormatFromTemplate("MMMMdE")
        let dateString = dateformatter.string(from: date)
        
        return dateString
    }

    // MARK: - Navigation

    /// sets correct properties for imageviewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageSegue" {
            let imageViewController = segue.destination as! DetailImageViewController
            imageViewController.image = self.currentImage
            imageViewController.imageTitle = self.currentTitle
        }
    }
    
    @IBAction func unwindToChores(segue: UIStoryboardSegue) {
        // nothing to do
    }

}
