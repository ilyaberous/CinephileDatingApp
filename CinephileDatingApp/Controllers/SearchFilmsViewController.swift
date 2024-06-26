//
//  SearchFilmsViewController.swift
//  CinephileDatingApp
//
//  Created by Ilya on 23.05.2024.
//

import UIKit

protocol SearchFilmsViewControllerDelegate: AnyObject {
    func searchFilmsController(_ controller: SearchFilmsViewController, wantsToUpdateFavoriteFilmsWith filmTuple: (url:String?, imgURL:String?))
}

class SearchFilmsViewController: UIViewController {
    
    weak var delegate: SearchFilmsViewControllerDelegate?
    private var films = [Film]()
    
    private var searchBar: UISearchController = {
        let sb = UISearchController()
        sb.searchBar.placeholder = "Введите название фильма"
        sb.searchBar.searchBarStyle = .minimal
        return sb
    }()
    
    private var filmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        //layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3 - 10, height: 200)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SearchFilmCell.self, forCellWithReuseIdentifier: SearchFilmCell.identifier)
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filmsCollectionView.delegate = self
        filmsCollectionView.dataSource = self
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        
        view.addSubview(filmsCollectionView)
        filmsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureNavigationBar () {
        navigationItem.title  = "Поиск фильма"
        navigationItem.searchController = searchBar
        searchBar.searchResultsUpdater = self
        
        let backBarItem = UIBarButtonItem(image: UIImage(systemName: "multiply")?.withTintColor(.black, renderingMode: .alwaysOriginal), primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true)
        }))
        
        navigationItem.rightBarButtonItem = backBarItem
    }
}

// MARK: - UICollectionView Delegate Methods

extension SearchFilmsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = films[indexPath.item]
        let filmURL = KinopoiskAPIService.convertFilmIdToURLString(id: item.id)
        let favoriteFilm = (filmURL, item.poster?.previewUrl)
        delegate?.searchFilmsController(self, wantsToUpdateFavoriteFilmsWith: favoriteFilm)
    }
}

// MARK: - UICollectionView DataSource Methods

extension SearchFilmsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchFilmCell.identifier, for: indexPath) as? SearchFilmCell{
            cell.updateCell(posterURL: films[indexPath.row].poster?.previewUrl)
            return cell
        }
        return UICollectionViewCell()
                
    }
}

// MARK: - UICollectionViewFlowLayout Delegate Methods

extension SearchFilmsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32) / 3
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

// MARK: - SearchResultUpdater Delegate Methods

extension SearchFilmsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else{return}
                KinopoiskAPIService.shared.getMovies(for: query.trimmingCharacters(in: .whitespaces)) { titles, error in
                    if let titles = titles {
                        self.films = titles
                        DispatchQueue.main.async {
                            self.filmsCollectionView.reloadData()
                        }
               
                    }
                }
    }
}
