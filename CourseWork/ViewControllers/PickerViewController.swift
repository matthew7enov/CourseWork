//
//  PickerViewController.swift
//  CourseWork
//
//  Created by Matvei Semenov on 15/12/2022.
//

import UIKit

class PickerViewController: UIViewController {

    var values: [String] = [] {
        didSet {
            guard isViewLoaded else { return }
            pickerView.reloadAllComponents()
        }
    }
    var didSelectAction: ((Int) -> Void)?
    var selectedRow: Int = 0

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!

    @IBAction func didPressCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func didPressDoneButton(_ sender: Any) {
        didSelectAction?(selectedRow)
        dismiss(animated: true)
    }

}

extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}

extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
}
