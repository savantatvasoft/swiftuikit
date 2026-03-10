////
////  HomeVC.swift
////  appnavigation
////
////  Created by MACM72 on 27/01/26.
////
//
////
////  HomeVC.swift
////  appnavigation
////
////  Updated for image/video upload like Instagram/WhatsApp
////
//
//import UIKit
//import PhotosUI
//import AVFoundation
//import MobileCoreServices
//
//class HomeVC: UIViewController {
//
//    // MARK: - Properties
//
//    private let contentView = UIView()
//    private let tabsView = UIView()
//    private var currentChildVC: UIViewController?
//
//    private let dashedBorder = CAShapeLayer()
//    private lazy var uploadContainer: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemGray6
//        view.layer.cornerRadius = 12
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        view.addGestureRecognizer(tap)
//        return view
//    }()
//
//    private lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Tap to upload Image or Video"
//        label.textColor = .systemBlue
//        label.font = .systemFont(ofSize: 16, weight: .medium)
//        return label
//    }()
//
//    // MARK: - View Lifecycle
//
//    override func loadView() {
//        super.loadView()
//        print("HomeVC → loadView")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("HomeVC → viewDidLoad")
//
//        view.backgroundColor = .systemGray
//        setupNavigationBar()
//        setupUploadView()
//
//        // Uncomment if using tabs
//        // setupTabsView()
//        // setupContentView()
//        // setupTabButtons()
//        // switchToVC(FeedVC())
//    }
//
//    private func setupUploadView() {
//        view.addSubview(uploadContainer)
//        uploadContainer.addSubview(titleLabel)
//
//        NSLayoutConstraint.activate([
//            uploadContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            uploadContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            uploadContainer.widthAnchor.constraint(equalToConstant: 300),
//            uploadContainer.heightAnchor.constraint(equalToConstant: 150),
//
//            titleLabel.centerXAnchor.constraint(equalTo: uploadContainer.centerXAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: uploadContainer.centerYAnchor)
//        ])
//    }
//
//    private func updateDashedBorder() {
//        dashedBorder.strokeColor = UIColor.systemBlue.cgColor
//        dashedBorder.lineDashPattern = [6, 4]
//        dashedBorder.frame = uploadContainer.bounds
//        dashedBorder.fillColor = nil
//        dashedBorder.path = UIBezierPath(roundedRect: uploadContainer.bounds, cornerRadius: 12).cgPath
//
//        if dashedBorder.superlayer == nil {
//            uploadContainer.layer.addSublayer(dashedBorder)
//        }
//    }
//
//    @objc private func handleTap() {
//        var config = PHPickerConfiguration()
//        config.filter = .any(of: [.images, .videos])
//        config.selectionLimit = 0 // allow multiple selection if desired
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = self
//        present(picker, animated: true)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateDashedBorder()
//    }
//
//    // MARK: - Navigation Bar
//
//    private func setupNavigationBar() {
//        title = "Home"
//
//        let titleLabel = UILabel()
//        titleLabel.text = "Custom Title"
//        titleLabel.font = .boldSystemFont(ofSize: 18)
//        navigationItem.titleView = titleLabel
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "Next",
//            style: .plain,
//            target: self,
//            action: #selector(nextTapped)
//        )
//    }
//
//    @objc private func nextTapped() {
//        let detailsVC = DetailsVC()
//        navigationController?.pushViewController(detailsVC, animated: true)
//    }
//
//    deinit {
//        print("HomeVC → deinit")
//    }
//}
//
//// MARK: - PHPicker Delegate (Image + Video Upload)
//
//extension HomeVC: PHPickerViewControllerDelegate {
//
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//
//        for result in results {
//            let provider = result.itemProvider
//
//            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
//                handleImage(provider)
//            } else if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
//                handleVideo(provider)
//            }
//        }
//    }
//
//    // MARK: - Image Handling
//
//    private func handleImage(_ provider: NSItemProvider) {
//        provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] data, error in
//            guard let self, let data else { return }
//            if let error { print("Image load error:", error) }
//
//            DispatchQueue.main.async {
//                self.uploadImageDataUsingAlamofire(data)
//            }
//        }
//    }
//
//    private func uploadImageDataUsingAlamofire(_ data: Data) {
//        // Upload image data directly, no disk copy
//        // Example:
//        // AF.upload(data, to: "https://your-api.com/upload").response { response in ... }
//        print("Image ready to upload, size: \(data.count) bytes")
//    }
//
//    // MARK: - Video Handling
//
//    private func handleVideo(_ provider: NSItemProvider) {
//        provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] url, error in
//            guard let self, let url else { return }
//            if let error { print("Video load error:", error) }
//
//            let asset = AVURLAsset(url: url)
//            self.exportAndUploadVideo(asset)
//        }
//    }
//
//    private func exportAndUploadVideo(_ asset: AVAsset) {
//        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else { return }
//
//        let outputURL = FileManager.default.temporaryDirectory
//            .appendingPathComponent(UUID().uuidString)
//            .appendingPathExtension("mp4")
//
//        exportSession.outputURL = outputURL
//        exportSession.outputFileType = .mp4
//        exportSession.shouldOptimizeForNetworkUse = true
//
//        exportSession.exportAsynchronously { [weak self] in
//            guard let self else { return }
//
//            switch exportSession.status {
//            case .completed:
//                DispatchQueue.main.async {
//                    self.uploadVideoFileAndCleanup(outputURL)
//                }
//            case .failed, .cancelled:
//                self.cleanup(outputURL)
//            default:
//                break
//            }
//        }
//    }
//
//    private func uploadVideoFileAndCleanup(_ url: URL) {
//        // Upload using Alamofire directly from disk path
//        // Example:
//        // AF.upload(url, to: "https://your-api.com/upload").response { response in ... }
//
//        print("Video ready to upload at: \(url.path)")
//        // Cleanup after upload success
//        cleanup(url)
//    }
//
//    private func cleanup(_ url: URL) {
//        try? FileManager.default.removeItem(at: url)
//    }
//}
//
//// MARK: - Container Tabs (Feed/Profile)
//
//private extension HomeVC {
//    func setupContentView() {
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(contentView)
//
//        NSLayoutConstraint.activate([
//            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: tabsView.topAnchor)
//        ])
//    }
//
//    func setupTabsView() {
//        tabsView.translatesAutoresizingMaskIntoConstraints = false
//        tabsView.backgroundColor = .secondarySystemBackground
//        view.addSubview(tabsView)
//
//        NSLayoutConstraint.activate([
//            tabsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tabsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tabsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            tabsView.heightAnchor.constraint(equalToConstant: 60)
//        ])
//    }
//
//    func setupTabButtons() {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.distribution = .fillEqually
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//        let feedBtn = makeTabButton(title: "Feed", tag: 0)
//        let profileBtn = makeTabButton(title: "Profile", tag: 1)
//
//        stack.addArrangedSubview(feedBtn)
//        stack.addArrangedSubview(profileBtn)
//
//        tabsView.addSubview(stack)
//
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: tabsView.topAnchor),
//            stack.bottomAnchor.constraint(equalTo: tabsView.bottomAnchor),
//            stack.leadingAnchor.constraint(equalTo: tabsView.leadingAnchor),
//            stack.trailingAnchor.constraint(equalTo: tabsView.trailingAnchor)
//        ])
//    }
//
//    func makeTabButton(title: String, tag: Int) -> UIButton {
//        let button = UIButton(type: .system)
//        button.setTitle(title, for: .normal)
//        button.tag = tag
//        button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
//        return button
//    }
//
//    @objc func tabTapped(_ sender: UIButton) {
//        switch sender.tag {
//        case 0: switchToVC(FeedVC())
//        case 1: switchToVC(ProfileVC())
//        default: break
//        }
//    }
//
//    func switchToVC(_ newVC: UIViewController) {
//        if let current = currentChildVC {
//            current.willMove(toParent: nil)
//            current.view.removeFromSuperview()
//            current.removeFromParent()
//        }
//
//        addChild(newVC)
//        contentView.addSubview(newVC.view)
//        newVC.view.frame = contentView.bounds
//        newVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        newVC.didMove(toParent: self)
//
//        currentChildVC = newVC
//    }
//}



import UIKit

class HomeVC: UIViewController {

    // MARK: - UI Components
    private let tableView = UITableView()
    private let segmentedControl = UISegmentedControl(items: ["Ingredients", "Prep", "Cook", "Serve"])

    // MARK: - Data & State
    private let sections = ["Ingredients", "Preparation", "Cooking", "Serving"]
    private var isManualScrolling = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white

        // Configure Segmented Control
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.addTarget(self, action: #selector(menuChanged), for: .valueChanged)
        view.addSubview(segmentedControl)

        // Configure TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        // Disable autoresizing masks for programmatic constraints
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Menu at the top
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),

            // TableView fills the rest of the screen
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func menuChanged(_ sender: UISegmentedControl) {
        isManualScrolling = true
        let indexPath = IndexPath(row: 0, section: sender.selectedSegmentIndex)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)

        // Reset the flag after the animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isManualScrolling = false
        }
    }
}

// MARK: - TableView Logic
extension HomeVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Step \(indexPath.row + 1) of \(sections[indexPath.section])"
        return cell
    }

    // This replaces the logic from your original 'didEndDisplaying'
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isManualScrolling else { return }

        // Find the index path at the top of the table (with a small buffer)
        let topPoint = CGPoint(x: 0, y: scrollView.contentOffset.y + 60)

        if let indexPath = tableView.indexPathForRow(at: topPoint) {
            if segmentedControl.selectedSegmentIndex != indexPath.section {
                segmentedControl.selectedSegmentIndex = indexPath.section
            }
        }
    }
}
