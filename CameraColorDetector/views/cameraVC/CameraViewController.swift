import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var color1: UILabel!
    @IBOutlet private weak var color2: UILabel!
    @IBOutlet private weak var color3: UILabel!
    @IBOutlet private weak var color4: UILabel!
    @IBOutlet private weak var color5: UILabel!
    
    // MARK: - Variables
    
    var captureSession: AVCaptureSession?
    let viewModel = CameraViewModel()
    
    // MARK: - Life cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermissions()
    }
    
    // MARK: - private func
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            handleNotDeterminedPermission ()
        case .restricted, .denied:
            showAlert(for: .changePermissionsPopUp)
        @unknown default:
            showAlert(for: .changePermissionsPopUp)
        }
    }
    
    private func handleNotDeterminedPermission () {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isApproved in
            guard isApproved else {
                self?.showAlert(for: .changePermissionsPopUp)
                return
            }
            DispatchQueue.main.async {
                self?.setupCamera()
            }
        }
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        
        captureSession.sessionPreset = .high
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            showAlert(for: .cameraError)
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: Strings.VideoQueue))
        captureSession.addOutput(videoOutput)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .landscapeRight // For simplize things
        
        view.layer.addSublayer(previewLayer)
        previewLayer.zPosition = -1 // Put it in background with views zPosition order
        previewLayer.frame = view.layer.bounds
        
        captureSession.startRunning()
    }
    
    private func updateUIColorViews(_ sampleBuffer: CMSampleBuffer) {
        
        let colors = viewModel.getColors(sampleBuffer)
        
        if colors.isEmpty && viewModel.shouldAlertOnEmptyArray() {
            showAlert(for: .emptyArray)
        }
        
        // Will consider also how many returns
        for (index, color) in colors.prefix(5).enumerated() {
            
            let formattedPercentage = String(format: "%.2f", color.percentage)
            let colorLabelText = "R:\(color.red) G:\(color.green) B:\(color.blue)\nPercentage: \(formattedPercentage)%"
            
            DispatchQueue.main.async { [weak self] in
                switch index {
                case 0:
                    self?.color1.text = colorLabelText
                    self?.viewModel.changeFrequency(for: .oscillator1, frequency: color.getFrequency())
                case 1:
                    self?.color2.text = colorLabelText
                    self?.viewModel.changeFrequency(for: .oscillator2, frequency: color.getFrequency())
                case 2:
                    self?.color3.text = colorLabelText
                    self?.viewModel.changeFrequency(for: .oscillator3, frequency: color.getFrequency())
                case 3:
                    self?.color4.text = colorLabelText
                    self?.viewModel.changeFrequency(for: .oscillator4, frequency: color.getFrequency())
                case 4:
                    self?.color5.text = colorLabelText
                    self?.viewModel.changeFrequency(for: .oscillator5, frequency: color.getFrequency())
                default:
                    break
                }
            }
        }
    }
    
    private func showAlert(for alertType: Alerts) {
        let alert = viewModel.getAlert(for: alertType)
        present(alert, animated: true, completion: nil)
    }
}

    // MARK: - Video Data Output Delegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        updateUIColorViews(sampleBuffer)
    }
}
