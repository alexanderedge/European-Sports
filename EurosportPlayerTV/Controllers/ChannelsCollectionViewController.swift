//
//  ProductsCollectionViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 29/05/2016.


import UIKit
import CoreData
import EurosportKit

private let reuseIdentifier = "Cell"

class ChannelsCollectionViewController: FetchedResultsCollectionViewController, FetchedResultsControllerBackedType {

    typealias FetchedType = Channel

    var fetchRequest: NSFetchRequest<FetchedType> {
        let fetchRequest = Channel.fetchRequest(nil, sortedBy: "identifier", ascending: true)
        // let date = NSDate()
        // let predicate = NSPredicate(format: "SUBQUERY(scheduledProgrammes, $x, $x.startDate < %@ AND $x.endDate > %@).@count > 0", date,date)
        // fetchRequest.predicate = predicate
        return fetchRequest
    }

    lazy var fetchedResultsController: NSFetchedResultsController<FetchedType> = {
        let frc = NSFetchedResultsController(fetchRequest: self.fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            fatalError("unable to perform fetch: \(error)")
        }
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("live-title", comment: "title for the products screen")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // refresh the visible cells
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            collectionView?.reloadItems(at: indexPaths)
        }

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections, sections.count > section else {
            return 0
        }
        return sections[section].numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as LiveStreamCollectionViewCell

        let channel = objectAt(indexPath)

        if let scheduledProgramme = channel.scheduledProgrammes.filtered(using: NSPredicate(format: "startDate < %@", NSDate())).lastObject as? ScheduledProgramme {

            cell.titleLabel.text = scheduledProgramme.shortName
            cell.imageView.setImage(scheduledProgramme.imageURL, darken: false)
            cell.sportLabel.text = scheduledProgramme.sport.name.uppercased()
            cell.detailLabel.text = scheduledProgramme.programmeDescription

        } else {

            cell.titleLabel.text = channel.title
            cell.sportLabel.text = channel.subtitle.uppercased()
            cell.detailLabel.text = nil
        }

        cell.logoImageView.setImage(channel.logoURL, darken: false)

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let channel = objectAt(indexPath)

        print("selected channel \(channel)")

        guard let stream = channel.liveStreams.firstObject as? LiveStream, let user = User.currentUser(persistentContainer.viewContext) else {
            return
        }

        stream.generateAuthenticatedURL(user) { result in
            switch result {
            case .success(let url):

                self.showVideoForURL(url)

                break
            case .failure(let error):

                self.showAlert(NSLocalizedString("catchup-failed", comment: "error starting live stream"), error: error as NSError)
                print("error generating authenticated URL: \(error)")
                break
            }
        }
    }

}
