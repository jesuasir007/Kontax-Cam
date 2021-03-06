//
//  FXInfoViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 9/8/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

struct FXInfo: Codable, Hashable {
    var id = UUID()
    let iconName: String
    let title: String
    let description: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FXInfo, rhs: FXInfo) -> Bool {
        return lhs.id == rhs.id
    }
}

class FXInfoViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        return tableView
    }()
    private var dataSource: DataSource!
    private var datas = [FXInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle("Effects information")
        self.addCloseButton()
        self.tableView.register(FXInfoTableViewCell.self, forCellReuseIdentifier: FXInfoTableViewCell.ReuseIdentifier)
        setupView()
        setupConstraint()
        
        configureDataSource()
        
        setupDatas()
    }
    
    private func setupView() {
        self.tableView.backgroundColor = .systemBackground
        self.view.addSubview(tableView)
        tableView.delegate = self
    }
    
    private func setupConstraint() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDatas() {
        datas = [
            FXInfo(
                iconName: "color.icon",
                title: "Colour leaks",
                description: """
                Colour leaks add a gorgeous film colour overlay into your photo. Currently Kontax Cam provides three different colours: red, green, and blue.
                """),
            FXInfo(
                iconName: "calendar.icon",
                title: "Datestamp",
                description: """
                Datestamp allows you to add a real film date stamp into your photo.
                """),
            FXInfo(
                iconName: "grain.icon",
                title: "Grain",
                description: """
                Grain makes your photo looks vintage and old school! Although excessive use might render the photo too grainy. Use with care!
                """),
            FXInfo(
                iconName: "dust.icon",
                title: "Dust",
                description: """
                Dust allows you to overlay your photo with real film dust. This effect best used with a film/vintage filter rather than modern one.
                """),
            FXInfo(
                iconName: "leaks.icon",
                title: "Light leaks",
                description: """
                Light leaks makes your photo pop with custom made film light leaks. This effect best used with a film/vintage filter rather than modern one. But then, you can always experiment!
                """)
        ]
        
        createSnapshot(from: datas)
    }

}

extension FXInfoViewController {
    fileprivate enum Section { case main }
    fileprivate typealias DataSource = UITableViewDiffableDataSource<Section, FXInfo>
    fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<Section, FXInfo>
    
    /// Configure the datasource for the collectionview.
    fileprivate func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, _, fxInfo) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FXInfoTableViewCell.ReuseIdentifier) as? FXInfoTableViewCell else {
                return nil
            }

            cell.fxInfo = fxInfo
            
            return cell
        })
    }
    
    /// Create the snapshot for our datasource
    fileprivate func createSnapshot(from infos: [FXInfo]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(infos)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension FXInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .secondarySystemBackground
    }
}

class FXInfoTableViewCell: UITableViewCell {
    
    static let ReuseIdentifier = "FXInfoCell"
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    private var mStackView: UIStackView!
    
    var fxInfo: FXInfo! {
        didSet {
            titleLabel.text = fxInfo.title
            iconImageView.image = UIImage(named: fxInfo.iconName) ?? UIImage(systemName: fxInfo.iconName)
            descriptionLabel.text = fxInfo.description
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        mStackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, descriptionLabel])
        mStackView.alignment = .leading
        mStackView.axis = .vertical
        mStackView.spacing = 15
        mStackView.isLayoutMarginsRelativeArrangement = true
        mStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        mStackView.setCustomSpacing(0, after: titleLabel)
        
        addSubview(mStackView)
    }
    
    private func setupConstraint() {
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
        }
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
