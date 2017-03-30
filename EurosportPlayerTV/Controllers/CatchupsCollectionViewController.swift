//
//  CatchupsCollectionViewController.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 25/05/2016.


import UIKit
import CoreData
import EurosportKit
import AVKit

private let reuseIdentifier = "Cell"

class CatchupsCollectionViewController: FetchedResultsCollectionViewController, FetchedResultsControllerBackedType {

    typealias FetchedType = Catchup

    var sport: Sport!

    var fetchRequest: NSFetchRequest<FetchedType> {
        let predicate = NSPredicate(format: "sport == %@ AND expirationDate > %@", sport, Date() as NSDate)
        let fetchRequest = Catchup.fetchRequest(predicate, sortedBy: "startDate", ascending: false)
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

        title = sport.name

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as DoubleLabelCollectionViewCell
        let catchup = objectAt(indexPath)
        cell.titleLabel.text = catchup.title
        cell.detailLabel.text = "\(catchup.catchupDescription) (\(DateComponentsFormatter().string(from: catchup.duration)!))"
        cell.imageView.setImage(catchup.imageURL, placeholder: UIImage(named: "catchup_placeholder"), darken: true)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let catchup = objectAt(indexPath)

        print("selected catchup \(catchup.identifier)")

        if let stream = catchup.streams.firstObject as? CatchupStream {

            guard let user = User.currentUser(persistentContainer.viewContext) else {
                return
            }

            stream.generateAuthenticatedURL(user) { result in

                switch result {
                case .success(let url):
                    self.showVideoForURL(url)
                    break
                case .failure(let error):

                    self.showAlert(NSLocalizedString("catchup-failed", comment: "error starting catcup"), error: error as NSError)
                    print("error generating authenticated URL: \(error)")
                    break
                }

            }

        }

    }

}
