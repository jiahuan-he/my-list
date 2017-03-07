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
            
//        self.contentView.addSubview(textView)
//        self.contentView.addSubview(expandedView)        
    
    override func awakeFromNib() {
        
        expandedView.isHidden = true
        setDueView.isHidden = true
        
        textView.returnKeyType = UIReturnKeyType.done
        
        adjustHeightConstrant()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tapRecognizer.delegate = self
        
        textView.addGestureRecognizer(tapRecognizer)
        textView.delegate = self
        
//        print(stackViewHeightConstraint.constant)
//        print("awake from nib")
//        print(stackViewHeightConstraint.constant," = ",textView.sizeThatFits(textView.frame.size).height,"+", expandedViewHeight)
        
    }
    
    func handleTap(sender: UITapGestureRecognizer){
        expandedView.isHidden = !expandedView.isHidden
        setDueView.isHidden = !setDueView.isHidden
        
        adjustHeightConstrant()
        
        print(stackViewHeightConstraint.constant," = ",textView.sizeThatFits(textView.frame.size).height,"+", expandedViewHeight)
        
        delegate!.cellHeightDidChange(cell: self)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        adjustHeightConstrant()
        delegate!.cellHeightDidChange(cell: self)

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            adjustHeightConstrant()
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
    }

}

    
    
    
    

