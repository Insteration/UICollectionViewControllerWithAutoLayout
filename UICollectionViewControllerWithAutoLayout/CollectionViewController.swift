//
//  CollectionViewController.swift
//  UICollectionViewControllerWithAutoLayout
//
//  Created by Артём Кармазь on 6/2/19.
//  Copyright © 2019 Artem Karmaz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var items = [Item]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        cell.backgroundColor = items[indexPath.row].color
        return cell
    }
}

// MARK: Controllers

class SmallViewController: CollectionViewController {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        super.init(collectionViewLayout: layout)
        useLayoutToLayoutNavigationTransitions = false
        title = "Small cells"
        items = (0...50).map { _ in Item(color: .random()) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bigVC = BigViewController()
        bigVC.items = items
        navigationController?.pushViewController(bigVC, animated: true)
    }
}

class BigViewController: CollectionViewController {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        super.init(collectionViewLayout: layout)
        title = "Big cells"
        useLayoutToLayoutNavigationTransitions = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
    }
}


extension CollectionViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let collectionVC = viewController as? CollectionViewController else { return }
        collectionVC.collectionView?.delegate = collectionVC
        collectionVC.collectionView?.dataSource = collectionVC
    }
}

//Во-первых, в момент когда происходит магия, используется повторно один и тот же UICollectionView. Контроллер, на который осуществляется переход не создает свой собственный collection view. Это может иметь или не иметь значения для вашего приложения, но об этом полезно знать.
//Во-вторых, root view controller (SmallViewController в нашем случае) по-прежнему будет установлен как delegate и dataSource, когда будет запущен новый view controller.
