//
//  ShowRoadViewController.m
//  YSRun
//
//  Created by youxin on 2017/9/8.
//  Copyright © 2017年 msq. All rights reserved.
//

#import "ShowRoadViewController.h"

@interface ShowRoadViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lalonLa;

@end

@implementation ShowRoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"******************%f--%f",self.coordd.latitude,self.coordd.longitude);
    
    self.lalonLa.text = [NSString stringWithFormat:@"经度：%f--纬度：%f",self.coordd.longitude,self.coordd.latitude];
    
}
- (IBAction)backBtnClickAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
