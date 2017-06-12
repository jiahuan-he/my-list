//
//  TodoItemTableViewCell.swift
//  Draft11
//
//  Created by LMAO on 27/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//
protocol TodoItemTableViewCellDelegate{
    func cellHeightDidChange(editingCell: TodoItemTableViewCell, heightChange: CGFloat)
    func itemDeleted(item: TodoItem)
    func cellDidBeginEditing(editingCell: TodoItemTableViewCell)
    func cellDidEndEditing(editingCell: TodoItemTableViewCell)
}

enum labelTag: Int {
    case Red
    case Orange
    case Cyan
    case Green
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
    
    var redButton: UIButton?
    var orangeButton: UIButton?
    var cyanButton: UIButton?
    var greenButton: UIButton?
    
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
        dateLabel.font = UIFont(name: "Avenir", size: 13)
        dateLabel.textColor = UIColor.red
        
        let timeLabel = UILabel(frame: CGRect(x: 65, y: 2, width: 60, height: 20))
        timeLabel.text = "8:00 pm"
        timeLabel.font = UIFont(name: "Avenir", size: 13)
        timeLabel.textColor = UIColor.red
        
        
        let labelRadius = 5.0
        let labelWidth = 16
        let labelPosY = 6
        let labelPosX = 205
        let distance = 25
        
        redButton = UIButton(frame: CGRect(x: labelPosX, y: labelPosY, width: labelWidth, height: labelWidth))
        redButton!.backgroundColor = UIColor.red
        redButton!.layer.masksToBounds = true
        redButton!.layer.cornerRadius = CGFloat(labelRadius)
        
        orangeButton = UIButton(frame: CGRect(x: labelPosX+distance, y: labelPosY, width: labelWidth, height: labelWidth))
        orangeButton!.backgroundColor = UIColor.orange
        orangeButton!.layer.cornerRadius = CGFloat(labelRadius)
        orangeButton!.layer.masksToBounds = true
        
        cyanButton = UIButton(frame: CGRect(x: labelPosX+2*distance, y: labelPosY, width: labelWidth, height: labelWidth))
        cyanButton!.backgroundColor = UIColor.cyan
        cyanButton!.layer.masksToBounds = true
        cyanButton!.layer.cornerRadius = CGFloat(labelRadius)
        
        greenButton = UIButton(frame: CGRect(x: labelPosX+3*distance, y: labelPosY, width: labelWidth, height: labelWidth))
        greenButton!.backgroundColor = UIColor.green
        greenButton!.layer.masksToBounds = true
        greenButton!.layer.cornerRadius = CGFloat(labelRadius)
        
        textView.addSubview(redButton!)
        textView.addSubview(orangeButton!)
        textView.addSubview(cyanButton!)
        textView.addSubview(greenButton!)
        
        redButton!.tag = labelTag.Red.rawValue
        orangeButton!.tag = labelTag.Orange.rawValue
        cyanButton!.tag = labelTag.Cyan.rawValue
        greenButton!.tag = labelTag.Green.rawValue
        
        redButton!.addTarget(self, action: #selector(self.setRed(sender:)), for: UIControlEvents.touchUpInside)
        redButton!.isUserInteractionEnabled = true
        
        orangeButton!.addTarget(self, action: #selector(self.setRed(sender:)), for: UIControlEvents.touchUpInside)
        orangeButton!.isUserInteractionEnabled = true
        
        cyanButton!.addTarget(self, action: #selector(self.setRed(sender:)), for: UIControlEvents.touchUpInside)
        cyanButton!.isUserInteractionEnabled = true
        
        greenButton!.addTarget(self, action: #selector(self.setRed(sender:)), for: UIControlEvents.touchUpInside)
        greenButton!.isUserInteractionEnabled = true
        
        
        textView.addSubview(timeLabel)
        textView.addSubview(dateLabel)
        
        hideLabels()
        
        textView.returnKeyType = UIReturnKeyType.done
        textView.delegate = self
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
        
//        let redTap = UITapGestureRecognizer(target: self, action: #selector(self.setRed(sender:)))
//        redLabel!.isUserInteractionEnabled = true
//        
//        
//        let orangeTap = UITapGestureRecognizer(target: self, action: #selector(self.setRed(sender:)))
//        orangeLabel!.isUserInteractionEnabled = true
//        
//        
//        let cyanTap = UITapGestureRecognizer(target: self, action: #selector(self.setRed(sender:)))
//        cyanLabel!.isUserInteractionEnabled = true
//        
//        
//        let greenTap = UITapGestureRecognizer(target: self, action: #selector(self.setRed(sender:)))
//        greenLabel!.isUserInteractionEnabled = true
//        
    }
    
    func setRed(sender: UIButton){
        print(sender.tag)
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
//            print(calcHeight - startHeight)
            delegate?.cellHeightDidChange(editingCell: self, heightChange: calcHeight - startHeight)
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
        unhideLabels()
        delegate!.cellDidBeginEditing(editingCell: self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        hideLabels()
        todoItem!.name = textView.text!
        delegate!.cellDidEndEditing(editingCell: self)
    }
    
    private func hideLabels(){
        orangeButton!.isHidden = true
        cyanButton!.isHidden = true
        redButton!.isHidden = true
        greenButton!.isHidden = true
    }
    
    private func unhideLabels(){
        orangeButton!.isHidden = false
        cyanButton!.isHidden = false
        redButton!.isHidden = false
        greenButton!.isHidden = false
    }
}


