//
//  sflyViewController.h
//  displaypicsInstagram
//
//  Created by kmd on 9/16/12.
//  Copyright (c) 2012 kmd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sflyViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UIImage *img1;
    UIImage *img2;
    UIImage *img3;
    
    UIImageView *imgv1;
    UIImageView *imgv2;
    UIImageView *imgv3;
    
    NSMutableData *jsondata;
    UIActivityIndicatorView *jsondataDownloadIndicator;
    NSString *jsonstring;
    NSMutableArray *jsonthumbnailsstring;
    NSMutableArray *jsonHighresstring;
    int gCnt;
    int mTablerows;
    IBOutlet UITableView *tbview;
    NSMutableArray *downloadedimages;
    
    // testing scroll views
    IBOutlet UIScrollView *parentScrollview;
    IBOutlet UIView *displayPics;
    NSInteger mPositionX;
    NSMutableArray *thumbnailViews;
}

@property (nonatomic, retain) NSMutableArray *jsonHighresstring;
@property (nonatomic, retain) NSMutableArray *thumbnailViews;
@property (nonatomic, retain) NSMutableArray *downloadedimages;
@property (nonatomic,retain) UITableView *tbview;
@property (nonatomic,strong) UIImageView *imgv1;
@property (nonatomic,strong) UIImageView *imgv2;
@property (nonatomic,strong) UIImageView *imgv3;
@property (nonatomic,strong) UIImage *img1;
@property (nonatomic,strong) UIImage *img2;
@property (nonatomic,strong) UIImage *img3;
@property (nonatomic,strong) NSMutableData *jsondata;
@property (nonatomic,strong) UIActivityIndicatorView *jsondataDownloadIndicator;
@property (nonatomic,strong) NSString *jsonstring;
@property (nonatomic,strong) NSMutableArray *jsonthumbnailsstring;
@end
