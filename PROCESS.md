# Day 1
Today I submitted my final proposal at https://github.com/freesers/AppStudioProject/blob/master/README.md
I'm planning to make a WieBetaaldWat-like app for cleaning schedules in student houses. After consulting with a TA i found out the server component can be done using FireBase. 

# Day 2
Today I submitted my (first) design document and I met with my group (H) 
![](doc/UISketches.png)
The user first logs in or registers, the is presented with a tab bar controller between three main screens. Then there will be a couple loose viewcontrollers either presented modally or with a show - detail style. 

![](doc/UtilityModels.png)
The first ideas on how the data should be modeled. The main structures are Users (detailing user information) and Chores.

# Day 3
Today I mainly foccused reading the Human Interface guidelines and working on my prototype. Spent the day reading up on FireBase, articles from John Sundell (https://www.swiftbysundell.com) about GCD and the basics of UserNotifications

# Day 4
The day started off with our first team meeting with Emma, we discussed our projects and prototypes. Fried (teammember) mentioned that he had had a TA telling him FireBase might be too big for the scope of this project. And to use a local server instead. I'm personally not sure yet whether I want to use it or not, as a local server would kind of defeat the purpose of this app. I finished the day with completing my prototype and reading more about FireBase Realtime Storage
Storyboard:
![](doc/Prototype10:01.png)
Detail of first version custom table cell:
![](doc/ChoreTableCellV1.png)

# Day 5
Spent all day trying to get FireBase storage to work, unfortunately too large a hassle to integrate into the project (Should have listened to earlier advice). Decided I will only be using FireBase for Authentication, then using the specific UID in own local server. Will modify the resto server to work with my app.

# Day 6
Today I began modelling the datastructure of the users and houses. I decided I'd create datamodelcontrollers which can be used troughout the app. Still have to figure out how to make it work with the new resto server, Martijn still has to do some modifcations to the server for it to work with the app (filtering in querries). 
Then had a team meeting for the basic style guide (https://github.com/freesers/AppStudioProject/blob/master/STYLE.md) and updates. Fried is also waiting on the server to work.
Almost finished with work for user registration. Uses FireBase Auth, for registration and login. Handles most cases (wrong password, same email etc. Decided that if you chose to create a new house, you become the administrator. App warns you about that. 
Basic registration screen:
![](doc/RegistrationScreen14jan.png)
