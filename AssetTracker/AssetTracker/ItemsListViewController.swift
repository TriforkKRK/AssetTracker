//
//  ItemsListViewController.swift
//  AssetTracker
//
//  Created by Daniel Garbień on 23/08/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import UIKit
import MapKit

//protocol Asset {
//    var title: String { get }
//    var location: CLLocationCoordinate2D { get }
//}

protocol AssetsAccess {
    
    func fetchAssets(completion: [SimpleAsset]? -> Void)
}

protocol ItemsListViewControllerDelegate: class {
    
    func itemsListViewController(controller: ItemsListViewController, didRequestDetailsForAsset asset: SimpleAsset, color: UIColor)
}

class ItemsListViewController: UIViewController {
    
    var delegate: ItemsListViewControllerDelegate?
    
    init(assetsAccess: AssetsAccess, delegate: ItemsListViewControllerDelegate? = nil) {
        self.assetsAccess = assetsAccess
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAssets()
    }
    
    private let assetsAccess: AssetsAccess
    
    // table view
    private var assetsDataSource: SimpleTableViewDataSource<SimpleAsset, ItemTableViewCell>? {
        didSet {
            tableView.dataSource = assetsDataSource
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.tableFooterView = UIView()
            tableView.addSubview(refreshControl())
        }
    }
    private lazy var itemNib = UINib(nibName: "ItemTableViewCell", bundle: NSBundle.mainBundle())

    // map view
    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
}

private extension ItemsListViewController {
    
    func refreshControl() -> UIRefreshControl {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshControlTrigerred(_:)), forControlEvents: .ValueChanged)
        return control
    }
    
    @objc func refreshControlTrigerred(control: UIRefreshControl) {
        fetchAssets {
            control.endRefreshing()
        }
    }
    
    func fetchAssets(completion: (() -> Void)? = nil) {
        assetsAccess.fetchAssets { [weak self] assets in
            self?.updateViewWithAssets(assets ?? [])
            completion?()
        }
    }
    
    func updateViewWithAssets(assets: [SimpleAsset]) {
        // table view
        assetsDataSource = SimpleTableViewDataSource(items: assets ?? [], cellType: .Nib(itemNib)) { (item, cell, indexPath) in
            cell.titleLabel.text = item.title
            let cellColor = UIColor.color(indexPath.row)
            cell.indicatorColor = cellColor
            cell.liveTappedBlock = { [unowned self] in
                self.delegate?.itemsListViewController(self, didRequestDetailsForAsset: item, color: cellColor)
            }
        }
        
        // map view
        mapView.removeAnnotations(mapView.annotations)
        for (index, asset) in assets.enumerate() {
            mapView.addAnnotation(Annotation(coordinate: asset.location, color: UIColor.color(index)))
        }
    }
}

extension ItemsListViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Annotation else {
            return nil
        }
        return mapView.dequeueAnnotationViewWithAnnotation(annotation)
    }
}

extension ItemsListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let asset = assetsDataSource?.itemAtIndexPath(indexPath) else {
            return
        }
        mapView.setCenterCoordinate(asset.location, animated: true)
    }
}
