//
//  TodoItemTableViewCell.swift
//  Draft11
//
//  Created by LMAO on 27/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//
protocol TodoItemTableViewCellDelegate{
    func cellHeightDidChange(cell: TodoItemTableViewCell)
    func deleteToDoItem(item: TodoModel)
    func completeToDoItem(item: TodoModel)
}

import UIKit

class TodoItemTableViewCell: UITableViewCell, UITextViewDelegate, CAAnimationDelegate {
    
    var item : TodoModel?{
        didSet{
            textView.text = item?.content
//            adjustHeightConstrant() // TEMP : can cause BUG which is one more cell than needed is loaded into view.
        }
    }
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    let rightBorder = CALayer()
    
    var originalCenter = CGPoint()
    var deleteOnRelease = false    
    
    var delegate: TodoItemTableViewCellDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func awakeFromNib() {
<<<<<<< HEAD
=======
        //        textView.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 50)
        textView.textContainerInset = UIEdgeInsetsMake(20, 2, 15, 2)
>>>>>>> b2
        
        textView.textContainerInset = UIEdgeInsetsMake(30, 2, 10, 0)
        rightBorder.frame = CGRect(x: screenSize.width-6, y: 0, width: 6, height: textView.frame.height)
        rightBorder.backgroundColor = UIColor.red.cgColor
        textView.layer.addSublayer(rightBorder)
        
<<<<<<< HEAD
=======
        
>>>>>>> b2
        let dateLabel = UILabel(frame: CGRect(x: 5, y: 2, width: 60, height: 20))
        dateLabel.text = "tomorrow"
        dateLabel.font = UIFont(name: "Helvetica", size: 13)
        dateLabel.textColor = UIColor.red
<<<<<<< HEAD
=======
        
        let timeLabel = UILabel(frame: CGRect(x: 65, y: 2, width: 60, height: 20))
        timeLabel.text = "8:00 pm"
        timeLabel.font = UIFont(name: "Helvetica", size: 13)
        timeLabel.textColor = UIColor.red
        
        
        
        textView.addSubview(timeLabel)
        textView.addSubview(dateLabel)
        
        
        let toobar = toolbarView(frame: CGRect(x: 0, y:0 , width: screenSize.width, height: 30))
>>>>>>> b2
        
        let timeLabel = UILabel(frame: CGRect(x: 65, y: 2, width: 60, height: 20))
        timeLabel.text = "8:00 pm"
        timeLabel.font = UIFont(name: "Helvetica", size: 13)
        timeLabel.textColor = UIColor.red
        
        textView.addSubview(timeLabel)
        textView.addSubview(dateLabel)
        
        let toobar = toolbarView(frame: CGRect(x: 0, y:0 , width: screenSize.width, height: 30))
        let dueLabel = UILabel(frame: CGRect(x: screenSize.width/2+50, y: 0, width: 60, height: 30))
        dueLabel.text = "Due"
        let redButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        
        redButton.setTitle("red", for: .normal)
        redButton.addTarget(self, action: #selector(self.didPressRedButton(sender:)), for: .touchUpInside)
        
        let yellowButton = UIButton(frame: CGRect(x: 50, y: 0, width: 60, height: 30))
        yellowButton.setTitle("yellow", for: .normal)
<<<<<<< HEAD
        yellowButton.addTarget(self, action: #selector(self.didPressRedButton(sender:)), for: .touchUpInside)

//        let greenButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        greenButton.setTitle("green", for: .normal)
=======
        //
        //        let greenButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        //        redButton.setTitle("green", for: .normal)
        
>>>>>>> b2
        
        toobar.addSubview(redButton)
        toobar.addSubview(yellowButton)
        toobar.addSubview(dueLabel)
<<<<<<< HEAD
//        toobar.addSubview(greenButton)

        toobar.backgroundColor = UIColor.brown
=======
        //        toobar.addSubview(greenButton)
        
        
        
        toobar.backgroundColor = UIColor.brown
        
        
        
        
        
>>>>>>> b2
        textView.returnKeyType = UIReturnKeyType.done
        
//        textView.sizeToFit() // CAN CAUSE BUG: size doesn't fit
        stackViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height
        textView.delegate = self
        
        textView.inputAccessoryView = toobar
        
        // Add gesture recognizer. 
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
    }
    
    //Pan Gesture recognizer.
    func handlePan(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .began{
            print("width ", -bounds.size.width )
            originalCenter = center
        }
        if recognizer.state == .changed{
            center = CGPoint(x: originalCenter.x+recognizer.translation(in: self).x, y: originalCenter.y)
            
        }
        if recognizer.state == .ended{
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            if frame.origin.x < -bounds.size.width/3 {
                delegate?.deleteToDoItem(item: item!)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                self.frame = originalFrame
                
            })
                //TODO debug: have to swipe twice to delete a cell!
                item!.completed = !item!.completed
                self.delegate?.completeToDoItem(item: self.item!)
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let recognizer = gestureRecognizer as? UIPanGestureRecognizer{
            if fabs(recognizer.translation(in: self).x) > fabs(recognizer.translation(in: self).y){
                return true
            }
        }
        return false
    }

    func didPressRedButton(sender: UIButton){
        print(sender.titleLabel?.text ?? "")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        adjustHeightConstrant()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            adjustHeightConstrant()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func adjustHeightConstrant(){
        stackViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height
        delegate!.cellHeightDidChange(cell: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        adjustHeightConstrant()
    }
<<<<<<< HEAD
}

    
=======
    
    
}






>>>>>>> b2
