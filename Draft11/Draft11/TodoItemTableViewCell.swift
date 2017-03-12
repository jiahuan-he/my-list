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
    
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    var delegate: TodoItemTableViewCellDelegate?
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func awakeFromNib() {
        textView.textContainerInset = UIEdgeInsetsMake(30, 2, 10, 0)
        
        
        let rightBorder = CALayer()
        rightBorder.frame = CGRect(x: screenSize.width-6, y: 0, width: 6, height: textView.frame.height)
        rightBorder.backgroundColor = UIColor.red.cgColor
        textView.layer.addSublayer(rightBorder)
        
//        let divider  = CALayer()
//        divider.frame = CGRect(x: screenSize.width-66, y: 0, width: 3, height: textView.frame.height)
//        divider.backgroundColor = UIColor.gray.cgColor
//        textView.layer.addSublayer(divider)
        
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
        
        
        
        
        
        let toobar = toolbarView(frame: CGRect(x: 0, y:0 , width: screenSize.width, height: 30))
        
        let dueLabel = UILabel(frame: CGRect(x: screenSize.width/2+50, y: 0, width: 60, height: 30))
        dueLabel.text = "Due"
        
        let redButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        redButton.setTitle("red", for: .normal)
        
        redButton.addTarget(self, action: #selector(self.didPressRedButton(sender:)), for: .touchUpInside)
        
        let yellowButton = UIButton(frame: CGRect(x: 50, y: 0, width: 60, height: 30))
        yellowButton.setTitle("yellow", for: .normal)
        yellowButton.addTarget(self, action: #selector(self.didPressRedButton(sender:)), for: .touchUpInside)

//        let greenButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        greenButton.setTitle("green", for: .normal)
        
        
        toobar.addSubview(redButton)
        toobar.addSubview(yellowButton)
        toobar.addSubview(dueLabel)
//        toobar.addSubview(greenButton)
        
        
        
        toobar.backgroundColor = UIColor.brown
        
        
        

        
        textView.returnKeyType = UIReturnKeyType.done
        
        stackViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height
        textView.delegate = self
        
        textView.inputAccessoryView = toobar
        
        
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
    
    private func adjustHeightConstrant(){
        stackViewHeightConstraint.constant = textView.sizeThatFits(textView.frame.size).height
        delegate!.cellHeightDidChange(cell: self)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        adjustHeightConstrant()
        
    }
    

}

    
    
    
    

