//
//  ViewController.swift
//  Bookkoo
//
//  Created by dwKang on 2021/03/28.
//

import UIKit
import RealmSwift

class ArchiveViewController: UIViewController {
    
    let realm = try! Realm()
    var reviewList: Results<BookModel>!
    var likeList: Results<BookModel>!

    @IBOutlet var archiveTableView: UITableView!
    @IBOutlet var reviewCountLabel: UILabel!
    @IBOutlet var likeCountLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.layer.addBorder([.top], color: .black, width: 0.5)
        
        archiveTableView.delegate = self
        archiveTableView.dataSource = self
        
        let nibName = UINib(nibName: "SearchTableViewCell", bundle: nil)
        archiveTableView.register(nibName, forCellReuseIdentifier: "SearchTableViewCell")
        
        // 용도에 맞게 리스트로 추출
        likeList = realm.objects(BookModel.self).filter("bkLike == true")
        reviewList = realm.objects(BookModel.self).filter("bkReview != nil")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 리뷰 작성한 책 수
        reviewCountLabel.text = "\(reviewList.count)"
        
        // 찜한 책 수
        likeCountLabel.text = "\(likeList.count)"
        
        archiveTableView.reloadData()
    }
}

extension ArchiveViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        cell.bookAuthor.text = likeList[indexPath.row].bkAuthors
        
        cell.bookTitle.text = likeList[indexPath.row].bkTitle
        
        if likeList[indexPath.row].bkTranslators != "" {
            cell.translatorLabel.isHidden = false
            cell.bookTranslator.isHidden = false
            cell.bookTranslator.text = likeList[indexPath.row].bkTranslators
        } else {
            cell.translatorLabel.isHidden = true
            cell.bookTranslator.isHidden = true
        }
        
        let url = URL(string: likeList[indexPath.row].bkThumbnail)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.bookImage.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 선택 해제하기
        tableView.deselectRow(at: indexPath, animated: false)
        
        // 선택한 indexPath.row 넘기기
        performSegue(withIdentifier: "goDetail1", sender: indexPath.row)
    }
    
    // 세그가 작동하기전에 먼저 실행
    // 선택한 셀 데이터 넘겨주기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail1" {
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int {
                vc?.imgURL = likeList[index].bkThumbnail
                vc?.bookTitle = likeList[index].bkTitle
                vc?.bookAuthors = likeList[index].bkAuthors
                vc?.bookTranslators = likeList[index].bkTranslators
                vc?.bookPublisher = likeList[index].bkPublisher
                vc?.bookDatetime = likeList[index].bkDatetime
                vc?.bookContents = likeList[index].bkContents
                vc?.bookISBN = likeList[index].bkISBN
            }
        }
    }
}

// 테두리 원하는 방향만
extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
