//
//  UIImageView+Extension.swift
//  ImageCacheProject
//
//  Created by JH on 2019/11/22.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit

// 힌트 objc_getAssociatedObject
extension UIImageView {
    
    // 캐싱된 이미지 셋팅
    func setCachingImage(url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else { return }
            let image = UIImage(data: data)!
            
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
            
            /**
             NSCache의 KeyType과 ObjectType은 모두 AnyObject로 제약이 걸려있음
             그래서 Key는 NSString (String은 Struct이기 때문에 Class 타입인 NSString로 설정), Object는 UIImage로 설정
             그리고 Data를 받아온 부분에서 이 Cache에 object를 set
            */
            MemoryCacheViewController.memoryCache.setObject(image, forKey: "FirstImage")
        }.resume()
        
    }
    
}
