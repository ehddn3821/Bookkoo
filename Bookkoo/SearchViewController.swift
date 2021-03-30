//
//  SearchViewController.swift
//  Bookkoo
//
//  Created by dwKang on 2021/03/28.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController {

    @IBOutlet var searchTableView: UITableView!
    
    var bookSearchBar: UISearchBar = UISearchBar()
    var bookArray: [APIResponse.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 서치바 구현
        let searchController = UISearchController(searchResultsController: nil)
        bookSearchBar = searchController.searchBar
        bookSearchBar.placeholder = "책 제목이나 저자를 검색해주세요."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false  // 스크롤해도 서치바 유지
        searchController.obscuresBackgroundDuringPresentation = false  // 검색중에도 테이블뷰 사용가능하게
        
        searchController.searchBar.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        let nibName = UINib(nibName: "SearchTableViewCell", bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: "SearchTableViewCell")
        
        // 테이블뷰셀에 컨텐츠 내용에 따라 동적 높이 할당
        searchTableView.estimatedRowHeight = 140
        searchTableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - API 호출
    func CallAPI() {
        let headers: HTTPHeaders = [
            "Authorization": APIKey.apiKey
        ]
        
        let query = bookSearchBar.text ?? ""
        
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
                    
                    // 테이블뷰 리로드
                    self.searchTableView.reloadData()
                    
                } catch (let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
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
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDelegate, DataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        cell.bookTitle.text = bookArray[indexPath.row].title
        
        return cell
    }
}
