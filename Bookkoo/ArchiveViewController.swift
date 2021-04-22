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
    var changeValue = 0

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
    
    @IBAction func changeReview(_ sender: UIButton) {
        changeValue = 1
        titleLabel.text = "📝 리뷰를 남긴 책"
        archiveTableView.reloadData()
    }
    @IBAction func changeLike(_ sender: UIButton) {
        changeValue = 0
        titleLabel.text = "📕 찜한 책"
        archiveTableView.reloadData()
    }
}

extension ArchiveViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if changeValue == 0 {
            return likeList.count
        } else {
            return reviewList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
        // 찜한 책
        if changeValue == 0 {
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
        // 남긴 후기
        } else {
            cell.bookAuthor.text = reviewList[indexPath.row].bkAuthors
            cell.bookTitle.text = reviewList[indexPath.row].bkTitle
            
            if reviewList[indexPath.row].bkTranslators != "" {
                cell.translatorLabel.isHidden = false
                cell.bookTranslator.isHidden = false
                cell.bookTranslator.text = reviewList[indexPath.row].bkTranslators
            } else {
                cell.translatorLabel.isHidden = true
                cell.bookTranslator.isHidden = true
            }
            
            let url = URL(string: reviewList[indexPath.row].bkThumbnail)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.bookImage.image = UIImage(data: data!)
                }
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
            
            if changeValue == 0 {
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
            } else {
                if let index = sender as? Int {
                    vc?.imgURL = reviewList[index].bkThumbnail
                    vc?.bookTitle = reviewList[index].bkTitle
                    vc?.bookAuthors = reviewList[index].bkAuthors
                    vc?.bookTranslators = reviewList[index].bkTranslators
                    vc?.bookPublisher = reviewList[index].bkPublisher
                    vc?.bookDatetime = reviewList[index].bkDatetime
                    vc?.bookContents = reviewList[index].bkContents
                    vc?.bookISBN = reviewList[index].bkISBN
                }
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
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}
