//
//  ViewController.swift
//  CustomCamera
//
//  Created by kris.wang on 2020/7/2.
//  Copyright © 2020 kris.wang. All rights reserved.
//

import UIKit
import GPUImage
import AVFoundation
import QuartzCore
import SnapKit

class ViewController: UIViewController {
    
    var filterView: RenderView?
    var videoCamera: Camera?
    
    var filterOperation: FilterOperationInterface?
    var filterOperationTwo = filterOperations[3]
    
   
    
    var sliderOne: UISlider!
    var sliderTwo: UISlider!
    
    var choseFilterV: WQChoseFilterOperationView!
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureView()
        addConstraints()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let videoCamera = videoCamera {
            videoCamera.stopCapture()
            videoCamera.removeAllTargets()
            //            blendImage?.removeAllTargets()
        }
        
        super.viewWillDisappear(animated)
    }
    
    func updateFilter(index: Int) {
        currentIndex = index
//        filterView?.removeFromSuperview()
//        filterView = RenderView(frame: CGRect(x: 0, y: 100, width: 300, height: 300))
//        view.addSubview(filterView!)
        guard let videoCamera = videoCamera, let view = self.filterView  else {
            return
        }
        videoCamera.removeAllTargets()
//        videoCamera.stopCapture()
        
        let ddd = filterOperations[index].filter
//        videoCamera --> ddd
        videoCamera.addTarget(ddd)
        
        ddd.addTarget(view)
        
        
//        videoCamera.addTarget(filterOperations[index].filter)
//        filterOperations[index].filter.addTarget(view)
         //--> view
        
        
//        videoCamera.removeAllTargets()
        
//        let currentFilterConfiguration = filterOperations[index]
//        switch currentFilterConfiguration.filterOperationType {
//        case .singleInput:
//            videoCamera.addTarget(currentFilterConfiguration.filter)
//            currentFilterConfiguration.filter.addTarget(view)
//        case .blend:
//            videoCamera.addTarget(currentFilterConfiguration.filter)
////            self.blendImage = PictureInput(imageName:blendImageName)
////            self.blendImage?.addTarget(currentFilterConfiguration.filter)
////            self.blendImage?.processImage()
//            currentFilterConfiguration.filter.addTarget(view)
//        case let .custom(filterSetupFunction:setupFunction):
//            currentFilterConfiguration.configureCustomFilter(setupFunction(videoCamera, currentFilterConfiguration.filter, view))
//        }
//        videoCamera.startCapture()
    }
    
    func setup() {
        filterView = RenderView(frame: CGRect(x: 0, y: 100, width: 300, height: 300))
        view.addSubview(filterView!)
        filterOperation = filterOperations[1]
        do {
            videoCamera = try Camera(sessionPreset:.vga640x480, location:.backFacing)
            videoCamera!.runBenchmark = true
        } catch {
            videoCamera = nil
            print("Couldn't initialize camera with error: \(error)")
        }
        setupSlider()
        setupChoseFilterV()
    }
    
    func setupChoseFilterV() {
        choseFilterV = WQChoseFilterOperationView(frame: CGRect.zero)
        choseFilterV.didSelectFilter = { [weak self] (index) in
            self?.updateFilter(index: index)
        }
        choseFilterV.dataArr = filterOperations as! [WQChoseFilterOperationViewDataProtocol]
        view.addSubview(choseFilterV)
    }
    
    let blendFilter = ExposureAdjustment()
    let f2 = ContrastAdjustment()
    func configureView() {
        guard let videoCamera = videoCamera else {
            let errorAlertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: "Couldn't initialize camera", preferredStyle: .alert)
            errorAlertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
            self.present(errorAlertController, animated: true, completion: nil)
            return
        }
        
        if let currentFilterConfiguration = self.filterOperation {
            self.title = currentFilterConfiguration.titleName
            currentFilterConfiguration.updateBasedOnSliderValue(0.3)
            // Configure the filter chain, ending with the view
            if let view = self.filterView {
                switch currentFilterConfiguration.filterOperationType {
                case .singleInput:
           break
                    


                    
                case .blend:
                    videoCamera.addTarget(currentFilterConfiguration.filter)
//                    self.blendImage = PictureInput(imageName:blendImageName)
//                    self.blendImage?.addTarget(currentFilterConfiguration.filter)
//                    self.blendImage?.processImage()
                    currentFilterConfiguration.filter.addTarget(view)
                case let .custom(filterSetupFunction:setupFunction):
                    currentFilterConfiguration.configureCustomFilter(setupFunction(videoCamera, currentFilterConfiguration.filter, view))
                }
                
                
                //                filterOperationType:.custom(filterSetupFunction:{(camera, filter, outputView) in
                //                    let castFilter = filter as! GlassSphereRefraction
                //
                //                    // Provide a blurred image for a cool-looking background
                //
                //
                let oneF = currentFilterConfiguration.filter
                
                blendFilter.exposure = 0.8
                
                
                f2.contrast = 0.3

                
                videoCamera --> blendFilter  ///--> blendFilter --> outputView
                //                    camera --> castFilter --> blendFilter
                //
                //                    return blendFilter
                //                })
                
                blendFilter.addTarget(f2)
                f2.addTarget(self.filterView!)
//                videoCamera.addTarget(blendFilter)
//                blendFilter.addTarget(view)
                let twoF = filterOperationTwo.filter
//                videoCamera --> oneF --> twoF --> self.filterView
//                videoCamera.addTarget(oneF)
//                videoCamera.addTarget(twoF)
                
                
                
                
                
//                videoCamera.addTarget(currentFilterConfiguration.filter)
//                currentFilterConfiguration.filter.addTarget(self.filterView!)
                videoCamera.startCapture()
            }
            
 
            
        }
    }
    
    
    func setupSlider() {
        sliderOne = UISlider(frame: CGRect(x: 0, y: 420, width: 300, height: 30))
        sliderOne.minimumValue = 0
        sliderOne.maximumValue = 1
        sliderOne.value = 0.2
        sliderOne.tag = 1001
        sliderOne.addTarget(self, action: #selector(change(slider:)), for: .valueChanged)
        view.addSubview(sliderOne)
        
        sliderTwo = UISlider(frame: CGRect(x: 0, y: 520, width: 300, height: 30))
        sliderTwo.minimumValue = 0
        sliderTwo.maximumValue = 1
        sliderTwo.value = 0.2
        sliderTwo.tag = 1002
        sliderTwo.addTarget(self, action: #selector(change(slider:)), for: .valueChanged)
        view.addSubview(sliderTwo)
    }
    
    @objc func change(slider: UISlider) {
        filterOperations[currentIndex].updateBasedOnSliderValue(Float(slider.value))
        
        
        if slider.tag == 1001 {
            blendFilter.exposure = Float(slider.value)
            if let currentFilterConfiguration = self.filterOperation {
                switch (currentFilterConfiguration.sliderConfiguration) {
                    case .enabled(_, _, _): currentFilterConfiguration.updateBasedOnSliderValue(Float(slider.value))
                    case .disabled: break
                }
            }
            print("slider1.value = %d",sliderOne.value)
        } else {
            f2.contrast = Float(slider.value)
            filterOperationTwo.updateBasedOnSliderValue(Float(slider.value))
            print("slider2.value = %d",sliderOne.value)
        }
           
    }
}


extension ViewController {
    func addConstraints() {
        choseFilterV.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
    }
}
