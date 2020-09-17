//
//  ViewController.swift
//  VideoChat
//
//  Created by Сергей Шестаков on 07.09.2020.
//  Copyright © 2020 Сергей Шестаков. All rights reserved.
//

import UIKit
import AgoraRtcKit

class ChatViewController: UIViewController {
    
    // MARK: - Subviews
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var microMuteButton: UIButton!
    @IBOutlet weak var offVideoButton: UIButton!
    @IBOutlet weak var muteLocalVideoButton: UIButton!
    @IBOutlet weak var muteSoundButton: UIButton!
    @IBOutlet weak var remoteButtonPanelView: UIView!
    @IBOutlet weak var localButtonPanelView: UIView!
    @IBOutlet weak var muteRemoteVideoButton: UIButton!
    @IBOutlet weak var reverseCameraButton: UIButton!
    
    // MARK: - Private object
    private var agoraKit: AgoraRtcEngineKit?
    
    // MARK: - Actions
    @IBAction func didTap(_ sender: Any) {
        leaveChannel()
        if let vcCall = storyboard?.instantiateViewController(withIdentifier: "CallViewController") as? CallViewController {
            vcCall.modalPresentationStyle = .fullScreen
            present(vcCall, animated: false, completion: nil)
        }
    }
    @IBAction func muteLocalVideo(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit?.muteLocalVideoStream(sender.isSelected)
        localView.isHidden = sender.isSelected
        if sender.isSelected {
            muteLocalVideoButton.backgroundColor = .red
        } else {
            muteLocalVideoButton.backgroundColor = .none
        }
    }
    @IBAction func switchCamera(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit?.switchCamera()
    }
    @IBAction func muteRemoteVideo(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit?.muteAllRemoteVideoStreams(sender.isSelected)
        remoteView.isHidden = sender.isSelected
        if sender.isSelected {
            muteRemoteVideoButton.backgroundColor = .red
        } else {
            muteRemoteVideoButton.backgroundColor = .none
        }
    }
    @IBAction func muteSound(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit?.muteAllRemoteAudioStreams(sender.isSelected)
        if sender.isSelected {
            muteSoundButton.backgroundColor = .red
        } else {
            muteSoundButton.backgroundColor = .none
        }
    }
    @IBAction func muteLocalMicro(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        agoraKit?.muteLocalAudioStream(sender.isSelected)
        if sender.isSelected {
            microMuteButton.backgroundColor = .red
        } else {
            microMuteButton.backgroundColor = .none
        }
        
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalizeAgoraEngine()
        setupLocalVideo()
        joinChannel()
        configureView()
    }
    
    // MARK: - Private method
    private func configureView() {
        localView.layer.cornerRadius = 20
        localView.layer.maskedCorners = [.layerMinXMinYCorner]
        remoteButtonPanelView.layer.cornerRadius = 20
        remoteButtonPanelView.layer.maskedCorners = [.layerMaxXMinYCorner]
        remoteView.layer.cornerRadius = 20
        remoteView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        localButtonPanelView.layer.cornerRadius = 20
        localButtonPanelView.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    private func initalizeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "0dae1407a8f8492ba648b7e72e5580e1", delegate: self)
    }
    private func setupLocalVideo() {
        agoraKit?.enableVideo()
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = localView
        videoCanvas.renderMode = .hidden
        remoteView.bringSubviewToFront(localView)
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    private func joinChannel() {
        agoraKit?.joinChannel(byToken: "0060dae1407a8f8492ba648b7e72e5580e1IACa5BXGfFbxegT+cljdZMZOB3+CNiqNt/lCnTzLsjmPGDLRTXgAAAAAEAAQz9mb0W9kXwEAAQDRb2Rf", channelId: "Test", info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
        })
    }
    private func leaveChannel() {
        agoraKit?.leaveChannel(nil)
        localView.isHidden = true
        remoteView.isHidden = true
    }
}

// MARK: - AgoraRtcEngineDelegate
extension ChatViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteView
        videoCanvas.renderMode = .hidden
        //agoraKit?.enableWebSdkInteroperability(true)
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}
