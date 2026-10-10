//
//  ViewController.swift
//  CampusCompanion
//
//  Created by Virgil on 9/12/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var notifySwitch: UISwitch!

    @IBOutlet weak var roleSegmentedControl: UISegmentedControl!

    @IBOutlet weak var eventDatePicker: UIDatePicker!

    @IBOutlet weak var guestStepper: UIStepper!

    @IBOutlet weak var guestCountLabel: UILabel!

    @IBAction func getStartedTapped(_ sender: UIButton) {
        subtitleLabel.text = "Let's get started!"
    }


    @IBAction func exploreButtonTapped(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        performSegue(withIdentifier: "ShowDetailSegue", sender: self)
    }

    @IBAction func guestStepperChanged(_ sender: UIStepper) {
        guestCountLabel.text = "Guests: \(Int(sender.value))"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guestCountLabel.text = "Guests: \(Int(guestStepper.value))"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowDetailSegue",
              let destination = segue.destination as? DetailViewController else {
            return
        }

        let enteredName = nameTextField.text ?? ""
        destination.studentName = enteredName.isEmpty ? "Student" : enteredName
        destination.notificationsEnabled = notifySwitch.isOn
        destination.selectedRole = roleSegmentedControl.selectedSegmentIndex == 0 ? "Student" : "Faculty"
        destination.preferredEventDate = eventDatePicker.date
        destination.numberOfGuests = Int(guestStepper.value)
    }

}
