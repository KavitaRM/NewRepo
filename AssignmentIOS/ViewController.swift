//
//  ViewController.swift
//  AssignmentIOS
//
//  Created by User on 14/04/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
        
    /// Refresh Control
    private let refreshControl = UIRefreshControl()
            
    var viewModel = ViewcontrollerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        getList()
        mainTableView.reloadData()
    }
    
    func getList() {
        loader.startAnimating()

        viewModel.fetchPeopleList(successCallback: {
            DispatchQueue.main.async { [self] in
                self.mainTableView.reloadData()
                loader.stopAnimating()
                print("\(viewModel.dataModel?.next)")
            }
        }, failureCallback: {
            self.loader.stopAnimating()
        })
    }
    
    func getNextList() {
        viewModel.fetchNextList(successCallback: { [weak self] in
            DispatchQueue.main.async { [self] in
                self?.mainTableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }, failureCallback: { [weak self] in
            DispatchQueue.main.async { [self] in
            self?.refreshControl.endRefreshing()
            }
        })
    }
    
    // MARK: - Refresh Control Method
    @objc private func refreshMasterCollectionData(_: Any) {
        getNextList()
    }

    
    func configureUI() {
        title = "Records"
        mainTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier:"cell1")
        mainTableView.separatorStyle = .none
        
        /// Init Refreah Control
        mainTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshMasterCollectionData(_:)), for: .valueChanged)
    
    }

    @IBAction func FilterAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let filterView = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController else { return }
        
        let defaultFilterModel = FilterDataModel(collections: viewModel.getPersonData(), filterType: nil)
        filterView.viewModel.update(dataModel: viewModel.getFilterModel() ?? defaultFilterModel)

        /// Update Delegate
        filterView.delegate = self

        filterView.modalPresentationStyle = .overCurrentContext

        present(filterView, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
       
        let model = viewModel.getDataForIndex(index: indexPath.row)
        cell.personDataModel = model
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}

extension ViewController: FilterDelegate {
    func applyFilterWith(dataModel: FilterDataModel?) {
        viewModel.setFilter(model: dataModel)

        mainTableView.reloadData()
    }

    func resetFilter() {
        viewModel.setFilter(model: nil)

        mainTableView.reloadData()
    }
}
