//
//  ViewController.swift
//  Pop Cat
//
//  Created by 문종식 on 2021/02/07.
//

import UIKit
import AVFoundation
//import Spring
//import Then

class ViewController: UIViewController, UIGestureRecognizerDelegate, AVAudioPlayerDelegate {
    
    // MARK: - Properties
    var str = "Pop"
    var isShowBackground = false
    var isRight = true
    var audioPlayerList: Array<AVAudioPlayer> = [AVAudioPlayer(),]
    
    // MARK: - IBOutlet
    
    @IBOutlet var backgroudButton: UIButton!
    @IBOutlet var changeStringButton: UIButton!
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - Methods
    func setAttributeOfTheme() {
        let isDark = (self.traitCollection.userInterfaceStyle == .dark)
        self.backgroudButton.tintColor = isDark ? .white : .black
        self.changeStringButton.tintColor = isDark ? .white : .black
        self.settingButton.tintColor = isDark ? .white : .black
        self.settingButton.setImage(UIImage.init(systemName: isDark ? "sun.max.fill" : "moon.fill"), for: .normal)
    }
    
    func addGesture() {
        let touchDown = UILongPressGestureRecognizer(target: self, action: #selector(didTouch(_:)))
        touchDown.minimumPressDuration = 0
        self.imageView.addGestureRecognizer(touchDown)
    }
    
    func playSound() {
        let path = Bundle.main.path(forResource: "popSound.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayerList.append(audioPlayer)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("couldn't load the file")
        }
    }
    
//    func popString() {
//        weak var springLabel: SpringLabel? = SpringLabel().then {
//            $0.text = str
//            $0.textColor = (self.traitCollection.userInterfaceStyle == .dark) ? .white : .black
//            $0.font = UIFont(name: "BMJUA_otf", size: 0)
//            $0.font = $0.font.withSize(CGFloat.random(in: 10...30))
//            $0.animation = "fadeInUp"
//            $0.curve = "easeIn"
//            $0.duration = 1.0
//            $0.damping = 0.2
//            $0.velocity = 0.3
//            $0.rotate = CGFloat.random(in: 0...5 )
//            $0.frame = CGRect(x: view.frame.width/2, y: 40, width: 100, height: 100)
//            view.addSubview($0)
//        }
        
//        springLabel?.animateNext {
//            springLabel?.animation = "slideUp"
//            springLabel?.curve = "spring"
//        }
        
//        springLabel?.animateNext {
//
//            springLabel?.removeFromSuperview()
//
//            springLabel = nil
//            print(self.view.subviews)
//        }
//
//    }
    
    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Dispose of any resources that can be recreated.
     }
    
    // MARK: - IBAction
    
    // 배경 표시
    @IBAction func showBackground(_ sender: UIButton) {
        self.isShowBackground = !self.isShowBackground
        self.imageView.image = UIImage(named: "pop_on" + (self.isShowBackground ? "_background" : "") )
        backgroudButton.setImage(self.isShowBackground
                                    ? UIImage.init(systemName: "person.circle.fill")
                                    : UIImage.init(systemName: "person.circle"),
                                 for: .normal)
    }
    
    // 라벨 변경
    @IBAction func changeLabel(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Change Label", message: nil, preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField{ textField in
            textField.text = self.str
            textField.placeholder = "Input Text"
        }
        
        let acceptAction = UIAlertAction(title: "Change", style: UIAlertAction.Style.default , handler: { _ in
            self.str = alertController.textFields?.first?.text ?? ""
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel , handler: nil)
        
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion:{})
    }
    
    // 세팅
    @IBAction func goToSettingView(_ sender: UIButton) {
        self.overrideUserInterfaceStyle = (self.traitCollection.userInterfaceStyle == .dark) ? .light : .dark
        self.setAttributeOfTheme()
    }
    
    // MARK: - Object Function
    @objc func didTouch(_ sender: UILongPressGestureRecognizer) {
        let x = sender.location(in: self.imageView).x
        self.isRight = (x > view.frame.width / 2)
        
        let image: UIImage!
        var imageName = ""
        imageName += (sender.state == .ended ? "pop_on" : "pop_off")
        imageName += (self.isRight ? "" : "_left")
        imageName += (self.isShowBackground ? "_background" : "")
        image = UIImage(named: imageName)
        
        if sender.state == .ended {
            self.playSound()
//            self.popString()
        }
        
        self.imageView.image = image
    }
    
    // MARK: - Delegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.audioPlayerList.remove(at: self.audioPlayerList.lastIndex(of: player) ?? 0)
        
//        print(self.audioPlayerList.count)
    }
    
    // MARK: - Life Cyecle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAttributeOfTheme()
        self.addGesture()
    }
}
