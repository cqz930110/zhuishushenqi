//
//  QSTopicDetailInteractor.swift
//  zhuishushenqi
//
//  Created caonongyun on 2017/4/20.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import QSNetwork

class QSTopicDetailInteractor: QSTopicDetailInteractorProtocol {

    var output: QSTopicDetailInteractorOutputProtocol?
    var id:String = ""
    var title:String = "主题书单"

    func requestDetail(){
        //        http://api.zhuishushenqi.com/book-list/58b782f5a7674a5f67618731
        let api = QSAPI.themeDetail(key: id)
        //        QSNetwork.setDefaultURL(url: BASEURL)
        QSNetwork.request(api.path, method: HTTPMethodType.get, parameters: nil, headers: nil) { (response) in
            QSLog(response.json)
            if let bookList = response.json?.object(forKey: "bookList") as? [AnyHashable : Any], let books = (response.json?.object(forKey: "bookList") as AnyObject).object(forKey:"books"){
                do{
                    let headerModel = TopicDetailHeader.model(with: bookList)
                    let booksModel =  try XYCBaseModel.model(withModleClass: TopicDetailModel.self, withJsArray:books as! [AnyObject]) as? [TopicDetailModel]
                    if let header = headerModel,let books = booksModel {
                        self.output?.fetchListSuccess(list: books, header: header)
                    }else{
                        self.output?.fetchListFailed()
                    }
                }catch{
                    self.output?.fetchListFailed()
                    QSLog(error)
                }
            }else{
                self.output?.fetchListFailed()
            }
        }
    }
    
    func showTitle(){
        self.output?.showTitle(title: title)
    }
}