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

public struct HaebitDial: UIViewRepresentable {
    @Binding var selection: DialEntry
    var data: [DialEntry]
    
    public class Coordinator: DialViewDelegate {
        var parent: HaebitDial
        
        init(_ parent: HaebitDial) {
            self.parent = parent
        }
        
        func dialView(_ dialView: DialView, didSelectEntry: DialEntry) {
            parent.selection = didSelectEntry
        }
    }
    
    public init(data: [DialEntry], selection: Binding<DialEntry>) {
        self._selection = selection
        self.data = data
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let dialView = uiView as? DialView else { return }
        dialView.data = data
        dialView.select(entry: selection)
        print(data, selection)
    }
    
    public func makeUIView(context: Context) -> some UIView {
        let view = DialView()
        view.delegate = context.coordinator
        return view
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

final class DialViewCell: UICollectionViewCell {
    static var id: String { Self.description() }
    
    var shouldTickleAscending = true
    var shouldTickleDescending = true
    var title: String = "" { didSet { titleLabel.text = title } }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shouldTickleAscending = true
        shouldTickleDescending = true
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

public struct DialEntry: Hashable {
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
}

protocol DialViewDelegate: AnyObject {
    func dialView(_ dialView: DialView, didSelectEntry: DialEntry)
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
        view.backgroundColor = .darkGray
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    public var data: [DialEntry] = []
    
    weak var delegate: DialViewDelegate?
    
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
    
    func select(entry: DialEntry) {
        guard let item = (data.firstIndex { $0 == entry }) else { return }
        let indexPath = IndexPath(item: item, section: .zero)
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
        delegate?.dialView(self, didSelectEntry: data[indexPath.item])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        let offset = CGPoint(x: scrollView.contentOffset.x + frame.width / 2.0, y: scrollView.contentOffset.y)
        guard let indexPath = collectionView.indexPathForItem(at: offset) else { return }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        delegate?.dialView(self, didSelectEntry: data[indexPath.item])
    }
}

extension DialView: UICollectionViewDelegate {}

extension DialView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        data.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DialViewCell.id, for: indexPath)
        guard let dialViewCell = cell as? DialViewCell else { return cell }
        dialViewCell.contentView.backgroundColor = .systemPink
        dialViewCell.title = data[indexPath.item].title
        return dialViewCell
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 30)) {
    let view = DialView()
    view.data = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22].map { DialEntry(title: "\($0)") }
    return view
}
