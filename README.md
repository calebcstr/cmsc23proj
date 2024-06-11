## Final Project: Elbi Donation System
### CMSC23 UV-4L 2nd Semester A.Y. 2023-2024
### Castro, Han Caleb D. | Espino, Dylan Ross L. | Hadi, Maria Catrina O.

### About
- A mobile app donation system where the user can sign up as a donor/organization
- signing up as an organization required a photo proof of legitimacy which must be then approved by the admin
- admins can monitor all the signed up donors and organizations as well as the donations (and its status)
- donors can donate to donation drives created by an organization (can be cancelled)
- organizations then updates the status of the donation once submitted

### Organization view
    shows all the donations to the specific organization which can be used to view the details of the donation and update the status of the donation, CRUD functions for a donation drive as well as seeing the organization’s information and updating its own status as open or closed for future donations.

### Donor view
    you are first routed to the homepage which allows you to go to the user's profile, the donate page, and also to the user's history of donations. Along with it comes a list of the organizations signed up in the app. user's profile shows the general information of the user (info from signup). donate page shows also a list of organizations (that are open for donations) and their respective donation drives. after picking a donation drive you are then routed to the donation portal which you and provide the info of your donation along with a optional photo of the user's donation. the user's history of donations lets the user track their past donations (with their information and photo) along with the photo proof that the organization provided if the donation is complete. donors have also the right to cancel their own donations if it has not yet been cancelled/completed by the organization
    
### Admin view
    manages and has access to all signed up donors, organizations, and all processed donations throughout the program. has the ability to deny or give access to signed up organizations.

