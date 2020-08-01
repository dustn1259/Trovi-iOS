

import UIKit
import Kingfisher

class ProfileDetailView:UIViewController{
    
    //전 화면에서 넘겨받을 데이터
    var profile_data:Diary?
    
    

    @IBOutlet weak var meetDay: UILabel!
    @IBOutlet weak var countPeople: UILabel!
    @IBOutlet weak var standardNum: UILabel!
    @IBOutlet weak var contentField: UILabel!
    @IBOutlet weak var meetArea: UILabel!
    @IBOutlet weak var imageView_p: UIImageView!
    @IBOutlet weak var Profiletitle: UILabel!
    @IBOutlet weak var hashtag: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    override func viewDidLoad() {
        self.title = profile_data?.title
        setContent()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backAction))
    }
    
    
    @objc func backAction(){
        //print("Back Button Clicked")
        self.navigationController?.navigationBack(sender: self)
    }

       
        
        func setContent() {
            guard let data = self.profile_data else {return}
              debugPrint(data)
            
            let date = NSDate(timeIntervalSince1970: data.date!) as Date
            let date_formatter_p = DateFormatter()
            date_formatter_p.dateFormat = "yyyy-MM-dd"
            let time_formatter_p = DateFormatter()
            date_formatter_p.dateFormat = "hh:mm a"
            self.time.text = time_formatter_p.string(from: date)
            //Image
            if let image_url_string = data.image_url, let image_url = URL(string: image_url_string) {
                
                let url = URL(string: image_url_string)
                let processor = DownsamplingImageProcessor(size: imageView_p.frame.size)
                    |> RoundCornerImageProcessor(cornerRadius: 20)
                imageView_p.kf.indicatorType = .activity
                imageView_p.kf.setImage(
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
                      guard let image = self.imageView_p.image else {return}
                        let ratio = image.size.width / image.size.height
    //                    self.imageViewHeight.constant = self.imageView.frame.width / ratio
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
            } else {
                self.imageView_p.isHidden = true
            }
            self.Profiletitle.text = data.title
            self.contentField.text = data.content
            self.standardNum.text = data.count
            self.meetArea.text = data.meetArea
            self.hashtag.text = data.hashtag
    }
}
