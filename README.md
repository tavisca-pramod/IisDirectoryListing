IIS DirectoryListing
===================
  IIS 7
  1.  Run the following from a command prompt (open it with the "run as Administrator" option):
  %windir%System32inetsrvappcmd set module DirectoryListingModule /lockItem:false
  (this is done to unlock the built-in DirectoryListingModule for removal in the application, so that it can be replaced with our custom one)
  2.  Create an application, and unzip the contents of the repository into its root directory. DONE!
  
  IIS6:
  1.  Create an application, and configure ASP.NET 2.0 to be a wildcard mapping for it. 
  2.  Unzip the contents of the repository into the root directory of your application, and you are good to go. DONE!
