//
//  WQCameraManager.swift
//  CustomCamera
//
//  Created by kris.wang on 2020/7/2.
//  Copyright © 2020 kris.wang. All rights reserved.
//

import UIKit
import GPUImage
import AVFoundation


class WQCameraManager {

    var flashMode: CameraFlashMode = .off
    /// 通过调整焦距来实现视图放大缩小
    var videoScale: CGFloat = 1
    /// 相机比例
    var ratio: CameraRatio = .w16v9

    var camera: Camera?

    /// 开启相机
    func startCapturing() {

    }

    private func setupCamera() {

        do {
            camera = try Camera(sessionPreset:.hd1280x720, location:.backFacing)
            
//            self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
//              self.camera.horizontallyMirrorFrontFacingCamera = YES;
//              [self.camera addAudioInputsAndOutputs];
//              self.camera.delegate = self;
//              self.camera.frameRate = 30;
//
//              self.currentFilterHandler.source = self.camera;
        } catch {
            camera = nil
            print("Couldn't initialize camera with error: \(error)")
        }
    }

    /// 通过比例，计算出每一帧的尺寸大小
    var videoSize: CGSize {
        get {
            let originRect = CGRect(x: 0, y: 0, width: 720, height: 1280)
            let cropRect = self.cropRect(ratio: self.ratio)
            let size = CGSize(width: originRect.size.width * cropRect.size.width, height: originRect.size.height * cropRect.size.height)
            return size
        }
    }

    /// 通过比例，计算裁剪区域
    func cropRect(ratio: CameraRatio) -> CGRect {
        var rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        if (ratio == .w1v1) {
            let space = (16 - 9) / 16.0 // 竖直方向应该裁剪掉的空间
            rect = CGRect(x: 0, y: space / 2, width: 1, height: 1 - space)
        } else if (ratio == .w4v3) {
//            CGFloat space = (16.0 / 9 - 4.0 / 3) / (16.0 / 9); // 竖直方向应该裁剪掉的空间
//            rect = CGRectMake(0, space / 2, 1, 1 - space);
        } else if (ratio == .full) {
//            CGFloat currentRatio = SCREEN_HEIGHT / SCREEN_WIDTH;
//            if (currentRatio > 16.0 / 9.0) { // 需要在水平方向裁剪
//                CGFloat resultWidth = 16.0 / currentRatio;
//                CGFloat space = (9.0 - resultWidth) / 9.0;
//                rect = CGRectMake(space / 2, 0, 1 - space, 1);
//            } else { // 需要在竖直方向裁剪
//                CGFloat resultHeight = 9.0 * currentRatio;
//                CGFloat space = (16.0 - resultHeight) / 16.0;
//                rect = CGRectMake(0, space / 2, 1, 1 - space);
//            }
        }
        return rect
    }
}
