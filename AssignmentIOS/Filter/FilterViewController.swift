//
//  FilterViewController.swift
//  AssignmentIOS
//
//  Created by User on 14/04/21.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var filterByButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var filterSpecificButton: UIButton!

    @IBOutlet weak var filterByPicker: CustomPicker!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterSpecificPicker: CustomPicker!

    var delegate: FilterDelegate?
    var viewModel = FilterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme()

        updateFeilds()
        updatePickers()
        updateResetButton()
        updateApplyButton()
        enableSpecificTypeView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 1.5, animations: { [weak self] in
            self?.view.backgroundColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.5)
        })

    }
}

// MARK: - Apply Theme
extension FilterViewController {
    private func applyTheme() {
        filterByButton.setTitleColor(UIColor(red: 14.0 / 255, green: 9.0 / 255, blue: 21 / 255, alpha: 1), for: .normal)
        filterByButton.backgroundColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.0)

        filterSpecificButton.setTitleColor(UIColor(red: 14.0 / 255, green: 9.0 / 255, blue: 21 / 255, alpha: 1), for: .normal)
        filterSpecificButton.backgroundColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.0)

        cancelButton.setTitleColor(UIColor(red: 0 / 255, green: 117 / 255, blue: 168 / 255, alpha: 1), for: .normal)
        cancelButton.backgroundColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.0)

        resetButton.setTitleColor(UIColor(red: 0 / 255, green: 117 / 255, blue: 168 / 255, alpha: 1), for: .normal)
        resetButton.backgroundColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.0)

        applyButton.setTitleColor(UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1), for: .normal)
        applyButton.backgroundColor = UIColor(red: 0 / 255, green: 117 / 255, blue: 168 / 255, alpha: 1)
    }
}

// MARK: - Update
extension FilterViewController {
    private func updateFeilds() {
        filterByButton.setTitle(viewModel.filterType, for: .normal)
        filterSpecificButton.setTitle(viewModel.filterSpecificType, for: .normal)
    }

    private func updatePickers() {
        filterByPicker.delegate = self
        filterSpecificPicker.delegate = self
    }

    private func updateResetButton() {
        let state = viewModel.filterType != nil

        resetButton.isUserInteractionEnabled = state
        resetButton.alpha = state ? 1.0 : 0.5
    }

    private func updateApplyButton() {
        let state = viewModel.filterType != nil

        applyButton.isUserInteractionEnabled = state
        applyButton.alpha = state ? 1.0 : 0.5
    }

    private func enableSpecificTypeView() {
        blurView.isHidden = viewModel.isSpecificTypeAvailable
    }

}

// MARK: - Button Actions
extension FilterViewController {
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        viewModel.resetDataModel()
        updateResetButton()
        updateApplyButton()
        updateFeilds()

        delegate?.resetFilter()

        /// Hide  Picker
        filterByPicker.isHidden = true
        filterSpecificPicker.isHidden = true
        blurView.isHidden = false

    }

    @IBAction func applyButtonTapped(_ sender: UIButton) {
        viewModel.updateList(with: viewModel.dataModel) {
            self.delegate?.applyFilterWith(dataModel: viewModel.getDataModel())

            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Filter Button Actions
extension FilterViewController {
    @IBAction func filterByTapped(_ sender: UIButton) {
        filterByPicker.isHidden = false
        filterSpecificPicker.isHidden = true
        filterByPicker.setData()
    }

    @IBAction func filterSpecificTapped(_ sender: UIButton) {
        filterSpecificPicker.isHidden = false
        filterByPicker.isHidden = true
        filterSpecificPicker.setData()
    }
}

// MARK: - Custom Picker Delegate
extension FilterViewController: CustomPickerDelegate {
    func seletedValue(in pickerView: CustomPicker) -> String? {
        switch pickerView {
        case filterByPicker:
            return viewModel.filterType
        case filterSpecificPicker:
            return viewModel.filterSpecificType
        default:
            return ""
        }
    }

    func data(in pickerView: CustomPicker) -> [String]? {
        switch pickerView {
        case filterByPicker:
            return viewModel.filterOptions
        case filterSpecificPicker:
            return viewModel.filterSpecificOptions
        default:
            return viewModel.filterOptions
        }
    }

    func customPicker(_ pickerView: CustomPicker!, didSelect value: String?) {
        switch pickerView {
        case filterByPicker:
            viewModel.updateFilterSpecificOptions(key: value ?? "")
            viewModel.update(filterType: value)

            updateFeilds()
            filterByPicker.isHidden = true
            updateResetButton()
            updateApplyButton()
            enableSpecificTypeView()

        case filterSpecificPicker:
            viewModel.update(filterSpecificType: value)

            updateFeilds()
            filterSpecificPicker.isHidden = true
        default:
            break
        }
    }
}
