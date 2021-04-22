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
    
    private var isFilterModelAvailable: Bool {
        if let _ = filterDataModel { return true }

        return false
    }
     
    func cellCount() -> Int {
        print(self.dataModel?.results)
        
        if let filterDataModel = filterDataModel {
            return filterDataModel.collections?.count ?? 0
        }
        
        return self.initialData.count
    }

    func getDataForIndex(index: Int) -> Person {
        if let filterDataModel = filterDataModel {
            if let collection = filterDataModel.collections?[index] {
                return collection
            }
            
        }
        
        return self.initialData[index]
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
                    weakSelf.initialData.insert(contentsOf: data, at: 0)
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


extension ViewcontrollerViewModel: ViewModelProtocol {
    func setFilter(model: FilterDataModel?) {
        self.filterDataModel = model
    }

    func getFilterModel() -> FilterDataModel? {
        var model = self.filterDataModel
        
        model?.collections = getPersonData()

        return model
    }
}
