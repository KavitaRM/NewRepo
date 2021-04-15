//
//  CustomPicker.swift
//  AssignmentIOS
//
//  Created by User on 14/04/21.
//

import Foundation
import UIKit

protocol CustomPickerDelegate {
    func customPicker(_ pickerView: CustomPicker!, didSelect value: String?)
    func data(in pickerView: CustomPicker) -> [String]?
    func seletedValue(in pickerView: CustomPicker) -> String?
}

class CustomPicker: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pickerTableView: UITableView!

    let rowHeight: CGFloat = 44.0

    var delegate: CustomPickerDelegate?
    var data: [String]? {
        didSet {
            pickerTableView.reloadData()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        addContentView()
    }

    // MARK: - Init Content View
    private func addContentView() {
        Bundle.main.loadNibNamed("CustomPicker", owner: self, options: nil)
        addSubview(contentView)

        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = .clear

        pickerTableView.register(UINib(nibName: "CustomPickerCell", bundle: nil), forCellReuseIdentifier: "customPickerCellID")
    }

    private func getSelectedIndexPath(_ text: String?) -> IndexPath {
        guard let text = text else { return IndexPath(row: 0, section: 0) }

        guard let index = data?.firstIndex(of: text) else { return IndexPath(row: 0, section: 0) }

        return IndexPath(row: index, section: 0)
    }

    func setData() {
        /// Update Picker Data
        data = delegate?.data(in: self)

        pickerTableView.scrollToRow(at: getSelectedIndexPath(delegate?.seletedValue(in: self)), at: .top, animated: true)
    }
}

// MARK: - TableView Delegate / DataSource
extension CustomPicker: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customPickerCellID", for: indexPath) as? CustomPickerCell else { return UITableViewCell() }

        cell.filterLabel.text = data?[indexPath.item]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        delegate?.customPicker(self, didSelect: data?[indexPath.item])
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let value = targetContentOffset.pointee.y / rowHeight
        let roundedVal = value.rounded()
        targetContentOffset.pointee.y = roundedVal * rowHeight
    }
}
