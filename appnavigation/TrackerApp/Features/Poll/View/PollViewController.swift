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

    var durationInSeconds:Int = 10

    let viewModel = PollViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        header.backButtonView.isHidden = true
        let topSpacer = UIView()
        topSpacer.translatesAutoresizingMaskIntoConstraints = false
        topSpacer.heightAnchor.constraint(equalToConstant: 120).isActive = true

        mainStackView.insertArrangedSubview(topSpacer, at: 0)
        mainStackView.addArrangedSubview(mainView)
        view.addSubview(nxtBtn)

        tableView.isHidden = true
        questionLabel.isHidden = true
        questionCount.isHidden = true
        nxtBtn.isHidden = true

        let loader = UIActivityIndicatorView(style: .large)
        loader.center = view.center
        view.addSubview(loader)
        loader.startAnimating()

        viewModel.fetchQuestions { [weak self] in
            loader.stopAnimating()
            self?.tableView.isHidden = false
            self?.updateUI()
            self?.setupTableView()
            self?.setupButtonActions()
            self?.questionLabel.isHidden = false
            self?.questionCount.isHidden = false
            self?.nxtBtn.isHidden = false
        }


    }

    

    override func timeUp() {
        moveToNext()
    }

    @objc override func handleBackTap() {
        print("handleBackTap")
        viewModel.moveToPreviousQuestion()
        updateUI()
    }

    private func setupTableView() {
        tableView.dataSource =  self
        tableView.delegate = self
        tableView.separatorStyle = .none

        let nib = UINib(nibName: "OptionCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "OptionCell")
    }

    private func updateUI( _ resetCountDown: Bool? = true) {
        questionLabel.text = viewModel.currentQuestion.questionText
        questionCount.text = viewModel.questionProgressText

        updateHeaderProgress(
            current: viewModel.currentQuestionIndex + 1,
            total: viewModel.totalQuestions
        )

        if resetCountDown ?? true {
            header.backButtonView.isHidden = viewModel.currentQuestionIndex > 0 ? false : true
            startCountdown(durationInSeconds: durationInSeconds)
        }

        UIView.animate(withDuration: 0.2) {
            self.nxtBtn.alpha = self.viewModel.isNextButtonEnabled ? 1.0 : 0.5
            self.nxtBtn.isUserInteractionEnabled = self.viewModel.isNextButtonEnabled
        }
        tableView.reloadData()
    }

    private func setupButtonActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleNextTap))
        nxtBtn.addGestureRecognizer(tap)
        nxtBtn.isUserInteractionEnabled = true
    }

    @objc private func handleNextTap() {
        DispatchQueue.main.async {
            self.moveToNext()
        }
//        DispatchQueue.global().async {
//            for _ in 0...10_000_000 {
//                print("Processing...")
//            }
//            DispatchQueue.main.async {
//                self.moveToNext()
//            }
//        }

    }

    func moveToNext() {
        if viewModel.moveToNextQuestion() {
            updateUI()
        } else {
            print("Poll Ended")
        }
    }
}


// MARK: TableView Methods

extension PollViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.currentQuestion.options.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as! OptionCell

        let optionText = viewModel.currentQuestion.options[indexPath.section]
        cell.optionText.text = "\(indexPath.section + 1). \(optionText)"
        cell.successImage.isHidden = !viewModel.selectedIndices.contains(indexPath.section)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleSelection(at: indexPath.section)
        updateUI(false)
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
