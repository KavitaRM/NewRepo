//
//  FilterViewModel.swift
//  AssignmentIOS
//
//  Created by User on 14/04/21.
//

import Foundation

// MARK: - Filter Sort Delegate
protocol FilterDelegate {
    func applyFilterWith(dataModel: FilterDataModel?)
    func resetFilter()
}

// MARK: Enum for Filter/Sort type
enum FilterType: String {
    case eyeColor = "EyeColor"
    case gender = "Gender"
    case hairColor = "HairColor"
}

class FilterViewModel {
    let filterOptions = ["EyeColor", "Gender","HairColor","",""]
    var filterSpecificOptions = [""]
    var isSpecificTypeAvailable = false

    var apiData: [Person]?

    var dataModel: FilterDataModel?
    
    let genderFilter = "Gender"
    let eyeColorFilter = "EyeColor"
    let hairColorFilter = "Hair Color"

    var filterType: String? {
        return dataModel?.filterType
    }

    var filterSpecificType: String? {
        return dataModel?.filterSpecificType
    }


    /// Update Data Model
    func update(dataModel: FilterDataModel) {
        self.dataModel = dataModel
        self.apiData = dataModel.collections

        if let filterType = dataModel.filterType {
            updateFilterSpecificOptions(key: filterType)
        }
    }

    func resetDataModel() {
        dataModel?.filterType = nil
        dataModel?.filterSpecificType = nil
        filterSpecificOptions.removeAll()
        isSpecificTypeAvailable = false
    }

    func getDataModel() -> FilterDataModel? {
        dataModel?.collections = apiData

        return dataModel
    }

    /// Update List with Filtered/Sorted Data
    func updateList(with dataModel: FilterDataModel?, callBack: () -> ()) {
        self.dataModel = dataModel
        self.apiData = dataModel?.collections

        self.updateFilteredList {
            callBack()
        }
    }

    /// Update List with Filter Data
    private func updateFilteredList(callBack: () -> ()) {
        guard let type = filterType, let filterType = FilterType(rawValue: type) else {
            callBack()
            return
        }

        switch filterType {
        case .eyeColor:
            guard let filterSpecificType = filterSpecificType, filterSpecificType != "" else {
                callBack()
                return
            }

            self.configFilterSpecificType { callBack() }
            
        case .gender:
            guard let filterSpecificType = filterSpecificType, filterSpecificType != "" else {
                callBack()
                return
            }

            self.configFilterSpecificType { callBack() }
        case .hairColor:
            guard let filterSpecificType = filterSpecificType, filterSpecificType != "" else {
                callBack()
                return
            }

            self.configFilterSpecificType { callBack() }
        }
    }

    // Configure Filter Stecific Type
    private func configFilterSpecificType(callBack: () -> ()) {
        guard let filterType = filterType else {
            callBack()
            return
        }

        switch filterType {
        case eyeColorFilter:
            filterSpecificByEyeColor { callBack() }
        case genderFilter:
            filterSpecificByGender { callBack() }
        case hairColorFilter:
            filterSpecificByHairColor { callBack() }
        default:
            // Do nothing
            break
        }
    }

    // MARK: - Filter methods
    func filterByEyeColor(callBack: () -> ()) {
        apiData = apiData?.filter {
            $0.eyeColor != nil && $0.eyeColor != ""
        }

        // Callback after filter
        callBack()
    }

    func filterByGender(callBack: () -> ()) {
        apiData = apiData?.filter {
            $0.gender != nil && $0.gender != ""
        }

        // Callback after filter
        callBack()
    }

    func filterByHairColor(callBack: () -> ()) {
        apiData = apiData?.filter {
            $0.hairColor != nil && $0.hairColor != ""
        }

        // Callback after filter
        callBack()
    }


    // MARK: - Filter Specific methods
    func filterSpecificByGender(callBack: () -> ()) {
        guard let filterSpecificType = filterSpecificType else {
            callBack()
            return
        }

        apiData = apiData?.filter {
            if let genderValue = $0.gender?.lowercased() {
                return genderValue.contains(filterSpecificType.lowercased())
            }
            return false
        }

        // Callback after filter
        callBack()
    }

    func filterSpecificByEyeColor(callBack: () -> ()) {
        guard let filterSpecificType = filterSpecificType else {
            callBack()
            return
        }

        apiData = apiData?.filter {
            if let eyeColorValue = $0.eyeColor {
                return eyeColorValue.contains(filterSpecificType.lowercased())
            }
            return false
        }

        // Callback after filter
        callBack()
    }

    func filterSpecificByHairColor(callBack: () -> ()) {
        guard let filterSpecificType = filterSpecificType else {
            callBack()
            return
        }

        apiData = apiData?.filter {
            if let hairColorValue = $0.hairColor?.lowercased() {
                return hairColorValue.contains(filterSpecificType.lowercased())
            }
            return false
        }

        // Callback after filter
        callBack()
    }

    
}

// MARK: - Update Filter Specific Data
extension FilterViewModel {
    func updateFilterSpecificOptions(key: String) {

        switch key {
        case genderFilter:
            filterSpecificOptions = apiData?.map { $0.gender ?? "" } ?? []
        case eyeColorFilter:
            filterSpecificOptions = apiData?.map { $0.eyeColor ?? ""  } ?? []
        case hairColorFilter:
            filterSpecificOptions = apiData?.map { $0.hairColor ?? ""  } ?? []
        default:
            // Do nothing
            break
        }

        filterSpecificOptions = Set(filterSpecificOptions.filter { $0 != "" }.map { $0.capitalized }).sorted()


        if filterSpecificOptions.count > 0 {
            isSpecificTypeAvailable = true
        } else {
            isSpecificTypeAvailable = false
        }
    }

    func update(filterType: String?) {
        dataModel?.filterType = filterType
        dataModel?.filterSpecificType = nil
    }

    func update(filterSpecificType: String?) {
        dataModel?.filterSpecificType = filterSpecificType
    }


}
