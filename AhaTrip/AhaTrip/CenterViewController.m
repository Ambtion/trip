//
//  CenterViewController.m
//  Trip
//
//  Created by xuwenjuan on 13-6-13.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "CenterViewController.h"
#import "ASIRequest.h"
#import "Constants.h" 
#import "JSONKit.h"
#import "PersonalSettingViewController.h"
#import "SouSuoViewController.h"
#import "UIImage+Addition.h"
#import "AppDelegate.h"
#import "UIView+Animation.h"
#import "SingleMenuViewController.h"
@interface CenterViewController ()
@property(nonatomic,strong)NSMutableArray*photoArr;

@end

@implementation CenterViewController
@synthesize photoArr;

@synthesize countryName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//
           }
    return self;
}


-(void)countrySerach{
    SouSuoViewController*sousuo=[[SouSuoViewController alloc] init];
    [self.navigationController pushViewController:sousuo animated:YES];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

       
//   主页数据源
    self.photoArr=[NSMutableArray array];
  
    UIButton*countryBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    countryBtn.frame=CGRectMake(100, 2, 100, 40);
    [countryBtn setTitle:self.countryName forState:UIControlStateNormal];
    NSLog(@"%@",countryName);
    countryBtn.backgroundColor=[UIColor orangeColor];
    [self.navigationController.navigationBar addSubview:countryBtn];
    
    [self requestPhotoImage];
    photoTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    photoTable.backgroundColor=[UIColor redColor];
    photoTable.delegate=self;
    photoTable.dataSource=self;
    photoTable.separatorColor=[UIColor clearColor];
    [self.view addSubview:photoTable];
       UISwipeGestureRecognizer *oneFingerSwipeUp =
    	  [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeUp:)];
    [oneFingerSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [photoTable addGestureRecognizer:oneFingerSwipeUp];
    UISwipeGestureRecognizer *oneFingerSwipeDown =
   [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeDown:)];
    	[oneFingerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [photoTable addGestureRecognizer:oneFingerSwipeDown];
    
    [self addMenuBtn];
    
    
    
    
    //    0：景观  1：购物  2：餐饮 3：住宿  4：咖啡 5：娱乐  6：其他
    NSString*viewStr=@"景观";
    NSString*shopStr=@"购物";
    NSString*foodStr=@"美食";
    NSString*cafeiStr=@"住宿";
    NSString*departMentStr=@"咖啡";
    NSString*entertainment=@"娱乐";
    
    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:viewStr,@"menu",nil];
    
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:shopStr,@"menu",nil];
    
    NSDictionary *dic3=[NSDictionary dictionaryWithObjectsAndKeys:foodStr,@"menu",nil];
    
    NSDictionary *dic4=[NSDictionary dictionaryWithObjectsAndKeys:cafeiStr,@"menu",nil];
    
    NSDictionary *dic5=[NSDictionary dictionaryWithObjectsAndKeys:departMentStr,@"menu",nil];
      NSDictionary *dic6=[NSDictionary dictionaryWithObjectsAndKeys:entertainment,@"menu",nil];
    
    menuArr=[NSMutableArray arrayWithObjects:dic1,dic2,dic3,dic4,dic5,dic6,nil];

    // Do any additional setup after loading the view from its nib.
}
-(void)addMenuBtn{


    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    // Camera MenuItem.
    QuadCurveMenuItem *cameraMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                         highlightedContentImage:nil];
    // People MenuItem.
    QuadCurveMenuItem *peopleMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                         highlightedContentImage:nil];
    // Place MenuItem.
    QuadCurveMenuItem *placeMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                        highlightedContentImage:nil];
    // Music MenuItem.
    QuadCurveMenuItem *musicMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                        highlightedContentImage:nil];
    // Thought MenuItem.
    QuadCurveMenuItem *thoughtMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                 highlightedImage:storyMenuItemImagePressed
                                                                     ContentImage:[UIImage imageNamed:@"icon-star.png"]
                                                          highlightedContentImage:nil];
//    // Sleep MenuItem.
//    QuadCurveMenuItem *sleepMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
//                                                               highlightedImage:storyMenuItemImagePressed
//                                                                   ContentImage:[UIImage imageNamed:@"icon-star.png"]
//                                                        highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:cameraMenuItem, peopleMenuItem, placeMenuItem, musicMenuItem, thoughtMenuItem, nil];
    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:menus];
    menu.delegate = self;
    [self.view addSubview:menu];

}
//选择了哪个分类
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
   NSDictionary*menuDict=[menuArr objectAtIndex:idx];
    NSString*menuSelectStr=[menuDict objectForKey:@"menu"];
   
    SingleMenuViewController*singleMenu=[[SingleMenuViewController alloc] init];
    singleMenu.menuStr=menuSelectStr;
    singleMenu.selectID=idx+1;
    NSLog(@"%@%d",singleMenu.menuStr,singleMenu.selectID);
    [self presentViewController:singleMenu animated:YES completion:nil];
     
    
}


//- (void)oneFingerSwipeDown:(UISwipeGestureRecognizer *)recognizer
//	{
//      CGPoint point = [recognizer locationInView:[self view]];
//      NSLog(@"Swipe down - start location: %f,%f", point.x, point.y);
//        [self.navigationController setNavigationBarHidden:YES];
//        [UIView animationFade:self.navigationController.navigationBar];
//    
//    }
//-(void)oneFingerSwipeUp:(UISwipeGestureRecognizer *)recognizer
//	{
//    	  CGPoint point = [recognizer locationInView:[self view]];
//      NSLog(@"Swipe up - start location: %f,%f", point.x, point.y);
//        [self.navigationController setNavigationBarHidden:NO];
//        [UIView animationFade:self.navigationController.navigationBar];
//    
//    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma table delegate/datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.photoArr.count +1) /2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *topicCell = @"TopicCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:topicCell];
    if(!cell)
    {
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 

        

        UIButton*photoBtnRight=[UIButton  buttonWithType:UIButtonTypeCustom];
         photoBtnRight.frame=CGRectMake(165, 0, 150, 130);
         photoBtnRight.tag=2000;
          [cell addSubview:photoBtnRight];
       
        UIButton*photoBtnLeft=[UIButton buttonWithType:UIButtonTypeCustom] ;
        photoBtnLeft.frame=CGRectMake(5, 0, 150, 130);
        photoBtnLeft.tag=1000;
        [cell addSubview:photoBtnLeft];
       
          
        
    }
        NSUInteger leftIndex   = indexPath.row * 2;
    UIButton*photoBtnLeft=(UIButton*)[cell viewWithTag:1000];
    NSDictionary *leftDict = [self.photoArr objectAtIndex:leftIndex];
    NSURL *leftURL  = [NSURL URLWithString:[leftDict objectForKey:@"photo"]];
    [photoBtnLeft setImageWithURL:leftURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading.png"]];
    [photoBtnLeft setTag:leftIndex];
    [photoBtnLeft addTarget:self action:@selector(topicBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [photoBtnLeft setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
       
    NSUInteger rightIndex = indexPath.row * 2 + 1;
      UIButton*photoBtnRight=(UIButton*)[cell viewWithTag:2000];
    if (rightIndex < self.photoArr.count)
        {
        
            
        NSDictionary *rightDict = [self.photoArr objectAtIndex:rightIndex];
        //        NSLog(@"rightDict:%@", rightDict);
        
        NSURL *rightURL = [NSURL URLWithString:[rightDict objectForKey:@"photo"]];
       
        [photoBtnRight setImageWithURL:rightURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading.png"]];
        [photoBtnRight setTag:rightIndex];
        [photoBtnRight addTarget:self action:@selector(topicBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        photoBtnRight.hidden=NO;
       
    }
    else
    {
        photoBtnRight.hidden=YES;
    }
    
      
    return cell;
}
- (void)topicBtnClicked:(UIButton *)sender
{
//    CenterViewController*center=[[CenterViewController alloc] init];
//    [self.navigationController pushViewController:center animated:YES];
//    testViewController*test=[[testViewController alloc] init];
//    
//    NSDictionary *item = [self.newsInfoMArray objectAtIndex:sender.tag];
//    
//    NSUInteger classID = [[item objectForKey:@"id"] integerValue];
//    test.id=classID;
//    if([[item objectForKey:@"type"] isEqualToString:@"3"])test.isVideo = YES;
//    else test.isVideo = NO;
//    test.ENCHstr=selectENCH;
//    test.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:test animated:YES];
    //    [self presentModalViewController:self.test animated:YES];
}
#pragma asirequest
-(void)requestPhotoImage{
 NSString*topic=@"http://yyz.ahatrip.info/api/index?token=tRyW4rLBiJHffQ";
    
    [[ASIRequest shareInstance] get:topic header:nil delegate:self tag:10000 useCache:YES];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 10000 && request.responseStatusCode == 200)
    {
        NSDictionary *data =[request responseString].objectFromJSONString;
        self.photoArr=[data objectForKey:@"findings"];
        [photoTable reloadData];
        NSLog(@"%d",self.photoArr.count);
       
        
           
        
    }
    
}

@end
