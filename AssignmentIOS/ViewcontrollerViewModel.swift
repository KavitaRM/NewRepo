//
//  ViewcontrollerViewModel.swift
//  AssignmentIOS
//
//  Created by User on 14/04/21.
//

import Foundation

protocol ViewModelProtocol {
    func setFilter(model: FilterDataModel?)
    func getFilterModel() -> FilterDataModel?
}

class ViewcontrollerViewModel {
    
    var dataModel: DataModel?
    var result: [Person]?
    var initialData = [Person]()
    private var filterDataModel: FilterDataModel?
     
    func cellCount() -> Int {
        print(self.dataModel?.results)
        return self.initialData.count
//        return self.dataModel?.results?.count ?? 0
//        return self.result?.count ?? 0
    }

    func getDataForIndex(index: Int) -> Person {
        return self.initialData[index]
//        return (self.dataModel?.results?[index])!
    }
    
    func getPersonData() -> [Person]? {
        return dataModel?.results
    }
    
    func fetchPeopleList(successCallback : @escaping () -> Void, failureCallback: @escaping () -> Void) {
        NetworkManager.shared.getListOfPeople {[weak self] (response, errorString) -> Void in
            guard let weakSelf = self else { return }
            if let response = response {
                weakSelf.dataModel = response
                weakSelf.initialData = weakSelf.dataModel?.results ?? []
                successCallback()
            } else {
                failureCallback()
            }
        }
    }
    
    func fetchNextList(successCallback : @escaping () -> Void, failureCallback: @escaping () -> Void) {
        NetworkManager.shared.getNextList(urlStr: "\(dataModel?.next ?? "")") {[weak self] (response, errorString) -> Void in
            guard let weakSelf = self else { return }
            if let response = response {
                weakSelf.dataModel = response
                if let data = weakSelf.dataModel?.results {
                    weakSelf.initialData.append(contentsOf: data)
                }
                successCallback()
            } else {
                failureCallback()
            }
        }
    }
    
    func fetchPreviousList(successCallback : @escaping () -> Void, failureCallback: @escaping () -> Void) {
        NetworkManager.shared.getPreviousList {[weak self] (response, errorString) -> Void in
            guard let weakSelf = self else { return }
            if let response = response {
                weakSelf.dataModel = response
                successCallback()
            } else {
                failureCallback()
            }
        }
    }
    
}


// MARK: Collection View Model Protocol
extension ViewcontrollerViewModel: ViewModelProtocol {
    func setFilter(model: FilterDataModel?) {
        self.filterDataModel = model
    }

    func getFilterModel() -> FilterDataModel? {
        var model = self.filterDataModel
        /// Filter will always apply on all Collections
        model?.collections = getPersonData()

        return model
    }
}
