//
//  ViewController.swift
//  ImageSaveSample
//
//  Created by sjbyun on 05/01/2020.
//  Copyright © 2020 sjbyun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    
    // MARK:- Variables
    var imageList = [String]()
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inputImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTap)))
    }
    
    
    
    func getImageFiles() {
        do {
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let contents = try FileManager.default.contentsOfDirectory(atPath: dirPath)
            
            imageList.removeAll()
            contents.forEach { fileName in
                let filePath = dirPath + "/" + fileName
                imageList.append(filePath)
            }
        } catch { }
        
        imageCollectionView.reloadData()
    }
    
    
    
    @objc
    func imageViewTap() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
    
    // MARK:- Actions
    @IBAction func reloadBtnTouched(_ sender: Any) {
        getImageFiles()
    }
}



extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            inputImageView.image = image
            
            do {
                if let imageData = image.pngData() {
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let filePath = documentsURL.appendingPathComponent(UUID().uuidString)
                    imageList.append(filePath.absoluteString)
                    
                    try imageData.write(to: filePath, options: .atomic)
                }
            } catch { }
        }
        
        
        picker.dismiss(animated: true) {
            self.getImageFiles()
        }
    }
}



extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for:indexPath) as! ImageCollectionViewCell
        
        let imagePath = imageList[indexPath.row]
        if let image = UIImage(contentsOfFile: imagePath) {
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

