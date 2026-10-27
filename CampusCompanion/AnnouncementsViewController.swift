//
//  AnnouncementsViewControllerTableViewController.swift
//  CampusCompanion
//
//  Created by Virgil on 10/3/26.
//

import UIKit
import CoreData

private enum RemoteEndpoint {
    static let announcements = URL(
        string: "https://raw.githubusercontent.com/feu-mad2/" +
        "campus-companion-api/main/announcements.json"
    )!
}

class AnnouncementsViewController: UITableViewController {

    private var announcements: [CampusAnnouncement] = []
    private var selectedAnnouncement: CampusAnnouncement?

    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Announcements"
        seedInitialAnnouncementsIfNeeded()
        loadAnnouncements()
    }

    private func seedInitialAnnouncementsIfNeeded() {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        let existingCount = (try? context.count(for: request)) ?? 0
        guard existingCount == 0 else { return }

        let seedAnnouncements: [(String, String, String, String, String)] = [
            ("Enrollment Period Extended", "August 3, 2026", "Registrar", "Normal", "Office of the University Registrar"),
            ("Library Hours Extended", "August 5, 2026", "Library", "Normal", "University Library"),
            ("Campus Fair 2026", "August 10, 2026", "Student Affairs", "Normal", "Office of Student Affairs"),
            ("Student Council Elections", "August 15, 2026", "Student Council", "Normal", "Student Council"),
            ("Scholarship Application Deadline", "August 20, 2026", "Financial Aid", "Urgent", "Financial Aid Office"),
            ("IT Services Maintenance", "August 25, 2026", "IT Services", "Urgent", "IT Services")
        ]

        for seed in seedAnnouncements {
            let announcement = CampusAnnouncement(context: context)
            announcement.title = seed.0
            announcement.date = seed.1
            announcement.category = seed.2
            announcement.priority = seed.3
            announcement.postedBy = seed.4
            announcement.location = "Unspecified"
        }

        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    private func loadAnnouncements() {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        announcements = (try? context.fetch(request)) ?? []
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "AnnouncementCell",
            for: indexPath
        ) as? AnnouncementCell else {
            return UITableViewCell()
        }

        cell.configure(with: announcements[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedAnnouncement = announcements[indexPath.row]
        performSegue(withIdentifier: "ShowAnnouncementDetailSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowAnnouncementDetailSegue",
              let destination = segue.destination as? DetailViewController,
              let announcement = selectedAnnouncement else {
            return
        }

        destination.announcement = announcement
    }

    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        fetchAnnouncementsFromServer()
    }

    private func fetchAnnouncementsFromServer() {
        let task = URLSession.shared.dataTask(with: RemoteEndpoint.announcements) { data, response, error in
            if let error {
                print("Network error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected server response.")
                return
            }

            guard let data else { return }
            print("Reached network handler with \(data.count) bytes.")
            if let rawJSON = String(data: data, encoding: .utf8) {
                print(rawJSON)
            }

            do {
                let decodedAnnouncements = try JSONDecoder().decode([AnnouncementDTO].self, from: data)
                DispatchQueue.main.async {
                    print("Decoded \(decodedAnnouncements.count) announcements.")
                    self.replaceAnnouncements(with: decodedAnnouncements)
                    self.showNetworkConfirmationAlert(byteCount: data.count)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }

    private func replaceAnnouncements(with dtos: [AnnouncementDTO]) {
        do {
            let existing = try context.fetch(CampusAnnouncement.fetchRequest())
            for announcement in existing {
                context.delete(announcement)
            }

            for dto in dtos {
                let announcement = CampusAnnouncement(context: context)
                announcement.title = dto.title
                announcement.date = dto.date
                announcement.category = dto.category
                announcement.location = dto.location
                announcement.priority = dto.priority
                announcement.postedBy = "Campus Feed"
            }

            try context.save()
            loadAnnouncements()
        } catch {
            context.rollback()
            print("Core Data replacement error: \(error)")
        }
    }

    private func showNetworkConfirmationAlert(byteCount: Int) {
        let alert = UIAlertController(
            title: "Server Reached",
            message: "Received \(byteCount) bytes from the announcements endpoint.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction func addAnnouncementTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "New Announcement",
            message: "Enter a title and category.",
            preferredStyle: .alert
        )
        alert.addTextField { $0.placeholder = "Title" }
        alert.addTextField { $0.placeholder = "Category" }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self,
                  let title = alert?.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !title.isEmpty,
                  let category = alert?.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !category.isEmpty else {
                return
            }

            let announcement = CampusAnnouncement(context: self.context)
            announcement.title = title
            announcement.date = DateFormatter.localizedString(
                from: Date(),
                dateStyle: .long,
                timeStyle: .none
            )
            announcement.category = category
            announcement.priority = "Normal"
            announcement.postedBy = "Student"
            announcement.location = "Unspecified"

            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.loadAnnouncements()
        })
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let announcement = announcements[indexPath.row]
        context.delete(announcement)

        do {
            try context.save()
            announcements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            context.rollback()
            loadAnnouncements()
            assertionFailure("Announcement deletion failed: \(error)")
        }
    }
}
