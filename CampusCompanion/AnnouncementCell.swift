import UIKit

class AnnouncementCell: UITableViewCell {

    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    func configure(with announcement: CampusAnnouncement) {
        let isUrgent = announcement.priority == "Urgent"

        titleLabel.text = announcement.title
        dateLabel.text = "\(announcement.category) • \(announcement.date)\n\(announcement.location) • Priority: \(announcement.priority)"
        dateLabel.numberOfLines = 2
        categoryIconImageView.image = UIImage(
            systemName: isUrgent ? "exclamationmark.triangle.fill" : "megaphone.fill"
        )

        categoryIconImageView.tintColor = isUrgent ? .systemRed : .systemBlue
        titleLabel.textColor = isUrgent ? .systemRed : .label
        dateLabel.textColor = .secondaryLabel
        contentView.backgroundColor = isUrgent
            ? UIColor.systemRed.withAlphaComponent(0.08)
            : .clear
    }
}
