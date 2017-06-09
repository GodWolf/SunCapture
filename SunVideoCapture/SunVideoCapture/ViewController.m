//
//  ViewController.m
//  SunVideoCapture
//
//  Created by 孙兴祥 on 2017/6/9.
//  Copyright © 2017年 sunxiangxiang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic,strong) dispatch_queue_t captureQueue;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic,strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic,strong) AVCaptureAudioDataOutput *audioOutput;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUp];
}


- (void)setUp {
    
    _session = [[AVCaptureSession alloc] init];
    if([_session canSetSessionPreset:AVCaptureSessionPresetMedium]){
        _session.sessionPreset = AVCaptureSessionPresetMedium;
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    previewLayer.backgroundColor = [UIColor greenColor].CGColor;
    previewLayer.frame = self.view.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:previewLayer];
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    if([_session canAddInput:_videoInput]){
        [_session addInput:_videoInput];
    }
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    if([_session canAddInput:_audioInput]){
        [_session addInput:_audioInput];
    }
    
    _captureQueue = dispatch_queue_create("com.sun.capture", DISPATCH_QUEUE_SERIAL);
    
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    _videoOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
    _videoOutput.alwaysDiscardsLateVideoFrames = NO;
    [_videoOutput setSampleBufferDelegate:self queue:_captureQueue];
    if([_session canAddOutput:_videoOutput]){
        [_session addOutput:_videoOutput];
    }
    
    _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    [_audioOutput setSampleBufferDelegate:self queue:_captureQueue];
    if([_session canAddOutput:_audioOutput]){
        [_session addOutput:_audioOutput];
    }
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if(captureOutput == _videoOutput){
        
        CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        CIImage *sourceImage = [CIImage imageWithCVPixelBuffer:imageBuffer options:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if(_session){
        if(_session.isRunning == YES){
            [_session stopRunning];
        }else{
            [_session startRunning];
        }
    }
}


@end
