////
////  BaseQuizViewController.swift
////  appnavigation
////
////  Created by MACM72 on 24/02/26.
////
//

import UIKit

class BaseQuizViewController: UIViewController {

    var isScrollingEnabled: Bool = true
    var showNaviagtionBar: Bool = false

    // MARK: - UI Elements
    let headerContainer = UIView()
    let header = HeaderView()

    let scrollView = UIScrollView()
    let scrollContentView = UIView()

    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    // MARK: - Timer Variables
    private var countdownTimer: Timer?
    private var secondsRemaining: Int = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainBackground")
        self.navigationItem.hidesBackButton = true

        setupBackButton()
        setupHierarchy()
        setupConstraints()
        handleColorWhileTimerStart(false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(showNaviagtionBar, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
        self.navigationController?.setNavigationBarHidden(showNaviagtionBar, animated: animated)
    }


    // MARK: - UI Setup
    private func setupHierarchy() {
        view.addSubview(headerContainer)
        headerContainer.addSubview(header)

        // Only add scrollview to hierarchy if enabled
        if isScrollingEnabled {
            view.addSubview(scrollView)
            scrollView.addSubview(scrollContentView)
            scrollContentView.addSubview(mainStackView)
        } else {
            view.addSubview(mainStackView)
        }

        [headerContainer, header, scrollView, scrollContentView, mainStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 120),

            header.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            header.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            header.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 40)
        ])

        if isScrollingEnabled {
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

                mainStackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20),
                mainStackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
                mainStackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
                mainStackView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 10),
                mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }

    // MARK: - Timer Logic (Keep as is)
    func startCountdown(durationInSeconds: Int) {
        secondsRemaining = durationInSeconds
        header.timerText.text = timeFormatted(secondsRemaining)
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        handleColorWhileTimerStart(true)
    }

    @objc private func updateTimer() {
        if secondsRemaining > 0 {
            secondsRemaining -= 1
            header.timerText.text = timeFormatted(secondsRemaining)
        } else {
            stopTimer()
            timeUp()
        }
    }

    func stopTimer() { countdownTimer?.invalidate() }

    func timeUp() {
        handleColorWhileTimerStart(false)
        print("Time is up!")
    }

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func handleColorWhileTimerStart(_ active: Bool) {
        let color: UIColor = active ? .white : .systemGray6
        header.timerText.textColor = color
        header.timerImage.tintColor = color
    }

    func updateHeaderProgress(current: Int, total: Int) {
        let progressValue = Float(current) / Float(total)
        header.progressView.setProgress(progressValue, animated: true)
    }

    private func setupBackButton() {
        header.backButtonView.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(handleBackTap))
        header.backButtonView.addGestureRecognizer(backTap)
    }

    @objc func handleBackTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.header.backButtonView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.header.backButtonView.transform = .identity
            }
            self.navigationController?.popViewController(animated: true)
        }
    }

}
