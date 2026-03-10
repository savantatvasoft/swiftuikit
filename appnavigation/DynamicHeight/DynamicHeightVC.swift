//
//  DynamicHeightVC.swift
//  appnavigation
//
//  Created by MACM72 on 09/03/26.
//

import UIKit


class DynamicHeightVC: UIViewController {

    @IBOutlet weak var textDescription: UILabel!
    var timer: Timer?

    let model = DescriptionModel()
    var observation: NSKeyValueObservation?

    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        //        observation = model.observe(\.text, options: [.new]) { [weak self] object, change in
        //            DispatchQueue.main.async {
        //                self?.textDescription.text = change.newValue
        //            }
        //        }


        //        observation = model.observe(\.text, options: [.new]) { [weak self] object, change in
        //            guard let newText = change.newValue else { return }
        //            guard let strongSelf = self else { return }
        //            Task { @MainActor in
        //                strongSelf.textDescription.text = newText
        //            }
        //        }
        observation = model.observe(\.text, options: [.new]) { [weak self] _, change in
            guard let newText = change.newValue else { return }
            let label = self?.textDescription // Capture only the label

            Task { @MainActor in
                label?.text = newText
            }
        }

        startUpdatingText()
    }

    func startUpdatingText() {
        // This runs on the Main Thread, but it is NON-BLOCKING
        //        Thread.sleep block thread and freeze UI
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            let descriptions = DummyDescription.allCases
            let text = descriptions[self.index % descriptions.count].value

            self.model.text = text
            self.index += 1
        }
        // Each thread has it's own RunLoop
        //        let newTimer = Timer(timeInterval: 3.0, repeats: true) { [weak self] _ in
        //            // Your update logic here
        //            guard let self = self else { return }
        //
        //            let descriptions = DummyDescription.allCases
        //            let text = descriptions[self.index % descriptions.count].value
        //
        //            self.model.text = text
        //            self.index += 1
        //        }
        //        // This tells the RunLoop to keep the timer running during scrolls
        //        RunLoop.current.add(newTimer, forMode: .common)
        //        self.timer = newTimer
    }

    deinit {
        // 1. Stop the Timer so it stops firing and is removed from the RunLoop
        timer?.invalidate()

        // 2. Invalidate the KVO observation to break the link with the model
        observation?.invalidate()

        print("DynamicHeightVC cleaned up and memory released.")
    }
}
