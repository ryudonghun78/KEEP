import UIKit
import AVFoundation
import QuartzCore

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var previewImage: UIButton!
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBAction func imageClick(_ sender: Any) {
    }
    
    var session = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    let notification = NotificationCenter.default
    var segueImage : UIImage?
    //캡쳐델리게이트 설정
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(
            forJPEGSampleBuffer: photoSampleBuffer!,
            previewPhotoSampleBuffer: previewPhotoSampleBuffer)
        if let data = photoData {
            if let stillImage = UIImage(data: data) {
                UIImageWriteToSavedPhotosAlbum(stillImage,self,nil,nil)
                segueImage = stillImage
                capturedImage.image = stillImage
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "captureSegue"{
            if let destination = segue.destination as? RecordViewController{
                destination.imageForSegue = segueImage
            }
            if let destination = segue.destination as? PreviewViewController{
                destination.imageForSegue = segueImage
            }
        }
    }
    func setupInputOutput(){
        session.sessionPreset = AVCaptureSession.Preset.photo
        do {
            let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                                 for:AVMediaType.video,
                                                 position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            if session.canAddInput(input){
                session.addInput(input)
            } else {
                print("세션에 입력을 추가할 수 없습니다.")
                return
            }
        } catch let error as NSError {
            print("카메라가 없습니다 \(error)")
            return
        }
        if session.canAddOutput(photoOutput){
            session.addOutput(photoOutput)
        } else{
            print("세션에 출력을 추가할 수 없습니다.")
            return
        }
    }
    func setPreviewLayer(){
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        let videoLayer = previewLayer
        videoLayer.frame = view.bounds
        videoLayer.masksToBounds = true
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewView.layer.addSublayer(videoLayer)
    }
    //이미지 캡쳐 설정
    @IBAction func takePhoto(_ sender: Any) {
        let captureSetting = AVCapturePhotoSettings()
        captureSetting.flashMode = .auto
        captureSetting.isAutoStillImageStabilizationEnabled = true
        captureSetting.isHighResolutionPhotoEnabled = false
        photoOutput.capturePhoto(with: captureSetting, delegate: self as! AVCapturePhotoCaptureDelegate)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        capturedImage.layer.cornerRadius=20
        capturedImage.layer.masksToBounds = true
        capturedImage.layer.borderWidth=2.0
        if session.isRunning{
            return
        }
        setupInputOutput()
        setPreviewLayer()
        session.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
