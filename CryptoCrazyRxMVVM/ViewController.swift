//
//  ViewController.swift
//  CryptoCrazyRxMVVM
//
//  Created by Beyza Nur Tekerek on 27.09.2024.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableview: UITableView!
    
    let cryptoVM = CryptoViewModel()
    var cryptoList = [Crypto]()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

//        tableview.delegate = self
//        tableview.dataSource = self
        
        
        tableview.rx.setDelegate(self).disposed(by: disposeBag)
        setupBindings()
        cryptoVM.requestData()
        
    }
    
    
    private func setupBindings() {
        
        cryptoVM
            .loading
            .bind(to: self.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { errorString in
                print(errorString)
            }
            .disposed(by: disposeBag)
        
//        cryptoVM
//            .cryptos
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe { cryptos in
//                self.cryptoList = cryptos
//                self.tableview.reloadData()
//            }
//            .disposed(by: disposeBag)
        
        
        cryptoVM
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableview.rx.items(cellIdentifier: "CryptoCell", cellType: CryptoTableViewCell.self)) { row, item, cell in
                cell.item = item
            }
            .disposed(by: disposeBag)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cryptoList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        var content = cell.defaultContentConfiguration()
//        content.text = cryptoList[indexPath.row].currency
//        content.secondaryText = cryptoList[indexPath.row].price
//        cell.contentConfiguration = content
//        return cell
//    }
    
}

