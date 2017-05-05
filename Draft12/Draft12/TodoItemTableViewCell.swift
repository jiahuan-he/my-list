//
//  TodoItemTableViewCell.swift
//  Draft11
//
//  Created by LMAO on 27/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//
protocol TodoItemTableViewCellDelegate{
    func cellHeightDidChange(editingCell: TodoItemTableViewCell)
    func itemDeleted(item: TodoItem)
    func cellDidBeginEditing(editingCell: TodoItemTableViewCell)
    func cellDidEndEditing(editingCell: TodoItemTableViewCell)
}


import UIKit

class TodoItemTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet var textView: UITextView!
    var delegate: TodoItemTableViewCellDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    let rightBorder = CALayer()        

    
    var todoItem: TodoItem?
        //for testing purpose
    {
        didSet{
            textView.text = todoItem?.name
        }
    }
    
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var completeOnDragRelease = false      
    
    override func awakeFromNib() {
        //        textView.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 50)
        textView.textContainerInset = UIEdgeInsetsMake(20, 2, 15, 2)
        
        
        
        rightBorder.frame = CGRect(x: screenSize.width-6, y: 0, width: 6, height: textView.frame.height)
        rightBorder.backgroundColor = UIColor.red.cgColor
        textView.layer.addSublayer(rightBorder)
        
        
        let dateLabel = UILabel(frame: CGRect(x: 5, y: 2, width: 60, height: 20))
        dateLabel.text = "tomorrow"
        dateLabel.font = UIFont(name: "Helvetica", size: 13)
        dateLabel.textColor = UIColor.red
        
        let timeLabel = UILabel(frame: CGRect(x: 65, y: 2, width: 60, height: 20))
        timeLabel.text = "8:00 pm"
        timeLabel.font = UIFont(name: "Helvetica", size: 13)
        timeLabel.textColor = UIColor.red

        textView.addSubview(timeLabel)
        textView.addSubview(dateLabel)

        let dueLabel = UILabel(frame: CGRect(x: screenSize.width/2+50, y: 0, width: 60, height: 30))
        dueLabel.text = "Due"
        
        
        let redLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        redLabel.backgroundColor = UIColor.red
        redLabel.text = "Red"
        redLabel.textColor = UIColor.clear
        
        
        let orangeLabel = UILabel(frame: CGRect(x: 30, y: 0, width: 30, height: 30))
        orangeLabel.backgroundColor = UIColor.orange
        orangeLabel.text = "Orange"
        orangeLabel.textColor = UIColor.clear
        
        
        let yellowLabel = UIButton(frame: CGRect(x: 60, y: 0, width: 30, height: 30))
        yellowLabel.backgroundColor = UIColor.yellow
        yellowLabel.setTitle("Yellow", for: .normal)

        textView.returnKeyType = UIReturnKeyType.done
        textView.delegate = self
        
        
        
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)

    }
    
    func handlePan(recognizer: UIPanGestureRecognizer){
        
        // 1
        if recognizer.state == .began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        
        // 2
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
//            print(center.x, "  ",center.y)
            deleteOnDragRelease = (frame.origin.x < -frame.size.width / 2.0)
            completeOnDragRelease = (frame.origin.x > frame.size.width / 2.0)
        }
        
        // 3
        if recognizer.state == .ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            
            if deleteOnDragRelease {
                if delegate != nil && todoItem != nil {
                    // notify the delegate that this item should be deleted
                    delegate!.itemDeleted(item: self.todoItem!)
                    //                    itemCompleteLayer.isHidden = !itemCompleteLayer.isHidden
                    //                    UIView.animate(withDuration: 0.2, animations:
                    //                        {
                    //                            self.frame = originalFrame
                    //                    })
                }
            }
            else if completeOnDragRelease {
                todoItem!.isComplete = !todoItem!.isComplete
                UIView.animate(withDuration: 0.5, animations: {self.frame = originalFrame})
            }
            else {
                // if the item is not being deleted, snap back to the original location
                UIView.animate(withDuration: 0.2, animations:
                    {
                        self.frame = originalFrame
                })
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let startHeight = textView.frame.size.height
        let calcHeight = textView.sizeThatFits(textView.frame.size).height
        if startHeight != calcHeight{
            delegate?.cellHeightDidChange(editingCell: self)
        }
    }
    
    // prevent appending new line.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate!.cellDidBeginEditing(editingCell: self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        todoItem!.name = textView.text!
        delegate!.cellDidEndEditing(editingCell: self)
    }
}


