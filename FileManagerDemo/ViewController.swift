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
        //TODO: Download From Internet
    }
    
    @IBAction func refreshButtonClicked(_ sender: UIBarButtonItem)
    {
        arrayPhoto.removeAll()
        
        //TODO: Load Data (from directory)
        
        pageControlPhoto.numberOfPages = arrayPhoto.count
        collectionViewPhoto.reloadData()
    }
    
    @IBAction func deleteAllButtonClicked(_ sender: UIBarButtonItem)
    {
        //TODO: Delete
    }
    
    func save(text: String, name: String)
    {
        //TODO: Create File .txt
    }
    
    func save(_ photo: Photo)
    {
        //TODO: Create Directory, Create File .png
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
