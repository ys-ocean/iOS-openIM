//
//  CMPlugInViewController.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/13.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMPlugInViewController.h"
#import "CarMsgMapViewController.h"
#import "CMPlugInCollectionCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface CMPlugInViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSArray * dataArray;
@property (strong, nonatomic) CMPlugInPresenter * presenter;
@property (copy, nonatomic) void(^didPlugInBlokc)(void);
@end

@implementation CMPlugInViewController
static NSString * cellId = @"CMPlugInCollectionCell";

+ (instancetype)instanceWithPresenter:(CMPlugInPresenter *)presenter {
    CMPlugInViewController * vc = [[CMPlugInViewController alloc]init];
    vc.presenter = presenter;
    return vc;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMPlugInCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell configureWithModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.didPlugInBlokc) {
        self.didPlugInBlokc();
    }
    
    PlugInModel * model = self.dataArray[indexPath.row];
    if (model.plugInType == CMInputViewPluginPhoto) {
        /// 相册
        [self openPhotos];
    }
    else if (model.plugInType == CMInputViewPluginCamera) {
        /// 相机
        [self openCamera];
    }
    else if (model.plugInType == CMInputViewPluginLocation) {
        /// 地理位置
        [self openLocation];
    }
    else {
        [self.collectionView showToastWithText:@"暂未开放" position:CSToastPositionCenter];
    }
}

- (void)openPhotos {
    if ([self.presenter getMediaIsAvailableFromSource:UIImagePickerControllerSourceTypeCamera]) {
        if ([self.presenter getMediaIsPermissionFromSource:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController * vc = [[UIImagePickerController alloc]init];
            vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            vc.delegate = self;
            vc.mediaTypes =@[(NSString *)kUTTypeImage];
            if (([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)) {
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            vc.navigationBar.barTintColor = [UIColor blackColor];
            vc.navigationBar.tintColor = [UIColor whiteColor];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
                vc.topViewController.title = @"相册";
                vc.navigationBar.translucent = NO;
                vc.navigationBar.barStyle = UIBarStyleDefault;
                [vc setNavigationBarHidden:NO animated:NO];
            }];
        }
        else {
            [self.collectionView showToastWithText:@"“App”没有访问照片的权限,请您在“设置->隐私->照片”中开启“App”访问照片的权限" position:CSToastPositionCenter];
        }
    }
    else {
        [self.collectionView showToastWithText:@"设置不支持查看相册功能" position:CSToastPositionCenter];
    }
}

- (void)openCamera {
    if ([self.presenter getMediaIsAvailableFromSource:UIImagePickerControllerSourceTypeCamera]) {
        if ([self.presenter getMediaIsPermissionFromSource:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController * vc = [[UIImagePickerController alloc]init];
            vc.sourceType = UIImagePickerControllerSourceTypeCamera;
            vc.delegate = self;
            vc.mediaTypes = @[(NSString *)kUTTypeImage];
            if (([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)) {
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            vc.navigationBar.barTintColor = [UIColor blackColor];
            vc.navigationBar.tintColor = [UIColor whiteColor];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
            }];
        }
        else {
            [self.collectionView showToastWithText:@"“App”没有访问相机的权限,请您在“设置->隐私->照片”中开启“App”访问照片的权限" position:CSToastPositionCenter];
        }
    }
    else {
        [self.collectionView showToastWithText:@"设置不支持查拍照功能" position:CSToastPositionCenter];
    }
}

- (void)postMessageForLocation:(double)longitude latitude:(double)latitude title:(NSString *)title {
    [[NSNotificationCenter defaultCenter]postNotificationName:CMSendNotificationKey object:nil userInfo:@{CMSendMsgNotificationTypeKey:@(CMSendMessageTypeLocation),CMSendMsgSubNotifiLongitudeKey:@(longitude),CMSendMsgSubNotifiLatitudeKey:@(latitude),CMSendMsgSubNotifiLocationNameKey:title}];
}

- (void)postMessageForImage:(UIImage *)image {
    [[NSNotificationCenter defaultCenter]postNotificationName:CMSendNotificationKey object:nil userInfo:@{CMSendMsgNotificationTypeKey:@(CMSendMessageTypeImage),CMSendMsgSubNotifiImageKey:image}];
}

- (void)openLocation {
    @weakify(self);
    CarMsgMapViewController * vc = [[CarMsgMapViewController alloc]init];
    [vc setDidLocationBlock:^(double longitude, double latitude, NSString * title) {
        [weak_self postMessageForLocation:longitude latitude:latitude title:title];
    }];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGSize size = CGSizeMake(828, 828 *(image.size.height/image.size.width));
    UIImage * saveImage = [image fixOrientation:image];
    saveImage = [saveImage scaleImagetoSize:size toByte:50];
    
    [self postMessageForImage:saveImage];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/4.0, EMOJI_SCROLL_HEIGHT/2.0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, EMOJI_SCROLL_HEIGHT) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = EMOJI_BG_COLOR;
        FETCHCOLLECTIONVIEW_CELL_NIB(_collectionView, cellId, cellId);
    }
    return _collectionView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        PlugInModel * model = [[PlugInModel alloc]init];
        model.imageName = @"input_plug_ico_photo_nor";
        model.title = @"相册";
        model.plugInType = CMInputViewPluginPhoto;
        PlugInModel * model1 = [[PlugInModel alloc]init];
        model1.imageName = @"input_plug_ico_camera_nor";
        model1.title = @"相机";
        model1.plugInType = CMInputViewPluginCamera;
        PlugInModel * model2 = [[PlugInModel alloc]init];
        model2.imageName = @"input_plug_ico_ad_nor";
        model2.title = @"位置";
        model2.plugInType = CMInputViewPluginLocation;
        _dataArray = @[model,model1,model2];
    }
    return _dataArray;
}
@end
