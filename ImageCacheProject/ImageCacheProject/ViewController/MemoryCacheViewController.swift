//
//  MemoryCacheViewController.swift
//  ImageCacheProject
//
//  Created by JH on 25/10/2019.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit

class MemoryCacheViewController: BaseViewController {

    // MARK: - Property
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    // NSCache 생성
    let memoryCache = NSCache<NSString, UIImage>()
    
    private let firstStringURL: String = "https://raw.githubusercontent.com/jeehge/resume/master/Image/project_lunch.png"
    private let secondStringURL: String = "https://raw.githubusercontent.com/jeehge/resume/master/Image/lunch_icon.png"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBAction
    @IBAction func actionDownload(_ sender: UIButton) {
        // "Image Download" 버튼을 누르면 URLSession을 이용하여 data를 받아오고 각 ImageView에 넣는 작업
        let firstURL = URL(string: firstStringURL)
        URLSession.shared.dataTask(with: firstURL!) { data, response, error in
            guard let data = data else { return }
            let image = UIImage(data: data)!
            
            
            DispatchQueue.main.async { [weak self] in
                // Cache가 존재하는지를 체크하고 없다면 이미지를 불러와 Caching하는 과정을 추가
                if let firstCachedImage = self?.memoryCache.object(forKey: "FirstImage") {
                    print("캐시에 이미지가 존재합니다")
                    self?.firstImageView.image = firstCachedImage
                } else {
                    self?.firstImageView.image = image
                    /**
                     NSCache의 KeyType과 ObjectType은 모두 AnyObject로 제약이 걸려있음
                     그래서 Key는 NSString (String은 Struct이기 때문에 Class 타입인 NSString로 설정), Object는 UIImage로 설정
                     그리고 Data를 받아온 부분에서 이 Cache에 object를 set
                    */
                    self?.memoryCache.setObject(image, forKey: "FirstImage")
                }
            }
        }.resume()
        
        let secondURL = URL(string: secondStringURL)
        URLSession.shared.dataTask(with: secondURL!) { data, response, error in
            guard let data = data else { return }
            let image = UIImage(data: data)!
            DispatchQueue.main.async { [weak self] in
                self?.secondImageView.image = image
            }
        }.resume() // 실행
    }
    
    @IBAction func actionClear(_ sender: UIButton) {
        self.firstImageView.image = nil
        self.secondImageView.image = nil
    }
}
