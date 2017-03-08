//
//  TodoItemTableViewCell.swift
//  Draft11
//
//  Created by LMAO on 27/02/2017.
//  Copyright © 2017 Jiahuan He. All rights reserved.
//
protocol TodoItemTableViewCellDelegate{
    func cellHeightDidChange(cell: TodoItemTableViewCell)
}


import UIKit

class TodoItemTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var expandedView: UIView!
    @IBOutlet weak var setDueView: UIView!
    
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    var expandedViewHeight: CGFloat{
        get{
            if expandedView.isHidden{
                return 0
            }
            else{
                return CGFloat(28)
            }
        }
    }
    
    var setDueViewHeight: CGFloat{
        get{
            if setDueView.isHidden{
                return 0
            }
            else{
                return CGFloat(28)
            }
        }
    }
    
    
    
    var delegate: TodoItemTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let toobar = toolbarView(frame: CGRect(x: 0, y:0 , width: screenSize.width, height: 30))
        
        let redButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        redButton.setTitle("red", for: .normal)
//        
//        let yellowButton = UIButton(frame: CGRect(x: 30, y: 0, width: 30, height: 30))
//        redButton.setTitle("yellow", for: .normal)
//        
//        let greenButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        redButton.setTitle("green", for: .normal)
        
        
        toobar.addSubview(redButton)
//        toobar.addSubview(yellowButton)
//        toobar.addSubview(greenButton)
        
        
        
        toobar.backgroundColor = UIColor.brown
        
        
        
        expandedView.isHidden = true
        setDueView.isHidden = true
        
        textView.returnKeyType = UIReturnKeyType.done
        
        stackViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height + expandedViewHeight + setDueViewHeight
        textView.delegate = self
        
        textView.inputAccessoryView = toobar
        
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        adjustHeightConstrant()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            
            if !expandedView.isHidden {
                expandedView.isHidden = true
            }
            if !setDueView.isHidden {
                setDueView.isHidden = true
            }
            adjustHeightConstrant()
            
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    private func adjustHeightConstrant(){
        stackViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height + expandedViewHeight + setDueViewHeight
        delegate!.cellHeightDidChange(cell: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        expandedView.isHidden = !expandedView.isHidden
        setDueView.isHidden = !setDueView.isHidden
        
        adjustHeightConstrant()
        
        print(stackViewHeightConstraint.constant," = ",textView.sizeThatFits(textView.frame.size).height,"+", expandedViewHeight)
    }
    

}

    
    
    
    

