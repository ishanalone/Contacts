# Contacts
This project store contacts of individual in database with backend to Add, Edit and List functionality.
Project also has iOS apps providing below functionality
1. Show contacts list in "Contacts" Tab
2. Able to sort contact list by Name, email and updated time.
3. Search list by name and email.
4. Tap to view contact detail.
5. "Detail" page show  details with email, phone number (with country code).
6. Details can be edited by clicking "Edit" button.
7. In non editing mode single tap on phone will make call and tap on email will open mail composer.
8. In non editing mode long press on all fields will copy to clipboard.
9. In "Recents" tab tap on contact will make a call directly and long press will copy phone number.

# To be Done
1. Create this provision for multiple users based on login.
2. Save contact data locally or sync with device contacts.
3. Host backend services on cloud.
4. As backend app is not hosted on server, only running on simulator( phone call cant be made), as phone app cant access localhost.

# Tech Stack
1. Swift : iOS app
2. Node.JS : Backend app
3. Postgress : RDBMS
4. Sequelize : ORM ,wrapper over RDBMS
5. Heroku : Hosting service for RDBMS

# Steps to install

1. Clone repo.
2. Download and install Node.js : https://nodejs.org
3. Open terminal at root folder and run "npm install" : Will install all node components saved in package.json
4. After completion run "node app" : Will start local server.
5. Open terminal in iOS folder and run "pod install" : Install external dependencies for iOS project.
6. Open newly created .workspace file and run on simulator.

