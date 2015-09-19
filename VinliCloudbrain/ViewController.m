//
//  ViewController.m
//  VinliCloudbrain
//
//  Created by Dvid Silva on 9/19/15.
//  Copyright © 2015 hackership. All rights reserved.
//

#import "ViewController.h"

#import <VinliBluetooth/VinliBluetooth.h>
#import <VinliNet/VLSessionManager.h>


@interface ViewController () <VNLDeviceObserving>

@property (nonatomic, strong) VNLDeviceManager* deviceManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    //[super viewDidAppear:<#animated#>];
    [[VLSessionManager sharedManager] loginWithCompletion:^(VLSession *session, NSError *error)
    {
        if (!error) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

