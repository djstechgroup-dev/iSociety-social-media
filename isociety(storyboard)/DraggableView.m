//
//  DraggableView.m
//  testing swiping
//
//  Created by Richard Kim on 5/21/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for updates and requests

#define ACTION_MARGIN 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle

#import "DraggableView.h"

@implementation DraggableView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
    
    BOOL bIsUp;
    BOOL bIgnoreGesture;
    
    AVPlayerLayer *playerLayer;
    AVPlayer *player;
}

//delegate is instance of ViewController
@synthesize delegate;

@synthesize panGestureRecognizer;
@synthesize information;
@synthesize overlayView;
@synthesize cardbackground;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
        information = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, self.frame.size.width, 100)];
//        information.text = @"no info given";
        [information setTextAlignment:NSTextAlignmentCenter];
        information.textColor = [UIColor blackColor];
        
        self.backgroundColor = [UIColor whiteColor];
        
        UISwipeGestureRecognizer* swipeupGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeUp:)];
        swipeupGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipeupGesture];
        
//        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
//        
//        [self addGestureRecognizer:panGestureRecognizer];
//        [self addSubview:information];
        
        cardbackground = [[UIImageView alloc] initWithFrame:self.frame];
        cardbackground.contentMode = UIViewContentModeScaleAspectFill;
//        cardbackground.clipsToBounds = YES;
//        cardbackground.layer.borderWidth = 1;
//        cardbackground.layer.cornerRadius = 2.0;
//        cardbackground.layer.borderColor = [[UIColor grayColor] CGColor];
//        cardbackground.layer.masksToBounds = YES;
        
        [self addSubview:cardbackground];
        
        overlayView = [[OverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
        overlayView.alpha = 0;
        [self addSubview:overlayView];
    }
    return self;
}

- (void) didSwipeUp:(UISwipeGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        startLocation = [gesture locationInView:self];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint stopLocation = [gesture locationInView:self];
        CGFloat dx = stopLocation.x - startLocation.x;
        CGFloat dy = stopLocation.y - startLocation.y;
        CGFloat distance = sqrt(dx*dx + dy*dy );
        
        [delegate cardSwipedUp];
//        NSLog(@"Distance: %f", distance);
    }
    
}

-(void)loadBackgroundImage:(PHAsset*)nextAsset {

//    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cardbackground];
//
//    if ( [cardbackground in])
//    
//    [[PHImageManager defaultManager] requestImageForAsset:nextAsset targetSize:cardbackground.frame.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
//        if (result) {
//            [cardbackground setImage:result];
//        }
//    }];
    
}

-(void)setupView
{
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    CGPoint velocity = [panGestureRecognizer velocityInView:self];
//    return fabs(velocity.y) < fabs(velocity.x);
//}

-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
    yFromCenter = [gestureRecognizer translationInView:self].y; //%%% positive for up, negative for down
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            
            bIsUp = NO;
            
            break;
        };
        case UIGestureRecognizerStateChanged:{
            
            
//            if ( fabs(xFromCenter) > 10 && fabs(yFromCenter) > 10 ) {
//                bIgnoreGesture = YES;
//                break;
//            }
//            
//            if ( yFromCenter > 10 ) {
//                bIgnoreGesture = YES;
//                break;
//            }
            
            if ( fabs(xFromCenter) > ACTION_MARGIN/2 )
                bIsUp = NO;
            else
                bIsUp = YES;
            
//            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
//            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
//            
//            //%%% degree change in radians
//            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
//            
//            //%%% amount the height changes when you move the card up to a certain point
//            CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
//            //%%% rotate by certain amount
//            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
//            
//            //%%% scale by certain amount
//            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            //%%% apply transformations
//            self.transform = scaleTransform;
//            [self updateOverlay:xFromCenter];
            
//            if ( !bIsUp) {
//                [delegate replaceContent:xFromCenter];
////                [delegate adjustCardsPosition: fabsf(xFromCenter/100) :bIsUp];
//            }else {
//                [delegate replaceContent:-1];
////                [delegate adjustCardsPosition: 0.1 :bIsUp];
//            }

            break;
        };
        case UIGestureRecognizerStateEnded: {
            if ( bIgnoreGesture ) //restore frame
                xFromCenter = 0;
            
            [self afterSwipeAction];
            
            bIgnoreGesture = NO;
            
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

//%%% checks to see if you are moving right or left and applies the correct overlay image
-(void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        overlayView.mode = GGOverlayViewModeRight;
    } else {
        overlayView.mode = GGOverlayViewModeLeft;
    }
    
    overlayView.alpha = MIN(fabsf(distance)/100, 0.4);
}

//%%% called when the card is let go
- (void)afterSwipeAction
{
    if ( fabs(yFromCenter) > ACTION_MARGIN) {
        if (fabs(yFromCenter) > ACTION_MARGIN) {
            [delegate replaceContent:-1];
            [self upAction];
        } else { //%%% resets the card
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.center = self.originalPoint;
                                 self.transform = CGAffineTransformMakeRotation(0);
                                 overlayView.alpha = 0;
                                 
                                 [delegate resetAllCardsPosition];
                             }completion:^(BOOL finished) {
                                 [delegate clearNextCardContents];
                             }];
        }
    }else {
        if (xFromCenter > ACTION_MARGIN) {
            [self rightAction];
        } else if (xFromCenter < -ACTION_MARGIN) {
            [self leftAction];
        } else { //%%% resets the card
            [UIView animateWithDuration:0.3
                             animations:^{
                                 self.center = self.originalPoint;
                                 self.transform = CGAffineTransformMakeRotation(0);
                                 overlayView.alpha = 0;
                                 
                                 [delegate resetAllCardsPosition];
                             }completion:^(BOOL finished) {
                                 [delegate clearNextCardContents];
                             }];
        }
    }
}

- (void)moveTopCard:(float)offset {
//    [delegate replaceContent:offset];
//    [delegate adjustCardsPosition: fabsf(offset/100)];
}

//%%% called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         if ( playerLayer )
                             [playerLayer removeFromSuperlayer];
                         playerLayer = nil;
                         
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    [delegate resetAllCardsPosition];
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         if ( playerLayer )
                             [playerLayer removeFromSuperlayer];
                         playerLayer = nil;
                         
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    [delegate resetAllCardsPosition];
}

- (void)upAction {
    CGPoint finishPoint = CGPointMake(self.originalPoint.x, -800);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         if ( playerLayer )
                             [playerLayer removeFromSuperlayer];
                         playerLayer = nil;
                         
                         [self removeFromSuperview];
                     }];

    [delegate cardSwipedUp];
}

-(void)rightClickAction
{
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         if ( playerLayer )
                             [playerLayer removeFromSuperlayer];
                         playerLayer = nil;

                         
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
}

-(void)leftClickAction
{
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         if ( playerLayer )
                             [playerLayer removeFromSuperlayer];
                         playerLayer = nil;
                             
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
}

-(void) pauseVideo {
    UIButton* btnPlay = (UIButton*)[self viewWithTag:234];
    btnPlay.selected = NO;
    
    if ( playerLayer ) {
        [player pause];
        
        [playerLayer removeFromSuperlayer];
        playerLayer = nil;
    }
}

-(void)playVideo {
    UIButton* btnPlay = (UIButton*)[self viewWithTag:234];
    btnPlay.selected = !btnPlay.selected;
  
    if (!playerLayer) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:_videoURL];
        //        playerItem.audioMix = audioMix;
        player = [AVPlayer playerWithPlayerItem:playerItem];

        playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        
        CALayer *layer = self.layer;
        //                [layer addSublayer:playerLayer];
        [layer insertSublayer:playerLayer atIndex:1];
        [playerLayer setFrame:self.bounds];
        [player play];
    }
    
    if ( playerLayer ) {
        
        if ( !btnPlay.selected )
            [player pause];
        else
            [player play];
        
        return;
    }


//    [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset options:nil resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
//    }];
    
}

- (void)itemDidFinish:(NSNotification*)notification{
    UIButton* btnPlay = (UIButton*)[self viewWithTag:234];
    [btnPlay setSelected:NO];
    
    [playerLayer removeFromSuperlayer];
    playerLayer = nil;
}

-(void)showPlayButton:(BOOL)bShow {
    UIButton* btnPlay = (UIButton*)[self viewWithTag:234];
    if ( btnPlay ) {
        [btnPlay removeFromSuperview];
        btnPlay = nil;
    }
    
    if ( bShow ) {
        btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPlay setImage:[UIImage imageNamed:@"icon-videoplay"] forState:UIControlStateNormal];
        [btnPlay setImage:[UIImage imageNamed:@"icon-videopause"] forState:UIControlStateSelected];
        btnPlay.frame = CGRectMake((self.frame.size.width-40)/2, (self.frame.size.height-40)/2, 40, 40);
        [btnPlay addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        btnPlay.tag = 234;
        [self addSubview:btnPlay];
    }
}


@end