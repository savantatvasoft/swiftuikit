//
//  PollViewController.swift
//  appnavigation
//
//  Created by MACM72 on 24/02/26.
//

import UIKit

class PollViewController: BaseQuizViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var questionCount: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nxtBtn: UIView!

    let options = ["Option A", "Option B", "Option C", "Option D","Option A", "Option B", "Option C", "Option D","Option A", "Option B", "Option C", "Option D","Option A", "Option B", "Option C", "Option D","Option A", "Option B", "Option C", "Option D","Option A", "Option B", "Option C", "Option D"]

    override func viewDidLoad() {
        super.viewDidLoad()

        mainStackView.addArrangedSubview(mainView)
        view.addSubview(nxtBtn)

        startCountdown(durationInSeconds: 120)
        setupTableView()
        setupButtonActions()
        questionLabel.text = "Which language is used for iOS Development?"
        questionCount.text = "Question 1 of 25"
    }

    override func timeUp() {
        // Show "Poll Ended" alert
        print("Show Poll Ended alert")
    }

    private func setupTableView() {
        tableView.dataSource =  self
        tableView.delegate = self
        tableView.separatorStyle = .none

        let nib = UINib(nibName: "OptionCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "OptionCell")
    }

    private func setupButtonActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleNextTap))
        nxtBtn.addGestureRecognizer(tap)
        nxtBtn.isUserInteractionEnabled = true
    }

    @objc private func handleNextTap() {
        print("Next button tapped! Action triggered on Touch Up (Apple Standard).")
        // Trigger your next question logic here
    }
}


// MARK: TableView Methods

extension PollViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as! OptionCell
        cell.optionText.text = options[indexPath.section]
        cell.successImage.isHidden = true

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOptionIndex = indexPath.section
        print("User selected option number: \(selectedOptionIndex)")
        let cell = tableView.cellForRow(at: indexPath) as? OptionCell
        cell?.successImage.isHidden = false
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
