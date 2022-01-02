
//  ChatRoomTableViewCell.swift
//  catchBullying
//
//  Created by apple on 26/05/1443 AH.


import UIKit

class ChatRoomTableViewCell: UITableViewCell {

  @IBOutlet weak var avatarImagwOutLet: UIImageView!
  @IBOutlet weak var usernameLabelOutlet: UILabel!
  @IBOutlet weak var lastMessageLabelOutlet: UILabel!
  @IBOutlet weak var dateMessageLabelOutlet: UILabel!
  @IBOutlet weak var unreadCounterLabelOutlet: UILabel!
  @IBOutlet weak var unreadCounterViewOutlet: UIView!


  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    unreadCounterViewOutlet.layer.cornerRadius = unreadCounterViewOutlet.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  func configure (chatRoom:ChatRoom) {
    usernameLabelOutlet.text = chatRoom.receiverName
    usernameLabelOutlet.minimumScaleFactor = 0.9
    lastMessageLabelOutlet.text = chatRoom.lastMessage
    lastMessageLabelOutlet.numberOfLines = 2
    usernameLabelOutlet.minimumScaleFactor = 0.9
    
//    dateMessageLabelOutlet.text = timeElapsed(timeElapsed.data ?? Date())
    if chatRoom.unreadCounter != 0 {
      self.unreadCounterLabelOutlet.text = "\(chatRoom.unreadCounter)"
      self.unreadCounterViewOutlet.isHidden = false
  } else {
      self.unreadCounterViewOutlet.isHidden = true

    }


    

  func timeElapsed ( date : Date ) -> String {
    let seconds = Date () .timeIntervalSince(date)
    var elapsed = ""
    
    if seconds < 60 {
      elapsed = "Just now "
    }
    
    else if seconds < 60 * 60 {
    let minutes = Int(seconds/60)
    let minText = minutes > 1 ? "mins" : "min"
     elapsed = "\(minutes) \(minText) "
      
    }
    else if seconds < 24 * 60 * 60 {
      let hours = Int(seconds / (60 * 60))
      let hourText = hours > 1 ? "hours" : "hours"
      elapsed = "\(hours) \(hourText)"
      
    }
    
    else {
      elapsed = "\(date)"
      
      
    }
    
  return elapsed
    
    }
  
  }
  
}
  
  

extension Date {

  func lognDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM yyyy"
    return dateFormatter.string(from: self)
  }

}
