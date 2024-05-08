//
//  ImageGridViewController.swift
//  AcharyaprashantOrg
//
//  Created by MacBook on 5/6/24.
//


import UIKit

class ImageGridViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let viewModel: MediaCoverageViewModel
    
    init(viewModel: MediaCoverageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = MediaCoverageViewModel(apiManager: APIManager())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchMediaCoverages()
    }
    
     func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            collectionView.collectionViewLayout = CustomLayout()
        }
    }
    
    private func fetchMediaCoverages() {
        viewModel.fetchMediaCoverages { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension ImageGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mediaCoverages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.activityIndicator.startAnimating()

        viewModel.loadImage(for: indexPath) { image in
            DispatchQueue.main.async {
                cell.imageView.image = image
                cell.titleLabel.text = self.viewModel.mediaCoverages[indexPath.row].title
                cell.activityIndicator.stopAnimating()
            }
        }
        return cell
    }
}

extension ImageGridViewController: UICollectionViewDelegate {
   
}


class CustomLayout: UICollectionViewFlowLayout {
    let numberOfColumns: CGFloat = 3
    let cellPadding: CGFloat = 5
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.width - (numberOfColumns - 1) * cellPadding
        let itemWidth = (availableWidth / numberOfColumns).rounded(.down)
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        self.itemSize = itemSize
        self.minimumInteritemSpacing = cellPadding
        self.minimumLineSpacing = cellPadding
    }
}
