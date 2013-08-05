//
//  AllMenuViewController.h
//  JiaDe
//
//  Created by xuwenjuan on 13-6-17.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllMenuViewDeletage <NSObject> 
- (void)allMenuViewChangeCateroy:(PicUploadCateroy)cateroy;
@end
@interface AllMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView*menuTable;
    NSMutableArray*menuArr;
    UIImageView*bottomBar;
    int height;
}
@property(nonatomic,assign)id<AllMenuViewDeletage> delegate;
@end
