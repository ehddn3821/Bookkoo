//
//  SearchViewController.swift
//  Bookkoo
//
//  Created by dwKang on 2021/03/28.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast

class SearchViewController: UIViewController {

    @IBOutlet var bookSearchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    
    var bookArray:[APIResponse.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookSearchBar.delegate = self

//        searchTableView.delegate = self
//        searchTableView.dataSource = self
    }
    
    func CallAPI() {
        let headers: HTTPHeaders = [
            "Authorization": APIKey.apiKey
        ]
        
        let query = bookSearchBar.text ?? ""
        
        // 검색어 없을 경우 토스트 메시지 띄우기
        if query != "" {
            let url = "https://dapi.kakao.com/v3/search/book?query=\(query)"
            
            let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!  // 한글 인코딩
            AF.request(encodedUrl, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let res):
                    do {
                        // 반환값을 Data 타입으로 변환
                        let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                        // Data를 [Item] 타입으로 디코딩 후 bookArray에 변환한 값을 대입
                        let json = try JSONDecoder().decode(APIResponse.self, from: jsonData)
                        self.bookArray = json.documents
                        print(self.bookArray)
                        
                    } catch (let err) {
                        print(err.localizedDescription)
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            
        } else {
            self.view.makeToast("검색어를 입력해주세요.", duration: 1.0, position: .center)
        }
    }
}

// MARK: - APIResponse
struct APIResponse: Codable {
    
    let documents: [Item]
    
    struct Item: Codable {
        let authors: [String] // 저자
        let title: String // 제목
        let contents: String // 내용 설명
        let thumbnail: String // 표지
        let publisher: String // 출판사
        let datetime: String // 등록일
        let translators: [String]? // 역자
    }
}



// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        CallAPI()
    }
}

// MARK: - UITableViewDelegate, DataSource
//extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return bookArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//}
