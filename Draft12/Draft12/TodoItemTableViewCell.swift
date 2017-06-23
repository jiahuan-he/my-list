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
    func itemComplete(editingCell: TodoItemTableViewCell)
    func cellDidBeginEditing(editingCell: TodoItemTableViewCell)
    func cellDidEndEditing(editingCell: TodoItemTableViewCell)
    func cellFlagDidChange(editingCell: TodoItemTableViewCell)
    func popupDatePicker(editingCell: TodoItemTableViewCell)
    
}

extension NSDate
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
}


enum labelTag: Int {
    case Red
    case Orange
    case Cyan
    case Green
}

func sizeConvert(size: CGFloat) -> CGFloat {
    return (size*ScreenSize.w)/320
}

import UIKit

class TodoItemTableViewCell: UITableViewCell, UITextViewDelegate {
    var beingEditing = false
    @IBOutlet var textView: UITextView!
    var delegate: TodoItemTableViewCellDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    let rightBorder = CALayer()
    let dateButton = UIButton()
    let datePicker = UIDatePicker()
    
    var crossLabel = UIImageView()
    var checkLabel = UIImageView()
    let cueLabelWidth = sizeConvert(size: 26)
    
    var todoItem: TodoItem?
        //for testing purpose
        {
        didSet{
            textView.text = todoItem?.name
        }
    }
    
    var aButton: UIButton?
    var bButton: UIButton?
    var cButton: UIButton?
    var dButton: UIButton?
    
    var originalCenter = CGPoint()
    var originalCrossCenter = CGPoint()
    var originalCheckCenter = CGPoint()
    var deleteOnDragRelease = false
    var completeOnDragRelease = false
    let crossInsetProp = CGFloat(0.92)
    let checkInsetProp = CGFloat(0.06)
    
    let borderWidth = sizeConvert(size: 7)
    let borderInsetY = sizeConvert(size: 5)
    let borderInsetX = sizeConvert(size: 6)
    let separator = CALayer()
    let separatorWidth = sizeConvert(size: 1)
    
    let crossImage = UIImage(named: "img/cross2.png")
    let checkImage = UIImage(named: "img/check2.png")
    
    override func awakeFromNib() {
        
        textView.keyboardAppearance = UIKeyboardAppearance.dark
        
        textView.font = Font.text
        
        let renderedCrossImage = crossImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        crossLabel.image = renderedCrossImage
        crossLabel.tintColor = Color.crossLabel
        
        let renderedCheckImage = checkImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        checkLabel.image = renderedCheckImage
        checkLabel.tintColor = Color.text
        
        checkLabel.frame = CGRect(x: checkInsetProp*UIScreen.main.bounds.width, y: frame.height/2-cueLabelWidth/2, width: cueLabelWidth, height: cueLabelWidth)
        
        crossLabel.frame = CGRect(x: crossInsetProp*UIScreen.main.bounds.width-cueLabelWidth, y: frame.height/2-cueLabelWidth/2, width: cueLabelWidth, height: cueLabelWidth)
        
        addSubview(checkLabel)
        addSubview(crossLabel)
        sendSubview(toBack: crossLabel)
        sendSubview(toBack: checkLabel)
        self.contentView.backgroundColor = Color.cellBackground
        self.textView.backgroundColor = Color.cellBackground
        backgroundColor = Color.cellBackground
        
        //        textView.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 50)
        textView.textContainerInset = UIEdgeInsetsMake(sizeConvert(size: 26), sizeConvert(size: 2), sizeConvert(size: 15), sizeConvert(size: 10))
    
        rightBorder.cornerRadius = sizeConvert(size: 3.0)
        separator.backgroundColor = Color.separator.cgColor
        layer.addSublayer(rightBorder)
        layer.addSublayer(separator)
        //        textView.layer.addSublayer(separator)
        
        
        // BUG HERE: todoItem is not initialized here! WHY
        //        if let todoFlag = todoItem?.flag{
        //                switch todoFlag {
        //                case String(labelTag.Red.rawValue) :
        //                    rightBorder.backgroundColor = UIColor.red.cgColor
        //                case String(labelTag.Orange.rawValue):
        //                    rightBorder.backgroundColor = UIColor.orange.cgColor
        //                case String(labelTag.Cyan.rawValue):
        //                    rightBorder.backgroundColor = UIColor.cyan.cgColor
        //                case String(labelTag.Green.rawValue):
        //                    rightBorder.backgroundColor = UIColor.green.cgColor
        //                default:
        //                    print("Right border not displayed !!!!")
        //                    break
        //            }
        //        }
        //        self.backgroundColor = UIColor.lightGray
        //        textView.backgroundColor = UIColor.lightGray
        
        dateButton.frame = CGRect(x: sizeConvert(size: 5.5), y: sizeConvert(size: 4), width: sizeConvert(size: 100), height: sizeConvert(size: 20))
        dateButton.contentHorizontalAlignment = .left
        dateButton.setTitle("Add Due Date", for: UIControlState.normal)
        dateButton.setTitleColor(Color.dateButton, for: UIControlState.normal)
        dateButton.titleLabel!.font = Font.dateButton
        dateButton.addTarget(self, action: #selector(self.popDatepicker), for: UIControlEvents.touchUpInside)
        dateButton.isHidden = true
        
        
        textView.addSubview(dateButton)
        
        let labelRadius = 5.0
        let labelWidth = sizeConvert(size: 18)
        let labelPosY = sizeConvert(size: 6)
        let labelPosX = sizeConvert(size: 195)
        let distance = sizeConvert(size: 28)
        
        aButton = UIButton(frame: CGRect(x: labelPosX, y: labelPosY, width: labelWidth, height: labelWidth))
        aButton!.backgroundColor = UIColor.red
        aButton!.layer.masksToBounds = true
        aButton!.layer.cornerRadius = CGFloat(labelRadius)
        
        bButton = UIButton(frame: CGRect(x: labelPosX+distance, y: labelPosY, width: labelWidth, height: labelWidth))
        bButton!.backgroundColor = UIColor.orange
        bButton!.layer.cornerRadius = CGFloat(labelRadius)
        bButton!.layer.masksToBounds = true
        
        cButton = UIButton(frame: CGRect(x: labelPosX+2*distance, y: labelPosY, width: labelWidth, height: labelWidth))
        cButton!.backgroundColor = UIColor.cyan
        cButton!.layer.masksToBounds = true
        cButton!.layer.cornerRadius = CGFloat(labelRadius)
        
        dButton = UIButton(frame: CGRect(x: labelPosX+3*distance, y: labelPosY, width: labelWidth, height: labelWidth))
        dButton!.backgroundColor = UIColor.green
        dButton!.layer.masksToBounds = true
        dButton!.layer.cornerRadius = CGFloat(labelRadius)
        
        textView.addSubview(aButton!)
        textView.addSubview(bButton!)
        textView.addSubview(cButton!)
        textView.addSubview(dButton!)
        
        aButton!.tag = labelTag.Red.rawValue
        bButton!.tag = labelTag.Orange.rawValue
        cButton!.tag = labelTag.Cyan.rawValue
        dButton!.tag = labelTag.Green.rawValue
        
        aButton!.addTarget(self, action: #selector(self.setFlag(sender:)), for: UIControlEvents.touchUpInside)
        aButton!.isUserInteractionEnabled = true
        
        bButton!.addTarget(self, action: #selector(self.setFlag(sender:)), for: UIControlEvents.touchUpInside)
        bButton!.isUserInteractionEnabled = true
        
        cButton!.addTarget(self, action: #selector(self.setFlag(sender:)), for: UIControlEvents.touchUpInside)
        cButton!.isUserInteractionEnabled = true
        
        dButton!.addTarget(self, action: #selector(self.setFlag(sender:)), for: UIControlEvents.touchUpInside)
        dButton!.isUserInteractionEnabled = true
        
        
        hideLabels()
        
        textView.returnKeyType = UIReturnKeyType.done
        textView.delegate = self
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        panRecognizer.delegate = self
        addGestureRecognizer(panRecognizer)
        
    }
    
    func popDatepicker(){
        delegate!.popupDatePicker(editingCell: self)
    }
    
    func setFlag(sender: UIButton){
        if(todoItem!.flag == String(sender.tag)){
            todoItem!.flag = "-1"
        }
        else{
            todoItem!.flag = String(sender.tag)
        }
        
        delegate!.cellFlagDidChange(editingCell: self)
        print(sender.tag)
    }
    
    
    func handlePan(recognizer: UIPanGestureRecognizer){
        let maxTransation = frame.size.width/4.0
        // 1
        if recognizer.state == .began {
            // when the gesture begins, record the current center location
            originalCenter = center
            originalCrossCenter = crossLabel.center
            originalCheckCenter = checkLabel.center
        }
        
        // 2
        if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            if maxTransation <= -translation.x{
                center = CGPoint(x: originalCenter.x - maxTransation, y: originalCenter.y)
                crossLabel.center = CGPoint(x: originalCrossCenter.x + maxTransation, y: originalCrossCenter.y)
                checkLabel.center = CGPoint(x: originalCheckCenter.x + maxTransation, y: originalCheckCenter.y)
                crossLabel.tintColor = UIColor.red
            }
            else if translation.x >= maxTransation{
                center = CGPoint(x: originalCenter.x + maxTransation, y: originalCenter.y)
                crossLabel.center = CGPoint(x: originalCrossCenter.x - maxTransation, y: originalCrossCenter.y)
                checkLabel.center = CGPoint(x: originalCheckCenter.x - maxTransation, y: originalCheckCenter.y)
                checkLabel.tintColor = UIColor.green
            }
            else{
                crossLabel.tintColor = Color.crossLabel
                checkLabel.tintColor = Color.crossLabel
                center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
                crossLabel.center = CGPoint(x: originalCrossCenter.x - translation.x, y: originalCrossCenter.y)
                checkLabel.center = CGPoint(x: originalCheckCenter.x - translation.x, y: originalCheckCenter.y)
            }
            deleteOnDragRelease = (frame.origin.x <= -maxTransation)
            completeOnDragRelease = (frame.origin.x >= maxTransation)

            
        }
        
        // 3
        if recognizer.state == .ended {
            crossLabel.tintColor = Color.crossLabel
            checkLabel.tintColor = Color.crossLabel
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            
            if deleteOnDragRelease {
                if delegate != nil && todoItem != nil {
                    // notify the delegate that this item should be deleted
                    delegate!.itemDeleted(item: self.todoItem!)
                }
            }
            else if completeOnDragRelease {
                UIView.animate(withDuration: 0.5, animations: {
                    self.frame = originalFrame
                    self.crossLabel.center = self.originalCrossCenter
                    self.checkLabel.center = self.originalCheckCenter
                }
                    
                )
                delegate?.itemComplete(editingCell: self)
                
            }
            else {
                // if the item is not being deleted, snap back to the original location
                UIView.animate(withDuration: 0.2, animations:
                    {
                        self.frame = originalFrame
                        self.crossLabel.center = self.originalCrossCenter
                        self.checkLabel.center = self.originalCheckCenter
                })
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if beingEditing {
           return false
        }
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
            
            delegate?.cellHeightDidChange(editingCell: self, heightChange: calcHeight - startHeight)
        }
    }
    
    //
    override func layoutSubviews() {
        rightBorder.frame = CGRect(x: screenSize.width-borderWidth-borderInsetX, y: borderInsetY, width: borderWidth, height: frame.height - 2*borderInsetY)
        crossLabel.frame = CGRect(x: crossInsetProp*UIScreen.main.bounds.width-cueLabelWidth, y: frame.height/2-cueLabelWidth/2, width: cueLabelWidth, height: cueLabelWidth)
        separator.frame = CGRect(x: 0, y: frame.height-separatorWidth, width: UIScreen.main.bounds.width, height: separatorWidth)
                checkLabel.frame = CGRect(x: checkInsetProp*UIScreen.main.bounds.width, y: frame.height/2-cueLabelWidth/2, width: cueLabelWidth, height: cueLabelWidth)
    }
    
    // prevent appending new line.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return !(todoItem?.isComplete)!
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        beingEditing = true
        print("current flag: ", todoItem?.flag ?? "nil")
        UIView.animate(withDuration: 0.5, animations: {() in
            self.unhideLabels()
        })
        
        delegate!.cellDidBeginEditing(editingCell: self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        beingEditing = false
        self.hideLabels()
        todoItem!.name = textView.text!
        delegate!.cellDidEndEditing(editingCell: self)
    }
    
    private func hideLabels(){
        UIView.transition(with: self.bButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.bButton!.isHidden = true
        }, completion: nil)
        UIView.transition(with: self.cButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.cButton!.isHidden = true
        }, completion: nil)
        UIView.transition(with: self.aButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.aButton!.isHidden = true
        }, completion: nil)
        UIView.transition(with: self.dButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.dButton!.isHidden = true
        }, completion: nil)
    }
    
    private func unhideLabels(){
        
        UIView.transition(with: self.bButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.bButton!.isHidden = false
        }, completion: nil)
        UIView.transition(with: self.cButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.cButton!.isHidden = false
        }, completion: nil)
        UIView.transition(with: self.aButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.aButton!.isHidden = false
        }, completion: nil)
        UIView.transition(with: self.dButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.dButton!.isHidden = false
        }, completion: nil)
    }
}


