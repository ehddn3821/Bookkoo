//
//  DetailViewController.swift
//  Bookkoo
//
//  Created by dwKang on 2021/04/09.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let bookImage = UIImageView()
    let titleLabel = UILabel()
    let authorsLabel = UILabel()
    let translatorsLabel = UILabel()
    let publisherLabel = UILabel()
    let datetimeLabel = UILabel()
    let contentsLabel = UILabel()
    
    var imgURL: String?
    var bookTitle: String?
    var bookAuthors: [String]?
    var bookTranslators: [String]?
    var bookPublisher: String?
    var bookDatetime: String?
    var bookContents: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BgGray")

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
        
        _ = [bookImage, titleLabel, authorsLabel, translatorsLabel, publisherLabel, datetimeLabel, contentsLabel].map { self.contentView.addSubview($0) }
        
        // 썸네일
        if let imgURL = self.imgURL {
            let url = URL(string: imgURL)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.bookImage.image = UIImage(data: data!)
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.numberOfLines = 0
        
        // 저자
        let authors = bookAuthors?.joined(separator: ", ")
        authorsLabel.text = "\(authors!) 저"
        authorsLabel.font = UIFont.systemFont(ofSize: 15)
        
        // 역자
        let translators = bookTranslators?.joined(separator: ", ")
        if translators != "" {
            translatorsLabel.text = " / \(translators!) 역"
            translatorsLabel.font = UIFont.systemFont(ofSize: 15)
        }
        
        // 출판
        publisherLabel.text = "\(bookPublisher!) 출판"
        publisherLabel.font = UIFont.systemFont(ofSize: 13)
        
        // 등록일
        let format = "yyyy-MM-dd'T'HH:mm:ss.SSS+09:00"
        let bookDate = bookDatetime?.toDateString(inputFormat: format, outputFormat: "yyyy년 MM월 dd일")!
        datetimeLabel.text = bookDate
        datetimeLabel.font = UIFont.systemFont(ofSize: 12)
        
        // 내용
        contentsLabel.text = bookContents
        contentsLabel.font = UIFont.systemFont(ofSize: 14)
        contentsLabel.numberOfLines = 0
        
        
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
            make.trailing.equalTo(-20)
        }
        
        // 등록일
        datetimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(publisherLabel.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        // 내용
        contentsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(datetimeLabel.snp.bottom).offset(30)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalToSuperview()
        }
    }
}

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

extension Date {
    func toString (format:String) -> String? {
        return DateFormatter(format: format).string(from: self)
    }
}
