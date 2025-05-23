//
//  ApertureRing.swift
//  HaebitUI
//
//  Created by Seunghun on 12/1/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import AVFAudio
import UIKit
import SwiftUI

struct ApertureRing<Content, Entry>: UIViewRepresentable where Content: View, Entry: Hashable {
    @Binding var selection: Entry
    @Binding var entries: [Entry]
    let cellWidth: CGFloat
    @Binding var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
    @Binding var isMute: Bool
    let content: (Entry) -> Content
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let apertureRingView = uiView as? ApertureRingView<Content, Entry> else { return }
        apertureRingView.content = content
        apertureRingView.update(
            entries: entries,
            selection: selection,
            feedbackStyle: feedbackStyle,
            isMute: isMute
        )
    }
    
    func makeUIView(context: Context) -> some UIView {
        ApertureRingView(
            entries: entries,
            selection: selection,
            cellWidth: cellWidth,
            feedbackStyle: feedbackStyle,
            isMute: isMute,
            content: content
        ) { newSelection in
            guard selection != newSelection else { return }
            selection = newSelection
        }
    }
}

final class ApertureRingViewCell: UICollectionViewCell {
    static var id: String { String(describing: Self.self) }
    
    var shouldClickForOpening = true
    var shouldClickForClosing = true
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shouldClickForOpening = true
        shouldClickForClosing = true
    }
}

final class ApertureRingView<Content, Entry>: UIView, UICollectionViewDelegate, UICollectionViewDataSource where Content: View, Entry: Hashable {
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(ApertureRingViewCell.self, forCellWithReuseIdentifier: ApertureRingViewCell.id)
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceHorizontal = false
        view.decelerationRate = .init(rawValue: .zero)
        view.bounces = false
        view.isSpringLoaded = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private var feedbackGenerator: UIImpactFeedbackGenerator
    private var isMute: Bool
    
    private let selectionCallback: (Entry) -> Void
    
    private let cellWidth: CGFloat
    
    private var entries: [Entry] = []
    private var selection: Entry
    
    private(set) var currentIndex: Int = .zero
    private var lastContentOffset: CGPoint = .zero
    private var lastTime: TimeInterval = 0.0
    private var scrollSpeedX: CGFloat = 0.0

    var content: (Entry) -> Content

    init(
        entries: [Entry],
        selection: Entry,
        cellWidth: CGFloat,
        feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle,
        isMute: Bool,
        content: @escaping (Entry) -> Content,
        didSelectItemAt selectionCallback: @escaping (Entry) -> Void
    ) {
        self.selectionCallback = selectionCallback
        self.entries = entries
        self.cellWidth = cellWidth
        self.feedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
        self.isMute = isMute
        self.selection = selection
        self.content = content
        super.init(frame: .zero)
        setupViews()
        // TODO: Remove this shitty workaround and fix it legitimate way.
        Task {
            try? await Task.sleep(for: .milliseconds(100))
            reload()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let horiznotalInset = (frame.width - cellWidth) / 2.0
        flowLayout.itemSize = CGSize(width: cellWidth, height: frame.height)
        flowLayout.sectionInset = .init(top: .zero, left: horiznotalInset, bottom: .zero, right: horiznotalInset)
    }
    
    private func setupViews() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func generateFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        guard isMute == false else { return }
        AudioServicesPlaySystemSound(1157)
    }
    
    private func reload() {
        collectionView.reloadData()
        guard let index = entries.firstIndex(of: selection),
              index != currentIndex, index < entries.count else { return }
        collectionView.scrollToItem(
            at: IndexPath(item: index, section: .zero),
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    func update(
        entries: [Entry],
        selection: Entry,
        feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle,
        isMute: Bool
    ) {
        self.isMute = isMute
        feedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
        guard self.entries != entries || self.selection != selection else { return }
        self.entries = entries
        self.selection = selection
        reload()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
        lastTime = Date().timeIntervalSince1970
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentTime = Date().timeIntervalSince1970
        let timeInterval = currentTime - lastTime
        guard timeInterval > 0 else { return }
        let currentOffset = scrollView.contentOffset
        scrollSpeedX = (currentOffset.x - lastContentOffset.x) / CGFloat(timeInterval)
        lastContentOffset = currentOffset
        lastTime = currentTime
        
        let isOpening = scrollSpeedX > .zero
        let offset = CGPoint(x: currentOffset.x + frame.width / 2.0, y: currentOffset.y)
        
        guard let indexPath = collectionView.indexPathForItem(at: offset),
              let cell = collectionView.cellForItem(at: indexPath) as? ApertureRingViewCell,
              (cell.center.x - (frame.width / 4.0)...cell.center.x + (frame.width / 4.0)).contains(offset.x),
              (isOpening ? cell.shouldClickForOpening : cell.shouldClickForClosing) else { return }
        generateFeedback()
        cell.shouldClickForOpening = !isOpening
        cell.shouldClickForClosing = isOpening
        currentIndex = indexPath.item
        selection = entries[currentIndex]
        selectionCallback(selection)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = CGPoint(x: scrollView.contentOffset.x + frame.width / 2.0, y: scrollView.contentOffset.y)
        guard let indexPath = collectionView.indexPathForItem(at: offset) else { return }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentIndex = indexPath.item
        selection = entries[currentIndex]
        selectionCallback(selection)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        let offset = CGPoint(x: scrollView.contentOffset.x + frame.width / 2.0, y: scrollView.contentOffset.y)
        guard let indexPath = collectionView.indexPathForItem(at: offset) else { return }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentIndex = indexPath.item
        selection = entries[currentIndex]
        selectionCallback(selection)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        entries.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApertureRingViewCell.id, for: indexPath)
        guard let cell = cell as? ApertureRingViewCell else { return cell }
        let data = entries[indexPath.item]
        cell.contentConfiguration = UIHostingConfiguration { content(data) }
        return cell
    }
}
