//
//  ViewController.swift
//  FileManagerDemo
//
//  Created by William Chrisandy on 12/07/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textFieldURL: UITextField!
    @IBOutlet weak var textFieldFileName: UITextField!
    @IBOutlet weak var collectionViewPhoto: UICollectionView!
    @IBOutlet weak var pageControlPhoto: UIPageControl!
    
    var arrayPhoto: [Photo] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionViewPhoto.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "photoCollectionViewCell")
        
        save(text: "Text", name: "Test.txt")
        
        save(Photo(image: UIImage(systemName: "circle.dashed.inset.filled"), name: "Circle"))
        save(Photo(image: UIImage(systemName: "heart.fill")))
        save(Photo(image: UIImage(systemName: "square.dashed"), name: "Square"))
        save(Photo(name: "LabelOnly"))
        save(Photo(image: UIImage(systemName: "theatermasks"), name: "Mood"))
        
        refreshButtonClicked(UIBarButtonItem())
    }

    @IBAction func addButtonClicked(_ sender: UIButton)
    {
        let fileName = textFieldFileName.text!
        guard let downloadURL = URL(string: textFieldURL.text!)
        else
        {
            print("URL is not valid")
            return
        }
        
        let downloadTask = URLSession.shared.downloadTask(with: downloadURL)
        {
            url, response, error in
            do
            {
                if let downloadFileURL = url
                {
                    let rootURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let subDirectoryURL = rootURL.appendingPathComponent("Raw Data")
                    
                    try FileManager.default.createDirectory(at: subDirectoryURL, withIntermediateDirectories: true)
                        
                    let saveURL = subDirectoryURL.appendingPathComponent(fileName)
                    
                    try FileManager.default.moveItem(at: downloadFileURL, to: saveURL)
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        downloadTask.resume()
    }
    
    @IBAction func refreshButtonClicked(_ sender: UIBarButtonItem)
    {
        arrayPhoto.removeAll()
        
        do
        {
            let rootURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let subDirectoryURL = rootURL.appendingPathComponent("Raw Data")
            
            let contents = try FileManager.default.contentsOfDirectory(at: subDirectoryURL, includingPropertiesForKeys: nil)
            
            for content in contents
            {
                if let image = UIImage(contentsOfFile: content.path)
                {
                    let fileName = content.lastPathComponent
                    arrayPhoto.append(Photo(image: image, name: fileName))
                }
            }
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        pageControlPhoto.numberOfPages = arrayPhoto.count
        collectionViewPhoto.reloadData()
    }
    
    @IBAction func deleteAllButtonClicked(_ sender: UIBarButtonItem)
    {
        do
        {
            let rootURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let subDirectoryURL = rootURL.appendingPathComponent("Raw Data")
            try FileManager.default.removeItem(at: subDirectoryURL)
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func save(text: String, name: String)
    {
        do
        {
            let rootURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let saveURL = rootURL.appendingPathComponent(name)
            try text.write(to: saveURL, atomically: true, encoding: .utf8)
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    
    func save(_ photo: Photo)
    {
        do
        {
            let rootURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let subDirectoryURL = rootURL.appendingPathComponent("Raw Data")

            try FileManager.default.createDirectory(at: subDirectoryURL, withIntermediateDirectories: true)
            
            if let fileName = photo.name, let pngData = photo.image?.pngData()
            {
                let saveURL = subDirectoryURL.appendingPathComponent("\(fileName).png")
                try pngData.write(to: saveURL)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrayPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = arrayPhoto[indexPath.item].image
        cell.label.text = arrayPhoto[indexPath.item].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return collectionView.visibleSize
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let visibleRectangle = CGRect(origin: collectionViewPhoto.contentOffset, size: collectionViewPhoto.bounds.size)
        if let visibleIndexPath = collectionViewPhoto.indexPathForItem(at: CGPoint(x: visibleRectangle.midX, y: visibleRectangle.midY))
        {
            pageControlPhoto.currentPage = visibleIndexPath.item
        }
    }
    
}
