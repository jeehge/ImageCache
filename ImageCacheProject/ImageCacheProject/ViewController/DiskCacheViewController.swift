//
//  DiskCacheViewController.swift
//  ImageCacheProject
//
//  Created by JH on 25/10/2019.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit

class DiskCacheViewController: BaseViewController {

    // MARK: - Property
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    private let diskPrefix: String = "DiskCacheTest"
    private let firstStringURL: String = "https://raw.githubusercontent.com/jeehge/resume/master/Image/project_lunch.png"
    private let secondStringURL: String = "https://raw.githubusercontent.com/jeehge/resume/master/Image/lunch_icon.png"
    
    // FileManager 인스턴스 생성. default 는 FileManager 싱글톤 인스턴스를 만들어줌
    // FileManager는 URL 혹은 String 데이터 타입을 통해 파일에 접근할 수 있도록 합니다
    // Apple에서는 URL을 통한 파일 접근을 권장함
    private let fileManager: FileManager = FileManager.default
    private var dataPath: URL?
        
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFilePath()
    }
    
    func initFilePath() {
        // cache 디렉토리의 경로 저장
        // urls(for:in:): 메소드를 통해 특정 경로에 접근
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        // 해당 디렉토리 이름 지정.
        // /Library/Caches/DiskCache <- 경로를 dataPath 저장
        dataPath = cachesDirectory.appendingPathComponent("DiskCache")
        
        guard let path = dataPath?.path else { return }
        
        if !fileManager.fileExists(atPath: path) {
            do {
                print("디렉토리 생성")
                // 디렉토리 생성
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            } catch let error {
                print("Error creating directory: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func actionDownload(_ sender: UIButton) {
        // "Image Download" 버튼을 누르면 URLSession을 이용하여 data를 받아오고 각 ImageView에 넣는 작업
        let firstURL = URL(string: firstStringURL)
        URLSession.shared.dataTask(with: firstURL!) { data, response, error in
            guard let data = data else { return }
            let image = UIImage(data: data)!
            
            guard let strPath = self.dataPath?.appendingPathComponent("project_lunch.png") else { return }
            
            if self.fileManager.fileExists(atPath: strPath.path) {
                print("캐시에 이미지가 존재합니다")
                do {
                    let data = try Data(contentsOf: strPath)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.firstImageView.image = image
                    }
                } catch let error {
                     print("Error : \(error.localizedDescription)")
                }
            } else {
                // store it in the document directory
                self.fileManager.createFile(atPath: strPath.path , contents: image.pngData(), attributes: nil)
                /**
                 디스크 캐시는 iOS의 파일 시스템을 사용하여 객체에서 변환 된 데이터를 저장.
                 일반적으로 앱의 캐시 디렉토리에 자체 디렉토리를 만듭니다.
                 모든 객체에 대해 파일이 생성됩니다.
                */
                DispatchQueue.main.async { [weak self] in
                    self?.firstImageView.image = image
                }
            }
        }.resume() // 실행
        
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
