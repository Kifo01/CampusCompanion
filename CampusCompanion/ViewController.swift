//
//  ViewController.swift
//  CampusCompanion
//
//  Created by Virgil on 9/12/26.
//

import UIKit

private enum DefaultsKey {
    static let studentName = "studentName"
    static let notificationsEnabled = "notificationsEnabled"
    static let selectedRoleIndex = "selectedRoleIndex"
}

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

        let enteredName = nameTextField.text ?? ""
        UserDefaults.standard.set(enteredName, forKey: DefaultsKey.studentName)
        UserDefaults.standard.set(notifySwitch.isOn, forKey: DefaultsKey.notificationsEnabled)
        UserDefaults.standard.set(roleSegmentedControl.selectedSegmentIndex,
                                  forKey: DefaultsKey.selectedRoleIndex)

        performSegue(withIdentifier: "ShowDetailSegue", sender: self)
    }

    @IBAction func resetPreferencesTapped(_ sender: UIBarButtonItem) {
        UserDefaults.standard.removeObject(forKey: DefaultsKey.studentName)
        UserDefaults.standard.removeObject(forKey: DefaultsKey.notificationsEnabled)
        UserDefaults.standard.removeObject(forKey: DefaultsKey.selectedRoleIndex)

        nameTextField.text = ""
        notifySwitch.isOn = false
        roleSegmentedControl.selectedSegmentIndex = 0
    }

    @IBAction func guestStepperChanged(_ sender: UIStepper) {
        guestCountLabel.text = "Guests: \(Int(sender.value))"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = UserDefaults.standard.string(forKey: DefaultsKey.studentName) ?? ""
        notifySwitch.isOn = UserDefaults.standard.bool(forKey: DefaultsKey.notificationsEnabled)
        roleSegmentedControl.selectedSegmentIndex =
            UserDefaults.standard.integer(forKey: DefaultsKey.selectedRoleIndex)
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
