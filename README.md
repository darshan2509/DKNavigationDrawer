# DKNavigationDrawer
Navigation Drawer for iOS using Swift. 

Take a look at this GIF or the mov file in project
 https://media.giphy.com/media/I45syjhreC0Rq/giphy.gif

1. Add DKNavDrawerDelegate, DrawerView and DrawerView to project.
2. Assign class DKNavDrawer to your navigation controller
3. Add a Right Bar Button to your RootViewController connect it to a action.
4. RootViewController should conform to DKNavDrawerDelegate
5. Initialize -  var rootNav: DKNavDrawer?


In viewDidLoad() of RootViewController add 2 lines  
 	
	rootNav = (navigationController as? DKNavDrawer)
	rootNav?.dkNavDrawerDelegate = self

The button action code

	@IBAction func btnToggle(_ sender: Any) {
          rootNav?.drawerToggle()
    }
    //Implement this as this is a delegate method
       func dkNavDrawerSelection(_ selectionIndex: Int) {
    }
