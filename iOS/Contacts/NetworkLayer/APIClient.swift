//
//  APIClient.swift
//
//  Created by Sushant Alone on 04/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//


import Foundation
import Alamofire
class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(route:URLRequestConvertible, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (AFResult<T>)->Void) -> DataRequest {
        return AF.request(route).validate(statusCode: 200..<410)
            .responseDecodable (decoder: decoder){ (response: AFDataResponse<T>) in
                switch response.result {
                case .success(_):
                    print("Response is successful : \(response.result)")
                case .failure(let error):
                    print(error)
                }
                completion(response.result)
        }
    }
    
    static func getContactList(with completion:@escaping (AFResult<ListModel>)->Void){
        do{
            let contactRouter = try ContactRouter.list.asURLRequest()
            performRequest(route: contactRouter, completion:completion )
        }
        catch (let error){
            print(error)
        }
    }
    
    static func addContact(_ contact : ContactList, with completion:@escaping (AFResult<SuccessModel>)->Void){
        do{
            let contactRouter = try ContactRouter.add(email: contact.email_id ?? "", name: contact.name ?? "", code: contact.country_code ?? "", phnNumber: contact.phone_number ?? "").asURLRequest()
            performRequest(route: contactRouter, completion:completion )
        }
        catch (let error){
            print(error)
        }
    }
    
    static func updateContact(_ contact : ContactList, with completion:@escaping (AFResult<SuccessModel>)->Void){
        do{
            let contactRouter = try ContactRouter.update(id: contact.id!, email: contact.email_id ?? "", name: contact.name ?? "", code: contact.country_code ?? "", phnNumber: contact.phone_number ?? "").asURLRequest()
            performRequest(route: contactRouter, completion:completion )
        }
        catch (let error){
            print(error)
        }
    }
}


