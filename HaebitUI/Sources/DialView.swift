//
//  DialView.swift
//  HaebitUI
//
//  Created by Seunghun on 12/1/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import UIKit
import SnapKit
import SwiftUI

struct DialViewRepresentable<ContentLabel, SelectionValue>: UIViewRepresentable where ContentLabel: View, SelectionValue: Hashable {
    class Coordinator: NSObject, DialViewDelegate, UICollectionViewDataSource {
        var parent: DialViewRepresentable
        
        init(_ parent: DialViewRepresentable) {
            self.parent = parent
        }
        
        func dialView(_ dialView: DialView, didSelectIndex index: Int) {
            parent.selection = parent.data[index]
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            numberOfItemsInSection section: Int
        ) -> Int {
            parent.data.count
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DialViewCell.id, for: indexPath)
            guard let dialViewCell = cell as? DialViewCell else { return cell }
            let data = parent.data[indexPath.item]
            cell.contentConfiguration = UIHostingConfiguration { parent.content(data) }
            return dialViewCell
        }
    }
    
    var data: [SelectionValue]
    @Binding var selection: SelectionValue
    var content: (SelectionValue) -> ContentLabel
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let dialView = uiView as? DialView else { return }
        dialView.reload()
        dialView.select(index: data.firstIndex(of: selection))
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = DialView()
        view.delegate = context.coordinator
        view.dataSource = context.coordinator
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

final class DialViewCell: UICollectionViewCell {
    static var id: String { Self.description() }
    
    var shouldTickleAscending = true
    var shouldTickleDescending = true
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shouldTickleAscending = true
        shouldTickleDescending = true
    }
}

protocol DialViewDelegate: AnyObject {
    func dialView(_ dialView: DialView, didSelectIndex index: Int)
}

final class DialView: UIView {
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(DialViewCell.self, forCellWithReuseIdentifier: DialViewCell.id)
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceHorizontal = false
        view.decelerationRate = .init(rawValue: .zero)
        view.bounces = false
        view.isSpringLoaded = false
        view.delegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    weak var delegate: DialViewDelegate?
    weak var dataSource: UICollectionViewDataSource? { didSet { collectionView.dataSource = dataSource } }
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horiznotalInset = (frame.width - 60) / 2.0
        flowLayout.itemSize = CGSize(width: 60, height: frame.height)
        flowLayout.sectionInset = .init(top: .zero, left: horiznotalInset, bottom: .zero, right: horiznotalInset)
    }
    
    private func setupViews() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func select(index: Int?) {
        guard let index else { return }
        let indexPath = IndexPath(item: index, section: .zero)
        collectionView.layoutIfNeeded()
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

extension DialView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        feedbackGenerator.prepare()
        let isAscending = scrollView.panGestureRecognizer.velocity(in: self).x > .zero
        let offset = CGPoint(x: scrollView.contentOffset.x + frame.width / 2.0, y: scrollView.contentOffset.y)
        
        guard let indexPath = collectionView.indexPathForItem(at: offset),
              let cell = collectionView.cellForItem(at: indexPath) as? DialViewCell,
              (cell.center.x - (frame.width / 4.0)...cell.center.x + (frame.width / 4.0)).contains(offset.x),
              (isAscending ? cell.shouldTickleAscending : cell.shouldTickleDescending) else { return }
        feedbackGenerator.impactOccurred()
        cell.shouldTickleAscending = !isAscending
        cell.shouldTickleDescending = isAscending
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = CGPoint(x: scrollView.contentOffset.x + frame.width / 2.0, y: scrollView.contentOffset.y)
        guard let indexPath = collectionView.indexPathForItem(at: offset) else { return }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.dialView(self, didSelectIndex: indexPath.item)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        let offset = CGPoint(x: scrollView.contentOffset.x + frame.width / 2.0, y: scrollView.contentOffset.y)
        guard let indexPath = collectionView.indexPathForItem(at: offset) else { return }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.dialView(self, didSelectIndex: indexPath.item)
    }
}

extension DialView: UICollectionViewDelegate {}
