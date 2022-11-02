// MainViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// MainViewController основной экран с табами
class MainViewController: UITableViewController {
    // MARK: - Private properties

    private var isLoggedIn = false

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoggedIn = UserDefaults.standard.bool(forKey: Constants.isLoggedIn)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLoggedIn()
    }

    // MARK: - Private methods

    private func checkLoggedIn() {
        if !isLoggedIn {
            performSegue(withIdentifier: Constants.goToLoginSegueIdentifier, sender: self)
        }
    }

    private func setupViews() {
        navigationItem.title = Constants.friendsTitle
        tableView.register(FriendsViewCell.nib(), forCellReuseIdentifier: FriendsViewCell.identifier)
    }
}
/// Constants
extension MainViewController {
    enum Constants {
        static let goToLoginSegueIdentifier = "goToLogin"
        static let isLoggedIn = "isLoggedIn"
        static let goToPhotos = "goToPhotos"
        static let friendsTitle = "My friends"
    }
}

/// UITableViewDataSourceDelegate, UITableViewDelegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FriendsViewCell.identifier) as? FriendsViewCell {
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.goToPhotos, sender: self)
    }
}
