//
//  KPGenericWorker.swift
//  koolicarproject
//
//  Created by Stephan Yannick on 29/09/2016.
//  Copyright (c) 2016 koolicar. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import Alamofire

public class KPGenericWorker {
    
    /**
     * Generic method alamofire
     *
     * Permets d'interpréter les codes Http, les codes error dans le JSON du retour du WS pour l'interprèter avec un enumérateur des errors possibles, (Communication, retour WS)
     *
     */
    static func resquest(
        method: Alamofire.HTTPMethod,
        service: WSConfig,
        param: [String:AnyObject]? = nil,
        completion: @escaping ResultAPI) {
        
        Alamofire.request(service.absolutPath, method: method).responseJSON { response in
            guard
                response.result.isSuccess,
                let value = response.result.value as? [String:AnyObject] else {
                    // Exemple pour savoir plus sur l'erreur HTTP
                    // Peut avoir value["coderror"] == nil // exemple insertion d'un utilisateur existant
                    if let httpError = response.result.error,
                        let responseWS = WSResponse(rawValue: httpError._code) {
                        KPDebug.print(val: "[KPGenericWorker][resquest][⚠️] Http Code error: \(response.result.error))")
                        completion(.failure(responseWS))
                    } else {
                        KPDebug.print(val: "[KPGenericWorker][resquest][⚠️] Parse error: \(response.result.error))")
                        completion(.failure(.impossibleToParse))
                    }
                    return
            }
            completion(.success(value))
        }
    }
}
