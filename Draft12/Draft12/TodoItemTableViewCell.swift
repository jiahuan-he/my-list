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
    let cueLabelWidth = CGFloat(26)
    
    
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
    var originalCrossCenter = CGPoint()
    var originalCheckCenter = CGPoint()
    var deleteOnDragRelease = false
    var completeOnDragRelease = false
    let crossInsetProp = CGFloat(0.92)
    let checkInsetProp = CGFloat(0.06)
    
    let borderWidth = CGFloat(7)
    let borderInsetY = CGFloat(5)
    let borderInsetX = CGFloat(6)
    let separator = CALayer()
    let separatorWidth = CGFloat(1)
    
    let crossImage = UIImage(named: "img/cross2.png")
    let checkImage = UIImage(named: "img/check2.png")
    
    override func awakeFromNib() {
        //        if FileManager.default.fileExists(atPath: "img/crossMark.png") {
        //            let url = NSURL(string: "img/crossMark.png")
        //            let data = NSData(contentsOf: url! as URL)
        //            crossLabel.image = UIImage(data: data! as Data)
        //        }
        
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
        self.contentView.backgroundColor = UIColor.white
        self.textView.backgroundColor = Color.cellBackground
        backgroundColor = Color.cellBackground
        
        //        textView.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 50)
        textView.textContainerInset = UIEdgeInsetsMake(24, 2, 15, 10)
        
        
        
        rightBorder.cornerRadius = 3.0
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
        
        dateButton.frame = CGRect(x: 5.5, y: 4, width: 100, height: 20)
        dateButton.contentHorizontalAlignment = .left
        dateButton.setTitleColor(Color.dateButton, for: UIControlState.normal)
        dateButton.titleLabel!.font = Font.dateButton
        dateButton.addTarget(self, action: #selector(self.popDatepicker), for: UIControlEvents.touchUpInside)
        dateButton.isHidden = true
        
        textView.addSubview(dateButton)
        
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
        
        redButton!.addTarget(self, action: #selector(self.setFlag(sender:)), for: UIControlEvents.touchUpInside)
        redButton!.isUserInteractionEnabled = true
        
        orangeButton!.addTarget(self, action: #selector(self.setFlag(sender:)), for: UIControlEvents.touchUpInside)
        orangeButton!.isUserInteractionEnabled = true
        
        cyanButton!.addTarget(self, action: #selector(self.setFlag(sender:)), for: UIControlEvents.touchUpInside)
        cyanButton!.isUserInteractionEnabled = true
        
        greenButton!.addTarget(self, action: #selector(self.setFlag(sender:)), for: UIControlEvents.touchUpInside)
        greenButton!.isUserInteractionEnabled = true
        
        
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
        UIView.transition(with: self.orangeButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.orangeButton!.isHidden = true
        }, completion: nil)
        UIView.transition(with: self.cyanButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.cyanButton!.isHidden = true
        }, completion: nil)
        UIView.transition(with: self.redButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.redButton!.isHidden = true
        }, completion: nil)
        UIView.transition(with: self.greenButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.greenButton!.isHidden = true
        }, completion: nil)
    }
    
    private func unhideLabels(){
        
        UIView.transition(with: self.orangeButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.orangeButton!.isHidden = false
        }, completion: nil)
        UIView.transition(with: self.cyanButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.cyanButton!.isHidden = false
        }, completion: nil)
        UIView.transition(with: self.redButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.redButton!.isHidden = false
        }, completion: nil)
        UIView.transition(with: self.greenButton!, duration: 0.2, options: .transitionCrossDissolve, animations: { _ in
            self.greenButton!.isHidden = false
        }, completion: nil)
    }
}


