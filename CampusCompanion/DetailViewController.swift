//
//  DetailViewController.swift
//  CampusCompanion
//
//  Created by Virgil on 9/19/26.
//
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!

    var studentName: String = ""
    var notificationsEnabled: Bool = false
    var selectedRole: String = ""
    var preferredEventDate: Date = Date()
    var numberOfGuests: Int = 1
    var announcement: CampusAnnouncement?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let announcement {
            title = announcement.category
            messageLabel.text = """
            \(announcement.title)

            Category: \(announcement.category)
            Date: \(announcement.date)
            Location: \(announcement.location)
            Priority: \(announcement.priority)
            Posted by: \(announcement.postedBy)
            """
            return
        }

        title = "Campus Events"
        let notificationStatus = notificationsEnabled ? "on" : "off"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        messageLabel.text = """
        Welcome, \(studentName)! (\(selectedRole))
        Notifications: \(notificationStatus).
        Preferred event date: \(dateFormatter.string(from: preferredEventDate)).
        Guests: \(numberOfGuests).
        """
    }
}
