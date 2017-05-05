//
//  ViewController.swift
//  Draft12
//
//  Created by LMAO on 03/05/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet var myView: UIView!

    override func viewDidLoad() {
        let button = UIButton(frame: CGRect(x: 90, y: 90, width: 60, height: 60))
        button.setTitle("bbbb", for: .normal)
        textField.inputAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        textField.inputAccessoryView?.backgroundColor = UIColor.brown
        let button2 = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        button2.setTitle("cccccc", for: .normal)
        button2.tintColor = UIColor.blue
        textField.inputAccessoryView!.addSubview(button2)
        
        let tap = UITapGestureRecognizer(target: button, action: #selector(self.tata))
        button2.addGestureRecognizer(tap)
        textField.inputAccessoryView!.isUserInteractionEnabled = true
        button2.isUserInteractionEnabled = true
        
        
        
        
        super.viewDidLoad()
        
        
        myView.addSubview(button)
        myView.backgroundColor = UIColor.black
        
        button.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tata(){
        print("aa")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
