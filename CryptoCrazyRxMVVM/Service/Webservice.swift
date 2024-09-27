//
//  Webservise.swift
//  CryptoCrazyRxMVVM
//
//  Created by Beyza Nur Tekerek on 27.09.2024.
//

import Foundation

enum CryptoError: Error {
    
    case serverError
    case parsingError
    
}

class Webservice {
    
    func downloadCurrency(url: URL, completion: @escaping (Result<[Crypto], CryptoError>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                
                completion(.failure(.serverError))
                
            } else if let data = data {
                
                let cryptoList = try? JSONDecoder().decode([Crypto].self, from: data)
                if let cryptoList = cryptoList {
                    
                    completion(.success(cryptoList))
                     
                } else {
                    
                    completion(.failure(.parsingError))
                    
                }
                
            }
            
        } .resume()
        
    }
    
    
}
