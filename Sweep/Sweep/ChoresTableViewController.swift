//
//  ChoresTableViewController.swift
//  Sweep
//
//  Created by Sander de Vries on 08/01/2019.
//  Copyright © 2019 Sander de Vries. All rights reserved.
//

import UIKit
import UserNotifications

class ChoresTableViewController: UITableViewController, CellSubclassDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NewChoresDelegate {
    
    @IBOutlet weak var addChoreButton: UIBarButtonItem!
    
    var tempIndexPath: IndexPath?
    var currentTitle: String!
    var currentImage: UIImage!
    var firstLoad = true
    
    let notificationController = NotificationController()
    var residentsDue = [String]() {
        didSet {
            notificationController.checkIfUserIsUp(users: residentsDue)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCell()
        ChoreModelController.delegate = self
      
        
    
        
        if !Bool(UserModelController.currentUser.isAdministrator)! {
            addChoreButton.isEnabled = false
            addChoreButton.tintColor = UIColor.clear
        } else {
            self.navigationItem.leftBarButtonItem = editButtonItem
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func reloadCells() {
        tableView.reloadData()
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChoreModelController.chores.count
        
    }
    
    func registerTableViewCell() {
        let choreCell = UINib(nibName: "ChoreTableViewCell", bundle: nil)
        self.tableView.register(choreCell, forCellReuseIdentifier: "ChoreCell")
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoreCell", for: indexPath) as! ChoreTableViewCell
        
        let chore = ChoreModelController.chores[indexPath.row]
        cell.choreTitleLabel.text = chore.title
        cell.choreImageView.image = chore.photo
        cell.choreDueDateLabel.text = "Due: \(getDateString())"
        cell.chorePersonDueLabel.text = "By \(HouseModelController.residents[indexPath.row])"
        cell.choreDaysLeft.text = "Days left: \(ChoreModelController.daysInterval(date: Date()))"
        cell.delegate = self
        
        // set residents due for chores
        residentsDue.append(HouseModelController.residents[indexPath.row])
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if firstLoad {
            cell.alpha = 0
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0.05 * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
            })
            firstLoad = false
        }
    }
    
    func getDateString() -> String {
        let date = ChoreModelController.dueDate
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale(identifier: "nl_NL")
        dateformatter.setLocalizedDateFormatFromTemplate("MMMMdE")
        let dateString = dateformatter.string(from: date)
        
        return dateString
    }
    
    
    func cleanedButtonPressed(cell: ChoreTableViewCell) {
        presentImagePicker()
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        tempIndexPath = indexPath
    }
    
    func imageTapped(cell: ChoreTableViewCell) {
        self.currentTitle = cell.choreTitleLabel.text
        self.currentImage = cell.choreImageView.image
        performSegue(withIdentifier: "imageSegue", sender: nil)
    }

    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.cameraDevice = .rear
        
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        if let index = tempIndexPath {
            ChoreModelController.chores[index.row].photo = image
            ChoreModelController.saveChoresDirectory()
            
            // TODO: set days left to "chore done"

        }
        picker.dismiss(animated: true) {
            guard let index = self.tempIndexPath?.row else { return }
            ChoreModelController.getChoreID(choreName: ChoreModelController.chores[index].title, completion: { (id) in
                ChoreModelController.mutateChore(chore: ChoreModelController.chores[index], id: id)
            })
        }
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if Bool(UserModelController.currentUser.isAdministrator)! {
            return true
        } else {
            return false
        }
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let chore = ChoreModelController.chores[indexPath.row]
            ChoreModelController.getChoreID(choreName: chore.title) { (id) in
                ChoreModelController.deleteChore(with: id, completion: {
                    print("Chore Deleted")
                })
            }
            ChoreModelController.chores.remove(at: indexPath.row)
            ChoreModelController.saveChoresDirectory()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    

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
        if segue.identifier == "imageSegue" {
            let imageViewController = segue.destination as! DetailImageViewController
            imageViewController.image = self.currentImage
            imageViewController.imageTitle = self.currentTitle
        }
    }
    
    
    @IBAction func unwindToChores(segue: UIStoryboardSegue) {

    }

}
