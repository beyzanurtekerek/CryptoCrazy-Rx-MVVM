//
//  CryptoViewModel.swift
//  CryptoCrazyRxMVVM
//
//  Created by Beyza Nur Tekerek on 28.09.2024.
//

import Foundation
import RxSwift
import RxCocoa

class CryptoViewModel {
    
    let cryptos : PublishSubject<[Crypto]> = PublishSubject()
    let error : PublishSubject<Error> = PublishSubject()
    let loading : PublishSubject<Bool> = PublishSubject()
    
    func requestData() {
        
        self.loading.onNext(true)
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/refs/heads/master/crypto.json")!
        Webservice().downloadCurrency(url: url) { cryptoResult in
            self.loading.onNext(false)
            switch cryptoResult {
            case .success(let cryptos):
                self.cryptos.onNext(cryptos)
            case .failure(let error):
                switch error {
                case .parsingError:
                    self.error.onNext("parsing error" as! Error)
                case .serverError:
                    self.error.onNext("server error" as! Error)
                }
            }
        }

        
    }
    
}
