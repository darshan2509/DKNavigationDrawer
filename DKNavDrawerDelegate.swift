//
//  DKNavDrawerDelegate.swift
//  DKNavigationDrawer
//
//  Created by Darshan on 5/17/17.
//  Copyright © 2017 Darshan. All rights reserved.
//

import UIKit


protocol DKNavDrawerDelegate: NSObjectProtocol {
    //add methods as per requirements
    func dkNavDrawerSelection(_ selectionIndex: Int)
    
    
    
}


class DKNavDrawer: UINavigationController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    var pan_gr: UIPanGestureRecognizer?
    weak var dkNavDrawerDelegate: DKNavDrawerDelegate?
    
    var SHAWDOW_ALPHA:Float = 0.5
    var MENU_DURATION:Float = 0.3
    let MENU_TRIGGER_VELOCITY = 350
    var isOpen: Bool = false
    var meunHeight: Float = 0.0
    var menuWidth: Float = 0.0
    var outFrame = CGRect.zero
    var inFrame = CGRect.zero
    var shawdowView: UIView?
    var drawerView: DrawerView?
    
    private var menuItems = [Any]()
    private var menuImages = [Any]()
    
    // MARK: - VC lifecycle
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Custom initialization
        
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        menuItems = [" Profile", "Address", "Orders"]
        menuImages = ["avatar", "contacts", "shoppingcart"]
        setUpDrawer()
    }
    
    
    func setUpDrawer() {
        isOpen = false
        // load drawer view
        drawerView = Bundle.main.loadNibNamed("DrawerView", owner: self, options: nil)?[0] as? DrawerView
        let wind = UIWindow(frame: UIScreen.main.bounds)
        var width: Float = (Float(wind.frame.size.width))
        width = width * 0.65
        // Adjust width here
        meunHeight = Float(wind.frame.size.height)
        menuWidth = width
        outFrame = CGRect(x: CGFloat(-menuWidth), y: CGFloat(0), width: CGFloat(menuWidth), height: CGFloat(meunHeight))
        inFrame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(menuWidth), height: CGFloat(meunHeight))
        print("inframe=\(meunHeight)")
        // drawer shawdow and assign its gesture
        shawdowView = UIView(frame: view.frame)
        shawdowView?.backgroundColor = UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(0.0))
        shawdowView?.isHidden = true
        let tapIt = UITapGestureRecognizer(target: self, action: #selector(self.taponShawdow))
        shawdowView?.addGestureRecognizer(tapIt)
        shawdowView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shawdowView!)
        // add drawer view
        drawerView?.frame = outFrame
        view.addSubview(drawerView!)
        // drawer list
        drawerView?.drawerTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        // statuesBarHeight+navBarHeight
        drawerView?.drawerTableView.dataSource = self
        drawerView?.drawerTableView.delegate = self
        //seprator cleanup
        drawerView?.drawerTableView.tableFooterView = UIView(frame: CGRect.zero)
        // gesture on self.view
        pan_gr = UIPanGestureRecognizer(target: self, action: #selector(self.moveDrawer))
        pan_gr?.maximumNumberOfTouches = 1
        pan_gr?.minimumNumberOfTouches = 1
        //self.pan_gr.delegate = self;
        view.addGestureRecognizer(pan_gr!)
        view.bringSubview(toFront: navigationBar)
        //    for (id x in self.view.subviews){
        //        NSLog(@"%@",NSStringFromClass([x class]));
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - push & pop
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        // disable gesture in next vc
        pan_gr?.isEnabled = false
    }
    
    override func popViewController(animated: Bool) -> UIViewController {
        let vc: UIViewController? = super.popViewController(animated: animated)
        // enable gesture in root vc
        if viewControllers.count == 1 {
            pan_gr?.isEnabled = true
        }
        return vc!
    }
    
    // MARK: - drawer
    func drawerToggle() {
        if !isOpen {
            openNavigationDrawer()
        }
        else {
            closeNavigationDrawer()
        }
    }
    
    //open and close action
    func openNavigationDrawer() {
        //    NSLog(@"open x=%f",self.menuView.center.x);
        
        let duration: Float = MENU_DURATION / menuWidth * fabs(Float(drawerView!.center.x)) + MENU_DURATION / 2
        // y=mx+c
        // shawdow
        shawdowView?.isHidden = false
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.shawdowView?.backgroundColor = UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(self.SHAWDOW_ALPHA))
        }, completion: { _ in })
        // drawer
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .beginFromCurrentState, animations: {() -> Void in
            self.drawerView?.frame = self.inFrame
        }, completion: { _ in })
        isOpen = true
    }
    
    func closeNavigationDrawer() {
        //    NSLog(@"close x=%f",self.menuView.center.x);
        let duration: Float = MENU_DURATION / menuWidth * fabs(Float(drawerView!.center.x)) + MENU_DURATION / 2
        // y=mx+c
        // shawdow
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .curveEaseInOut, animations: {() -> Void in
            self.shawdowView?.backgroundColor = UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(0.0))
        }, completion: {(_ finished: Bool) -> Void in
            self.shawdowView?.isHidden = true
        })
        // drawer
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: .beginFromCurrentState, animations: {() -> Void in
            self.drawerView?.frame = self.outFrame
        }, completion: { _ in })
        isOpen = false
    }
   
    
    func taponShawdow(recognizer: UITapGestureRecognizer) {
        closeNavigationDrawer()
    }

    func moveDrawer(_ recognizer: UIPanGestureRecognizer) {
        let translation: CGPoint = recognizer.translation(in: view)
        let velocity: CGPoint? = (recognizer as UIPanGestureRecognizer).velocity(in: view)
        //    NSLog(@"velocity x=%f",velocity.x);
        if (recognizer as UIPanGestureRecognizer).state == .began {
            //        NSLog(@"start");
            
            let x:Int = Int((velocity?.x)!)
            
            
            if  x > MENU_TRIGGER_VELOCITY && !isOpen {
                openNavigationDrawer()
            }
            else if x < -MENU_TRIGGER_VELOCITY && isOpen {
                closeNavigationDrawer()
            }
        }
        if (recognizer as UIPanGestureRecognizer).state == .changed {
            //        NSLog(@"changing");
            let movingx: Float = Float(drawerView!.center.x + translation.x)
            print("menuWidth== \(menuWidth / 2)")
            if movingx > -menuWidth / 2 && movingx < menuWidth / 2 {
                drawerView?.center = CGPoint(x: CGFloat(movingx), y: CGFloat((drawerView?.center.y)!))
                recognizer.setTranslation(CGPoint(x: CGFloat(0), y: CGFloat(0)), in: view)
                let changingAlpha: Float = SHAWDOW_ALPHA / menuWidth * movingx + SHAWDOW_ALPHA / 2
                // y=mx+c
                shawdowView?.isHidden = false
                shawdowView?.backgroundColor = UIColor(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: CGFloat(changingAlpha))
            }
        }
        if (recognizer as UIPanGestureRecognizer).state == .ended {
            //        NSLog(@"end");
            if Int((drawerView?.center.x)!) > 0 {
                openNavigationDrawer()
            }
            else if Int((drawerView?.center.x)!) < 0 {
                closeNavigationDrawer()
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier: String = "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: CellIdentifier)
        }
        // Configure the cell...
        cell?.textLabel?.text = "\(menuItems[indexPath.row])"
        cell?.textLabel?.textColor = UIColor(red: CGFloat(240 / 255.0), green: CGFloat(128 / 255.0), blue: CGFloat(50 / 255.0), alpha: CGFloat(1))
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
        cell?.imageView?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(30), height: CGFloat(30))
        // cell.imageView.backgroundColor=[UIColor redColor];
        cell?.imageView?.image = UIImage(named: "\(menuImages[indexPath.row])")
        cell?.textLabel?.text = "\(menuItems[indexPath.row])"
        // if (indexPath.row==1 || indexPath.row==0 ||indexPath.row==2 || indexPath.row==3 || indexPath.row==5 ||indexPath.row==9) {
        //cell.layoutMargins = UIEdgeInsetsZero;
        // cell.separatorInset = UIEdgeInsetsMake(1.0f, 1.0f, 0.0f, cell.bounds.size.width)   ;
        //}
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dkNavDrawerDelegate?.dkNavDrawerSelection(indexPath.row)
        closeNavigationDrawer()
    }
    
}
