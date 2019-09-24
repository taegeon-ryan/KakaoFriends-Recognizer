//
//  ViewController.swift
//  kakaofriends
//
//  Created by 유태건 on 22/09/2019.
//  Copyright © 2019 pyimagesearch. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    // 캐릭터 이름과 신뢰도를 표시할 레이블을 생성
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Label"
        label.font = label.font.withSize(30)
        return label
    }()
    
    // 뷰가 로드되면 호출되는 메소드
    override func viewDidLoad() {
        // 부모 메소드 실행
        super.viewDidLoad()
        
        // 캡쳐 세션을 생성하고 레이블을 뷰에 등록
        setupCaptureSession()
        view.addSubview(label)
        setupLabel()
    }
    
    override func didReceiveMemoryWarning() {
        // 부모 메소드 실행
        super.didReceiveMemoryWarning()
        
        // 재생성되는 모든 리소스 폐기
    }
    
    func setupCaptureSession() {
        // 캡쳐 세션 생성
        let captureSession = AVCaptureSession()
        
        // 사용 가능한 카메라 장치 찾기
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        
        do {
            // 카메라 선택
            if let captureDevice = availableDevices.first {
                captureSession.addInput(try AVCaptureDeviceInput(device: captureDevice))
            }
        } catch {
            // 카메라를 사용할 수 없을 경우 오류 출력
            print(error.localizedDescription)
        }
        
        // 영상 출력을 설정하고 캡쳐 세션에 출력 영상을 등록
        let captureOutput = AVCaptureVideoDataOutput()
        captureSession.addOutput(captureOutput)
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        // 영상을 버퍼링한 다음 캡쳐 세션 시작
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
           // CoreML 모델 로드
           guard let model = try? VNCoreMLModel(for: kakao().model) else { return }
    
           // CoreML 모델 실행
           let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
    
               // 결과를 가져옴
               guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
               
               // 가장 높은 신뢰도를 가져옴
               guard let Observation = results.first else { return }
               
               // 텍스트 레이블을 생성
               let predclass = "\(Observation.identifier)"
               let predconfidence = String(format: "%.02f%", Observation.confidence * 100)
    
               // 텍스트를 설정
               DispatchQueue.main.async(execute: {
                   self.label.text = "\(predclass) \(predconfidence)"
               })
           }
           
           // Core Video 픽셀 버퍼를 생성
           guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
           
           // 요청을 실행
           try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
       }
    
    func setupLabel() {
        // 레이블을 가운데로 설정
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // 레이블을 바텀에서 50pt 만큼 위의 위치로 설정
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
}
