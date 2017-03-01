//
//  StackViewController.swift
//  Draft11
//
//  Created by LMAO on 28/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

class StackViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var constraintStackviewHeight: NSLayoutConstraint!
    @IBOutlet weak var expandedView: UIView!
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        
//        print("expanded view  " , expandedView.bounds.size.height )
        
        constraintStackviewHeight.constant = textView.sizeThatFits(textView.frame.size).height + 105
        
        print("total height", constraintStackviewHeight.constant)
        
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        textView.delegate = self        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
