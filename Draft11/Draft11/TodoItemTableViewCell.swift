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
    
//    var expanded = false
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var expandedView: UIView!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    var expandedViewHeight: CGFloat{
        get{
            if expandedView.isHidden{
                return 0
            }
            else{
                return CGFloat(101)
            }
        }
    }
    
    
    
    var delegate: TodoItemTableViewCellDelegate?
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        
        
//        self.contentView.addSubview(textView)
//        self.contentView.addSubview(expandedView)        
    
    override func awakeFromNib() {
        
        expandedView.isHidden = true
        stackViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height + expandedViewHeight
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tapRecognizer.delegate = self
        
        textView.addGestureRecognizer(tapRecognizer)
        textView.delegate = self
        
        
        
//        expanded = true
        print(stackViewHeightConstraint.constant)
        print("awake from nib")
    }
    
    func handleTap(sender: UITapGestureRecognizer){
        expandedView.isHidden = !expandedView.isHidden
        
        stackViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height + expandedViewHeight
        
        print(stackViewHeightConstraint.constant," = ",textView.sizeThatFits(textView.frame.size).height,"+", expandedViewHeight)
        delegate!.cellHeightDidChange(cell: self)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        stackViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height + expandedViewHeight
        
        
        delegate!.cellHeightDidChange(cell: self)
//        layoutIfNeeded()
    }
    
    
    

        
}

    
    
    
    

