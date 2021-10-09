//
//  ViewController.swift
//  memmove
//
//  Created by Cirno MainasuK on 2021-10-9.
//

import UIKit
import Combine
import SDWebImage

class ViewController: UIViewController {
    
    var disposeBag = Set<AnyCancellable>()
    
    let tableView = UITableView()
    var dataSource: UITableViewDiffableDataSource<Section, Item>!
    
    let sampleImageURLs = [
        "https://media.mstdn.jp/custom_emojis/images/000/120/885/original/75cb4f59948b69ce.png",
        "https://media.mstdn.jp/custom_emojis/images/000/151/091/original/64c3ada851cbd97a.png",
        "https://media.mstdn.jp/custom_emojis/images/000/162/535/original/be4c47423bb99baf.png",
//        "https://media.mstdn.jp/custom_emojis/images/000/210/336/original/2ee48aa1ab3e8c0d.png",
//        "https://media.mstdn.jp/custom_emojis/images/000/158/840/original/59c81e4f6f789bac.png",
//        "https://media.mstdn.jp/custom_emojis/images/000/136/612/original/bfd2477335bc85d2.png"
    ].map { URL(string: $0)! }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk {
            // do nothing
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.register(AnimatedImageTableViewCell.self, forCellReuseIdentifier: String(describing: AnimatedImageTableViewCell.self))
        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AnimatedImageTableViewCell.self), for: indexPath) as! AnimatedImageTableViewCell
            // set label
            cell.primaryLabel.text = "Row: \(indexPath.row)"
            // set image
            switch item {
            case .image(_, let url):
                //cell.id = id
                cell.animatedImageView.sd_setImage(
                    with: url,
                    placeholderImage: .placeholder(color: .systemFill)
                )
            }
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        let items: [Item] = (0..<100000).map { _ in
            let id = UUID()
            let url = sampleImageURLs.randomElement()!
            return Item.image(id: id, url: url)
        }
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Timer.publish(every: 0.01, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                guard let lastIndexPath = self.tableView.indexPathsForVisibleRows?.sorted().last else { return }
                let newIndexPath = IndexPath(row: lastIndexPath.row + 1, section: lastIndexPath.section)
                guard let _ = self.dataSource?.itemIdentifier(for: newIndexPath) else { return }
                self.tableView.scrollToRow(at: newIndexPath, at: .middle, animated: false)
            }
            .store(in: &disposeBag)
    }


}

extension ViewController {
    enum Section: Hashable {
        case main
    }
    
    enum Item: Hashable {
        case image(id: UUID, url: URL)
    }
}

extension UIImage {
    public static func placeholder(size: CGSize = CGSize(width: 1, height: 1), color: UIColor) -> UIImage {
        let render = UIGraphicsImageRenderer(size: size)
        
        return render.image { (context: UIGraphicsImageRendererContext) in
            context.cgContext.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
