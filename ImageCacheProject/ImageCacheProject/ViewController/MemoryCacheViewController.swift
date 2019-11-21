//
//  MemoryCacheViewController.swift
//  ImageCacheProject
//
//  Created by JH on 25/10/2019.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit

// 내가 사용한 방법은 아니고 이렇게 사용하고 있다고 추천 받은 코드 메모!
class ImageCache {
    static let shard: NSCache = { () -> NSCache<NSString, UIImage> in
        let cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
        cache.name = "ImageCache"
        return cache
    }()
}


class MemoryCacheViewController: BaseViewController {

    // MARK: - Property
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    // NSCache 생성
    // static 안 붙여주면 얘는 싱클톤이 아님! 싱글톤으로 만들던가! 메모리에 올려두던가!
    static let memoryCache: NSCache = NSCache<NSString, UIImage>()
    
    private let firstStringURL: String = "https://raw.githubusercontent.com/jeehge/resume/master/Image/project_lunch.png"
    private let secondStringURL: String = "https://raw.githubusercontent.com/jeehge/resume/master/Image/lunch_icon.png"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - IBAction
    @IBAction func actionDownload(_ sender: UIButton) {
        // Cache가 존재하는지를 체크하고 없다면 이미지를 불러와 Caching하는 과정을 추가
        if let firstCachedImage = MemoryCacheViewController.memoryCache.object(forKey: "FirstImage") {
            print("메모리 캐시에 이미지가 존재합니다")
            self.firstImageView.image = firstCachedImage
        } else {
            guard let firstURL = URL(string: firstStringURL) else { return }
            // "Image Download" 버튼을 누르면 URLSession을 이용하여 data를 받아오고 각 ImageView에 넣는 작업
            self.firstImageView.setCachingImage(url: firstURL)
        }
        
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
