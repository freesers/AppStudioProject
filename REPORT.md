# Final Report - Sweep

Sweep lets users create and join houses to manage the chores that need to be done. To make sure everybody does their chores, Sweep automatically schedules every resident and notifies them when they're up. And to check whether someone has done their chore correctly, residents have to take a picture when they're done.

![](doc/chores.PNG)

## Technical Desgin
![](doc/finalDesign.png)
![](doc/finalUtilityModels.png)

### LoginViewController
Handles the login screen. If user is already signed in, he/she is redirected to the choreTableView. Requests all neccesary data (User info, House info & corresponding Chore info) with help from the User-, House- and ChoreModelController from the server. After a succesful verification with FireBase and the local server, the current schedule is calculated and the user is redirected to the choreTableView. This viewcontroller is also the destination of the unwind segues: sign out & leave house. If a user doesn't have an account yet, he/she can tap the "register" button, which segues to user to the RegisterViewController. 

### RegisterViewController
Handles all interactions when a new user registers. New users have to enter a correct email and long enough password, and will get notified if they fail to do so. New users can choose to create a new house, or pick an existing house from a picker viewer. When a user creates a new house, he/she will become the administrator of that house. He/she can add and delete chores. When the user taps the registers button, all fields are checked for input and correctness. If correct, a new User (with possible a new House) is created & uploaded with help of the UserModelController & HouseModelcontroller. The user then segues to the ChoresTableViewcontroller.

### ChoreTableViewController
Handles the tableview of all Chore(s) in a House. Shows when they're due, how long until due date & whom is responsible. This viewcontroller also asks the NotificationController if a push notification should be scheduled. Whenever the user who's signed in is an administrator, this viewcontroller enables the "addChoreButton" and editing of the tableview. Upon first load, the cells fade in. The loading of the chores which begun in the LoginViewController continues until the server request is complete, the cells are then reloaded. In the meantime, the chores last seen in the app are already loaded from the documentsdirectory, not leaving the user have to wait before he/she sees content. All the data needed for loading the tableview is received from the User-, House- & ChoreModelcontroller. The viewcontroller also conforms to CellSubClassDelegate and NewChoresDelegate which handle the interaction with the cell.
Whenever the "cleaned" button is tapped, an imagepickercontroller is presented which lets the user take a picture of the finished chore. The image of the cell is updated and the ChoreModelController is asked to mutate a chore on the server

### ChoreTableViewCell
This subclass of UITableViewCell sets up the custom button, borderwith of the imageview and creates a tapable overlay on the image. It also informs the delegate that the image or button has been tapped. The ChoreTableViewController is then notified which cells is tapped.

### DetailImageViewController
This viewcontroller is segued to whenever a user taps an image on one of the cells. Users are then able to zoom and scroll the image. To see whether the chore is done correctly

### AddChoreViewController
This viewcontroller is only accesible to the administrator of the house. It lets the administrator add new chores to a house. He/she has to specify a title and an image of a cleaned chore. Only if these to conditions are met the save button is tapable. And the Chore is saved to the directory and uploaded to the server via the ChoreModelController.

### ScheduleTableViewController
This viewcontroller is responsible for showing the cleaning schedule. It calculates the weeknumbers (6, arbitrary), and fills the rows of the sections with Chores en residents. To make sure the schedule contiously stays correct. The array of the loaded residents is shifted to the correct order each time the app starts. This is done with the ScheduleController, which starts with a refference week, the gets the current week, and rearranges the array based on the difference in weeks. Because the array is in the correct order. The tableview repeatedly loads the array as datasource. As a small easteregg the user can shake the device, which results in the schedule showing the coming thousand weeks. Shaking again returns to the standard six weeks.

### ResidentsViewController
This viewcontroller greets the current user, show the current residents of the house and lets the user sign out or leave the hosue. The tableview displaying the residents is a subview which gets its data from the HouseModelController, and is only scrollable if the data exceeds the boundry of the view. The button to leave the house shows a warning alert and deletes the user from FireBase and the server with help from the UserModelController and HouseModelController. Tapping sign out, simply signs out from firebase and unwinds to the login screen, as does the leave house button upon confirmation



