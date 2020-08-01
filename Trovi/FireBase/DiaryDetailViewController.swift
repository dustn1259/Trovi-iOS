//
//  DiaryDetailViewController.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 10/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import Kingfisher

class DiaryDetailViewController:UIViewController {
    //전 화면에서 넘겨받을 데이터
    var diary_data:Diary?


    @IBOutlet weak var titles: UILabel!
    
    @IBOutlet weak var detailUserName: UILabel!
    @IBOutlet weak var detailmeetDate: UILabel!
    @IBOutlet weak var detailcountNum: UILabel!
    @IBOutlet weak var detailstandardNum: UILabel!
    @IBOutlet weak var detailContent: UILabel!
    @IBOutlet weak var detailMeetArea: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    
    @IBOutlet weak var hashtag: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
       // content_field.text = diary_data?.content
        self.title = diary_data?.title
 
        setContent()
    }
    
    func setContent() {
          guard let data = self.diary_data else {return}
          debugPrint(data)
        self.detailUserName.text = data.uid
        let date = NSDate(timeIntervalSince1970: data.date!) as Date
        let date_formatter_d = DateFormatter()
        date_formatter_d.dateFormat = "yyyy-MM-dd"
        let time_formatter_d = DateFormatter()
        time_formatter_d.dateFormat = "a hh:mm"
        self.detailmeetDate.text = date_formatter_d.string(from: date)
        self.time.text = time_formatter_d.string(from: date)
        //Image
        if let image_url_string = data.image_url, let image_url = URL(string: image_url_string) {
            
            let url = URL(string: image_url_string)
            let processor = DownsamplingImageProcessor(size: detailImageView.frame.size)
                |> RoundCornerImageProcessor(cornerRadius: 20)
            detailImageView.kf.indicatorType = .activity
            detailImageView.kf.setImage(
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
                  guard let image = self.detailImageView.image else {return}
                    let ratio = image.size.width / image.size.height
//                    self.imageViewHeight.constant = self.imageView.frame.width / ratio
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        } else {
            self.detailImageView.isHidden = true
        }
        self.detailContent.text = data.content
        self.detailstandardNum.text = data.count
        self.hashtag.text = data.hashtag
        self.titles.text = data.title
        self.detailMeetArea.text = data.meetArea
        
    }
    

    
    @IBAction func leftBtn(_ sender: Any) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "searchView") as! SearchViewController
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
}
