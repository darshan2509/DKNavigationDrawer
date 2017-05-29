//
//  DrawerView.swift
//  DKNavigationDrawer
//
//  Created by Darshan on 5/17/17.
//  Copyright © 2017 Darshan. All rights reserved.
//

import UIKit

class DrawerView: UIView {
    @IBOutlet weak var drawerTableView: UITableView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initialization code
        //_lblName.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     
     
     */
    override func draw(_ rect: CGRect) {
        //Drawing code
        
    
    }

}
