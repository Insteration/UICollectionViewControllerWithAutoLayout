//
//  CollectionViewController.swift
//  UICollectionViewControllerWithAutoLayout
//
//  Created by Артём Кармазь on 6/2/19.
//  Copyright © 2019 Artem Karmaz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ColorCollectionViewController: UICollectionViewController {
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.setCollectionViewLayout(CustomFlowLayout(), animated: false)
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(ko))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }
    
//    @IBAction func addItem(_ sender: UIBarButtonItem) {
//        addItem()
//        let indexPath = IndexPath(item: items.count - 1, section: 0)
//        print("Index path is - \(indexPath)")
//        myCollectionView.performBatchUpdates({
//            self.myCollectionView.insertItems(at: [indexPath])
//        }, completion: nil)
//    }
//
//
    private func addItem() {
        items.append(Item(color: .random(), title: String(Int.random(in: 0...50))))
    }
    
    @objc func ko() {
        addItem()
        let indexPath = IndexPath(item: items.count - 1, section: 0)
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [indexPath])
        }, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.random().cgColor
        cell.layer.shadowOpacity = 3
        cell.backgroundColor = items[indexPath.row].color
        return cell
    }
}

// MARK: - Controllers

class SmallViewController: ColorCollectionViewController {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        super.init(collectionViewLayout: layout)
        useLayoutToLayoutNavigationTransitions = false
        title = "Small Cells"
        items = (0...23).map { _ in Item(color: .random(), title: String(Int.random(in: 0...50))) }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bigVC = BigViewController()
        bigVC.items = items
        navigationController?.pushViewController(bigVC, animated: true)
    }
}

class BigViewController: ColorCollectionViewController {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        super.init(collectionViewLayout: layout)
        title = "Big Cells"
        useLayoutToLayoutNavigationTransitions = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let veryBigVC = VeryBigController()
        veryBigVC.items = items
        navigationController?.pushViewController(veryBigVC, animated: true)
    }
}

class VeryBigController: ColorCollectionViewController {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 300)
        super.init(collectionViewLayout: layout)
        title = "Very Big Cells"
        useLayoutToLayoutNavigationTransitions = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Cell

class CollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        title.text = randomString(length: Int.random(in: 1...4))
        title.textAlignment = .center
        title.textColor = .random()
        
        contentView.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension ColorCollectionViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let collectionVC = viewController as? ColorCollectionViewController else { return }
        collectionVC.collectionView?.delegate = collectionVC
        collectionVC.collectionView?.dataSource = collectionVC
    }
}

//Во-первых, в момент когда происходит магия, используется повторно один и тот же UICollectionView. Контроллер, на который осуществляется переход не создает свой собственный collection view. Это может иметь или не иметь значения для вашего приложения, но об этом полезно знать.
//Во-вторых, root view controller (SmallViewController в нашем случае) по-прежнему будет установлен как delegate и dataSource, когда будет запущен новый view controller.

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    var insertIndexPaths = [IndexPath]()
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertIndexPaths.removeAll()
        
        for update in updateItems {
            if let indexPath = update.indexPathAfterUpdate, update.updateAction == .insert {
                insertIndexPaths.append(indexPath)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertIndexPaths.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        if insertIndexPaths.contains(itemIndexPath) {
            attributes?.alpha = 0.0
            attributes?.transform = CGAffineTransform(translationX: 0, y: 500)
        }
        
        return attributes
    }
}
