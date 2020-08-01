//
//  DiaryDetailViewController.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 10/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import Kingfisher

class troviDetailView:UIViewController {

    
    //전 화면에서 넘겨받을 데이터
    var diary_data_trovi:Diary?

  
    @IBOutlet weak var userNameTrovi: UILabel!
    @IBOutlet weak var wirteDayTrovi: UILabel!
    @IBOutlet weak var meetDayTrovi: UILabel!
    @IBOutlet weak var peopleNumTrovi: UILabel!
    @IBOutlet weak var standardNumTrovi: UILabel!
    @IBOutlet weak var contentTrovi: UILabel!
    @IBOutlet weak var locationTrovi: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var imageTrovi: UIImageView!
    @IBOutlet weak var titleTrovi: UILabel!
    @IBOutlet weak var hashtag: UILabel!
    @IBOutlet weak var time: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // content_field.text = diary_data?.content
        self.title = diary_data_trovi?.title
        setContent()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backAction))
        
    }

    
    @objc func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }

       
        
        func setContent() {
              guard let data = self.diary_data_trovi else {return}
              debugPrint(data)
            self.userNameTrovi.text = data.uid
            let date = NSDate(timeIntervalSince1970: data.date!) as Date
            let date_formatter = DateFormatter()
            date_formatter.dateFormat = "yyyy-MM-dd"
            let time_formatter = DateFormatter()
            time_formatter.dateFormat = "a hh:mm"
            self.meetDayTrovi.text = date_formatter.string(from: date)
            self.time.text = time_formatter.string(from: date)
            //Image
            if let image_url_string = data.image_url, let image_url = URL(string: image_url_string) {
                
                let url = URL(string: image_url_string)
                let processor = DownsamplingImageProcessor(size: imageTrovi.frame.size)
                    |> RoundCornerImageProcessor(cornerRadius: 20)
                imageTrovi.kf.indicatorType = .activity
                imageTrovi.kf.setImage(
                    with: url,
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
                {
                    result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
    //                    self.imageViewHeight.constant = 700.0
                      guard let image = self.imageTrovi.image else {return}
                        let ratio = image.size.width / image.size.height
    //                    self.imageViewHeight.constant = self.imageView.frame.width / ratio
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
            } else {
                self.imageTrovi.isHidden = true
            }
            self.titleTrovi.text = data.title
            self.contentTrovi.text = data.content
            self.standardNumTrovi.text = data.count
            self.locationTrovi.text = data.meetArea
            self.hashtag.text = data.hashtag
    }
}


