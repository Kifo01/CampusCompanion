//
//  CampusAnnouncement.swift
//  CampusCompanion
//
//  Created by Virgil on 10/3/26.
//

import Foundation

struct CampusAnnouncement {
    let title: String
    let date: String
    let category: String
    let priority: String
    let postedBy: String
}

extension CampusAnnouncement {
    static let sampleAnnouncements: [CampusAnnouncement] = [
        CampusAnnouncement(title: "Enrollment Period Extended",
                            date: "August 3, 2026",
                            category: "Registrar",
                            priority: "Normal",
                            postedBy: "Office of the University Registrar"),
        CampusAnnouncement(title: "Library Hours Extended",
                            date: "August 5, 2026",
                            category: "Library",
                            priority: "Normal",
                            postedBy: "University Library"),
        CampusAnnouncement(title: "Campus Fair 2026",
                            date: "August 10, 2026",
                            category: "Student Affairs",
                            priority: "Normal",
                            postedBy: "Office of Student Affairs"),
        CampusAnnouncement(title: "Student Council Elections",
                            date: "August 15, 2026",
                            category: "Student Council",
                            priority: "Normal",
                            postedBy: "Student Council"),
        CampusAnnouncement(title: "Scholarship Application Deadline",
                            date: "August 20, 2026",
                            category: "Financial Aid",
                            priority: "Urgent",
                            postedBy: "Financial Aid Office"),
        CampusAnnouncement(title: "IT Services Maintenance",
                            date: "August 25, 2026",
                            category: "IT Services",
                            priority: "Urgent",
                            postedBy: "IT Services")
    ]
}
