//
//  PointViewController.m
//  YSRun
//
//  Created by youxin on 2017/9/7.
//  Copyright © 2017年 msq. All rights reserved.
//

#import "PointViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "AnnotaionP.h"


@interface PointViewController ()<MAMapViewDelegate>{
  NSMutableDictionary *data;
    AnnotaionP *annotationp;
}

@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation PointViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //将获取的新坐标居中
    //[_mapView setCenterCoordinate:self.currentUL.coordinate animated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //假数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"position" ofType:@"plist"];
    data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //时间

    
    //地图初始化
    self.mapView = [[MAMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mapView.backgroundColor = [UIColor whiteColor];
    self.mapView.delegate = self;
    //设置定位精度
    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
    //设置定位距离
    _mapView.distanceFilter = 1.0f;
    //普通样式
    _mapView.mapType = MAMapTypeStandard;
    //地图跟着位置移动
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    //设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.showsCompass= YES;
    //设置指南针位置
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22);
    //设置成NO表示不显示比例尺；YES表示显示比例尺
    _mapView.showsScale= YES;
    //设置比例尺位置
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);
    //开启定位
    _mapView.showsUserLocation = YES;
    //缩放等级
    [_mapView setZoomLevel:18 animated:YES];
    
    //防止系统自动杀掉定位 -- 后台定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.allowsBackgroundLocationUpdates = YES;
    [self.view addSubview:self.mapView];
    
    UIButton *btn =[UIButton  buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(20, 60, 50, 50);
    [btn setTitle:@"返回" forState:(UIControlStateNormal)];
    [self.view addSubview:btn];
           btn.backgroundColor = [UIColor colorWithRed:4 green:181 blue:108 alpha:1];
    btn.backgroundColor =[UIColor redColor];
    [btn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    
    //创建坐标
    
//    CLLocationCoordinate2D coor ;
//    coor.latitude = 22.984429;
//    coor.longitude = 113.717890;
//    
//    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//    
//    pointAnnotation.coordinate = coor;
//    //设置地图的定位中心点坐标
//    self.mapView.centerCoordinate = coor;
//    //将点添加到地图上，即所谓的大头针
//    [self.mapView addAnnotation:pointAnnotation];
    
}
-(void)back{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    //userLocation 就是用户当前的位置信息，通过userLocation 可以获取当前的经纬度信息及详细的地理位置信息，方法如下：
    
    //创建一个经纬度点：
//    MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
//    //设置点的经纬度
//    //point.coordinate = 22.984429;
//    CLLocation *currentLocation = [[CLLocation alloc]initWithLatitude:22.984429 longitude:113.717890];
//    
//    // 初始化编码器
//    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        //获取当前城市位置信息，其中CLPlacemark包括name、thoroughfare、subThoroughfare、locality、subLocality等详细信息
//        CLPlacemark *mark = [placemarks lastObject];
//        NSString *cityName = mark.locality;
//                NSLog(@"城市 - %@", cityName);
//       // self.currentCity  = cityName;
//    }];
//    [self.mapView addAnnotation:point];
    
        for (int i = 1;i <= data.count;i ++) {
            NSString* key = [NSString stringWithFormat:@"%d",i];
    
            NSMutableDictionary *positionDic = [data valueForKey:key];
           // NSLog(@"%@",positionDic);
            //添加描点
    
//            MAPointAnnotation *annotation = [[MAPointAnnotation alloc]init];
              annotationp = [[AnnotaionP alloc]init];
            annotationp.title = [positionDic valueForKey:@"name"];
            annotationp.subtitle = [positionDic valueForKey:@"address"];
            NSString* lat = [positionDic valueForKey:@"lat"] ;
            NSString* lon = [positionDic valueForKey:@"lon"];
    
            CLLocationCoordinate2D coordinate = {[lat floatValue],[lon floatValue]};
    
            annotationp.coordinate = coordinate;
            annotationp.tagg = 1000+i;
    
            [_mapView addAnnotation:annotationp];
        }
    
    
}
//添加大头针

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    
    //大头针标注
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {//判断是否是自己的定位气泡，如果是自己的定位气泡，不做任何设置，显示为蓝点，如果不是自己的定位气泡，比如大头针就会进入
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAAnnotationView*annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.frame = CGRectMake(0, 0, 100, 100);
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        //annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
        //        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        //设置大头针显示的图片
        annotationView.image = [UIImage imageNamed:@"iconfont-mark"];
        //点击大头针显示的左边的视图
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-mark"]];
        annotationView.leftCalloutAccessoryView = imageV;
        //点击大头针显示的右边视图
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
        rightButton.backgroundColor = [UIColor grayColor];
        [rightButton setTitle:@"导航" forState:UIControlStateNormal];
        annotationView.rightCalloutAccessoryView = rightButton;
        annotationView.tag =annotationp.tagg;
        //        annotationView.image = [UIImage imageNamed:@"redPin"];
        
        [rightButton addTarget:self action:@selector(push) forControlEvents:(UIControlEventTouchUpInside)];
        return annotationView;
    }
    return nil;
}


-(void)push{
    UIViewController *vc=[[UIViewController alloc]init];
       [self.navigationController pushViewController:vc animated:YES];
}


-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    
    NSLog(@"########################%ld--%ld",(long)annotationp.tagg,view.tag);
    //view.tag 唯一标识符
   // NSInteger index = view.tag -1000;

        
//        for (NSString *str in dd) {
//            
//            NSLog(@"******************%@",str);
//        }
        NSLog(@"***dd**********%@--%f--%f",view.annotation.title,view.annotation.coordinate.latitude ,view.annotation.coordinate.longitude);
    
//    UIViewController *vc=[[UIViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
//    view.annotation.title 

}

//- (void)locateTOLatitude:(double)latitude longitude:(double)longitude{
//    
//    NSLog(@"*******%lu",(unsigned long)data.count);
//    for (int i = 1;i <= data.count;i ++) {
//        NSString* key = [NSString stringWithFormat:@"%d",i];
//        
//        NSMutableDictionary *positionDic = [data valueForKey:key];
//        NSLog(@"%@",positionDic);
//        //添加描点
//        
//        MAPointAnnotation* annotation = [[MAPointAnnotation alloc]init];
//        annotation.title = [positionDic valueForKey:@"name"];
//        annotation.subtitle = [positionDic valueForKey:@"address"];
//        NSString* lat = [positionDic valueForKey:@"lat"] ;
//        NSString* lon = [positionDic valueForKey:@"lon"];
//        
//        CLLocationCoordinate2D coordinate = {[lat floatValue],[lon floatValue]};
//        
//        annotation.coordinate = coordinate;
//        
//        [_mapView addAnnotation:annotation];
//    }
//    
//    
//}

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
