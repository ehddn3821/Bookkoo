//
//  DetailViewController.swift
//  Bookkoo
//
//  Created by dwKang on 2021/04/09.
//

import UIKit
import SnapKit
import RealmSwift
import Toast

class DetailViewController: UIViewController {
    
    let realm = try! Realm()
    var list: Results<BookModel>!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let bookImage = UIImageView()
    let titleLabel = UILabel()
    let authorsLabel = UILabel()
    let translatorsLabel = UILabel()
    let publisherLabel = UILabel()
    let datetimeLabel = UILabel()
    let contentsLabel = UILabel()
    let likeButton = UIButton()
    let reviewTextField = UITextField()
    let saveButton = UIButton()
    
    var imgURL: String?
    var bookTitle: String?
    var bookAuthors: String?
    var bookTranslators: String?
    var bookPublisher: String?
    var bookDatetime: String?
    var bookContents: String?
    var bookISBN: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BgGray")
        
        // Realm
        list = realm.objects(BookModel.self).filter("bkISBN == '\(bookISBN!)'")

        // 스크롤뷰
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 컨텐트뷰
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
        
        _ = [bookImage, titleLabel, authorsLabel, translatorsLabel, publisherLabel, datetimeLabel, contentsLabel, likeButton, reviewTextField, saveButton].map { self.contentView.addSubview($0) }
        
        // 썸네일
        if let imgURL = self.imgURL {
            let url = URL(string: imgURL)
            if url != nil {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        self.bookImage.image = UIImage(data: data!)
                    }
                }
            }
        }
        bookImage.contentMode = .scaleAspectFit
        bookImage.layer.shadowColor = UIColor.black.cgColor // 색깔
        bookImage.layer.masksToBounds = false  // 그림자는 밖에 그려지는 것이므로 false 로 설정
        bookImage.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        bookImage.layer.shadowRadius = 5 // 반경
        bookImage.layer.shadowOpacity = 0.5 // alpha값
        
        // 제목
        titleLabel.text = bookTitle
        titleLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        titleLabel.numberOfLines = 0
        
        // 저자
        authorsLabel.text = "\(bookAuthors!) 저"
        authorsLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        // 역자
        if bookTranslators != "" {
            translatorsLabel.text = " / \(bookTranslators!) 역"
            translatorsLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
        
        // 출판
        publisherLabel.text = "\(bookPublisher!) 출판"
        publisherLabel.font = UIFont.systemFont(ofSize: 15)
        
        // 등록일
        let format = "yyyy-MM-dd'T'HH:mm:ss.SSS+09:00"
        let bookDate = bookDatetime?.toDateString(inputFormat: format, outputFormat: "yyyy년 MM월 dd일")!
        datetimeLabel.text = bookDate
        datetimeLabel.font = UIFont.systemFont(ofSize: 14)
        
        // 좋아요
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        
        if list.count != 0 {
            if list[0].bkLike == false {    // 좋아요 체크
                likeButton.setImage(UIImage(systemName: "heart", withConfiguration: largeConfig), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: largeConfig), for: .normal)
            }
        } else {
            likeButton.setImage(UIImage(systemName: "heart", withConfiguration: largeConfig), for: .normal)
        }
        likeButton.tintColor = .systemPink
        
        // 좋아요 버튼 클릭 시
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        // 내용
        contentsLabel.text = bookContents
        contentsLabel.font = UIFont.systemFont(ofSize: 17)
        contentsLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: contentsLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentsLabel.attributedText = attrString
        
        // 리뷰쓰기
        reviewTextField.placeholder = "리뷰를 작성해주세요."
        reviewTextField.borderStyle = .roundedRect
        
        if list.count != 0 && list[0].bkReview != nil {
            reviewTextField.text = list[0].bkReview
        }
        
        // 리뷰 저장 버튼
        saveButton.setTitle("리뷰 저장", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        saveButton.backgroundColor = .systemPink
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        
        // 저장 버튼 클릭 시
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        
        
        // MARK: - 레이아웃
        // 썸네일
        bookImage.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.leading.centerX.equalToSuperview()
            let screenWidth = UIScreen.main.bounds.width
            make.width.equalTo(screenWidth / 2)
        }
        
        // 제목
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bookImage.snp.bottom).offset(100)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        // 저자
        authorsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(20)
        }
        
        // 역자
        translatorsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(authorsLabel.snp.top)
            make.leading.equalTo(authorsLabel.snp.trailing)
            make.trailing.equalTo(-20)
        }
        
        // 출판
        publisherLabel.snp.makeConstraints { (make) in
            make.top.equalTo(authorsLabel.snp.bottom).offset(20)
            make.leading.equalTo(20)
        }
        
        // 등록일
        datetimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(publisherLabel.snp.bottom).offset(8)
            make.leading.equalTo(20)
        }
        
        // 좋아요
        likeButton.snp.makeConstraints { (make) in
            make.top.equalTo(publisherLabel.snp.top)
            make.trailing.equalTo(-20)
            make.width.height.equalTo(50)
        }
        
        // 내용
        contentsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(datetimeLabel.snp.bottom).offset(30)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        // 리뷰쓰기
        reviewTextField.snp.makeConstraints { (make) in
            make.top.equalTo(contentsLabel.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(120)
        }
        
        // 리뷰 저장 버튼
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(reviewTextField.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
    }
    
    // 좋아요 버튼 클릭 시
    @objc func likeButtonClicked() {
        
        // 렘안에 없을 때
        if list.count == 0 {
            
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: largeConfig), for: .normal)
            
            let likeBook = BookModel(value: [
                "id": BookModel().autoIncrementId(),
                "bkTitle": bookTitle!,
                "bkAuthors": bookAuthors!,
                "bkTranslators": bookTranslators ?? "",
                "bkPublisher": bookPublisher!,
                "bkContents": bookContents!,
                "bkThumbnail": imgURL!,
                "bkDatetime": bookDatetime!,
                "bkLike": true,
                "bkISBN": bookISBN!
            ])
            
            try! realm.write {
                realm.add(likeBook)
            }
            
        // 렘 안에 이미 있을 때
        } else {
            if list[0].bkLike == true {
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
                likeButton.setImage(UIImage(systemName: "heart", withConfiguration: largeConfig), for: .normal)
                
                try! realm.write {
                    list[0].bkLike = false
                }
            } else {
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
                likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: largeConfig), for: .normal)
                
                try! realm.write {
                    list[0].bkLike = true
                }
            }
        }
    }
    
    // 저장 버튼 클릭 시
    @objc func saveButtonClicked() {
        
        if reviewTextField.text != "" {
        
            // 선택한 책에 대해 첫 리뷰일 시
            if list.count == 0 {
                
                let likeBook = BookModel(value: [
                    "id": BookModel().autoIncrementId(),
                    "bkTitle": bookTitle!,
                    "bkAuthors": bookAuthors!,
                    "bkTranslators": bookTranslators ?? "",
                    "bkPublisher": bookPublisher!,
                    "bkContents": bookContents!,
                    "bkThumbnail": imgURL!,
                    "bkDatetime": bookDatetime!,
                    "bkISBN": bookISBN!,
                    "bkReview": reviewTextField.text!
                ])
                
                try! realm.write {
                    realm.add(likeBook)
                }
                
                self.view.makeToast("리뷰 저장이 완료되었습니다.", duration: 1.0, position: .center)
                
            // 리뷰 수정
            } else {
                try! realm.write {
                    list[0].bkReview = reviewTextField.text
                }
                
                self.view.makeToast("리뷰 저장이 완료되었습니다.", duration: 1.0, position: .center)
            }
        } else {
            self.view.makeToast("리뷰를 입력해주세요.", duration: 1.0, position: .center)
        }
    }
}

// String -> Date -> String
extension DateFormatter {
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (inputFormat: String, outputFormat:String) -> String? {
        if let date = toDate(format: inputFormat) {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
}
