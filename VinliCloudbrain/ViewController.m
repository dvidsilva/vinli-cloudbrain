//
//  ViewController.m
//  VinliCloudbrain
//
//  Created by Dvid Silva on 9/19/15.
//  Copyright © 2015 hackership. All rights reserved.
//

#import "ViewController.h"

#import <VinliBluetooth/VinliBluetooth.h>
#import <VinliNet/VinliSDK.h>
#import <VinliNet/VLSessionManager.h>

// https://gist.github.com/andrewwells/dd78929a20b6ff9b32d8
// device_lk3b15m@vin.li  / 123123

@interface ViewController () <VNLDeviceObserving>

@property (nonatomic, strong) VNLDeviceManager* deviceManager;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    VLService *vlService = [[VLService alloc] init];

    [vlService getDevicesOnSuccess:^(VLDevicePager *devicePager, NSHTTPURLResponse *response) {
        NSLog(@"getDevicesOnSucces, %@", devicePager.description);
    } onFailure:^(NSError *error, NSHTTPURLResponse *response, NSString *bodyString) {
        NSLog(@"onError bodyString %@", bodyString);
    }];


    [[VLSessionManager sharedManager] loginWithCompletion:^(VLSession *session, NSError *error)
    {
        if (!error) {
            [vlService useSession:session];
            self.deviceManager = [[VNLDeviceManager alloc] initWithAccessToken:session.accessToken];
            self.deviceManager.deviceObserver = self;
        }
    }];
}

- (void)deviceManagerDidInitialize:(VNLDeviceManager *)deviceManager
{
    [deviceManager scanForDevices];
}

- (void)device:(VNLDevice *)device updatedPid:(VNLPID *)pid forProperty:(NSString *)property
{
    if ([property isEqualToString:VNLPropertyVehicleSpeed])
    {
        self.speedLabel.text = [NSString stringWithFormat:@"%@ %@", pid.rawValue, pid.units];
        NSLog(@"self.speedLabel.text ");
    }
}

- (void)deviceManager:(VNLDeviceManager *)deviceManager didConnectDevice:(VNLDevice *)device {
    NSLog(@"didConnectDevice %@", device.identifier);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

