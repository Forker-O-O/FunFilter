//
//  VideoThemesData.m
//  TailorableFilter
//
//  Created by Johnny Xu(徐景周) on 8/11/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//

#import "VideoThemesData.h"

@interface VideoThemesData()
{
    NSMutableDictionary *_themesDic;
    
    NSMutableDictionary *_filterFromOthers;
    NSMutableDictionary *_filterFromSystemCamera;
}

@property (retain, nonatomic) NSMutableDictionary *themesDic;
@property (retain, nonatomic) NSMutableDictionary *filterFromOthers;
@property (retain, nonatomic) NSMutableDictionary *filterFromSystemCamera;
@end


@implementation VideoThemesData

@synthesize themesDic = _themesDic;
@synthesize filterFromOthers = _filterFromOthers;
@synthesize filterFromSystemCamera = _filterFromSystemCamera;

#pragma mark - Singleton
+ (VideoThemesData *) sharedInstance
{
    static VideoThemesData *singleton = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        singleton = [[VideoThemesData alloc] init];
    });
    
    return singleton;
}

#pragma mark - Life cycle
- (id)init
{
    self = [super init];
    
	if (self)
    {
        // Only run once
        [self initThemesData];
        
        self.filterFromOthers = [self createThemeFilter:FALSE];
        self.filterFromSystemCamera = [self createThemeFilter:TRUE];
    }
	return self;
}

- (void)dealloc
{
    [self clearAll];
}

- (void) clearAll
{
    if (self.filterFromOthers && [self.filterFromOthers count]>0)
    {
        [self.filterFromOthers removeAllObjects];
        self.filterFromOthers = nil;
    }
    
    if (self.filterFromSystemCamera && [self.filterFromSystemCamera count]>0)
    {
        for (GPUImageOutput<GPUImageInput> *filter in self.filterFromOthers)
        {
            [filter removeAllTargets];
        }
        
        [self.filterFromSystemCamera removeAllObjects];
        self.filterFromSystemCamera = nil;
    }
    
    if (self.themesDic && [self.themesDic count]>0)
    {
        [self.themesDic removeAllObjects];
        self.themesDic = nil;
    }
}

#pragma mark - Common function
- (NSString*) getWeekdayFromDate:(NSDate*)date
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* components = nil; //[[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    components = [calendar components:unitFlags fromDate:date];
    NSUInteger weekday = [components weekday];
    
    NSString *result = nil;
    switch (weekday)
    {
        case 1:
        {
            result = @"Sunday";
            break;
        }
        case 2:
        {
            result = @"Monday";
            break;
        }
        case 3:
        {
            result = @"Tuesday";
            break;
        }
        case 4:
        {
            result = @"Wednesday";
            break;
        }
        case 5:
        {
            result = @"Thursday";
            break;
        }
        case 6:
        {
            result = @"Friday";
            break;
        }
        case 7:
        {
            result = @"Saturday";
            break;
        }
        default:
            break;
    }
    
    return result;
}

-(NSString*) getStringFromDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];

    return strDate;
}

- (GPUImageOutput<GPUImageInput> *) createFilterNostalgia:(BOOL)fromSystemCamera
{
    // Filter
    GPUImageOutput<GPUImageInput> *filterNostalgia = [[GPUImageFilterGroup alloc] init];
    
    CGFloat rotationAngle = 0;
    if (fromSystemCamera)
    {
        rotationAngle = M_PI_2;
    }
    GPUImageTransformFilter *transformFilter = [[GPUImageTransformFilter alloc] init];
    [(GPUImageTransformFilter *)transformFilter setAffineTransform:CGAffineTransformMakeRotation(rotationAngle)];
    [(GPUImageTransformFilter *)transformFilter setIgnoreAspectRatio:YES];
    [(GPUImageFilterGroup *)filterNostalgia addFilter:transformFilter];
    
    GPUImageSwirlFilter *swirlFilter = [[GPUImageSwirlFilter alloc] init];
    [swirlFilter setAngle:0.2];
    [(GPUImageFilterGroup *)filterNostalgia addFilter:swirlFilter];
    
    [transformFilter addTarget:swirlFilter];
    
    [(GPUImageFilterGroup *)filterNostalgia setInitialFilters:[NSArray arrayWithObject:transformFilter]];
    [(GPUImageFilterGroup *)filterNostalgia setTerminalFilter:swirlFilter];
        
    return filterNostalgia;
}

- (VideoThemes*) createThemeNostalgia
{
    VideoThemes *themeNostalgia = [[VideoThemes alloc] init];
    themeNostalgia.ID = kThemeNostalgia;
    themeNostalgia.thumbImageName = @"themeNostalgia";
    themeNostalgia.name = GBLocalizedString(@"Swirl");
    themeNostalgia.textStar = nil;
    themeNostalgia.textSparkle = nil;
    themeNostalgia.bgMusicFile = @"Bye Bye Sunday.mp3";
    themeNostalgia.imageFile = nil;
        
    // Animation effects
    NSArray *aniNostalgia = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationSnow], nil];
    themeNostalgia.animationActions = [NSArray arrayWithArray:aniNostalgia];
    
    return themeNostalgia;
}

- (GPUImageOutput<GPUImageInput> *) createFilterMood:(BOOL)fromSystemCamera
{
    // Filter
    GPUImageOutput<GPUImageInput> *filterMood = [[GPUImageFilterGroup alloc] init];
    
    CGFloat rotationAngle = 0;
    if (fromSystemCamera)
    {
        rotationAngle = M_PI_2;
    }
    GPUImageTransformFilter *transformFilter = [[GPUImageTransformFilter alloc] init];
    [(GPUImageTransformFilter *)transformFilter setAffineTransform:CGAffineTransformMakeRotation(rotationAngle)];
    [(GPUImageTransformFilter *)transformFilter setIgnoreAspectRatio:YES];
    [(GPUImageFilterGroup *)filterMood addFilter:transformFilter];
    
    GPUImagePixellateFilter *pixellateFilter = [[GPUImagePixellateFilter alloc] init];
    [pixellateFilter setFractionalWidthOfAPixel:0.05];
    [(GPUImageFilterGroup *)filterMood addFilter:pixellateFilter];
    
    [transformFilter addTarget:pixellateFilter];
    
    [(GPUImageFilterGroup *)filterMood setInitialFilters:[NSArray arrayWithObject:transformFilter]];
    [(GPUImageFilterGroup *)filterMood setTerminalFilter:pixellateFilter];
    
    return filterMood;
}

- (VideoThemes*) createThemeMood
{
    VideoThemes *theme = [[VideoThemes alloc] init];
    theme.ID = kThemeMood;
    theme.thumbImageName = @"themeMood";
    theme.name = GBLocalizedString(@"Mosaic");
    theme.textStar = nil;
    theme.textSparkle = @"Miss You!";
    theme.bgMusicFile = @"Oh My Juliet.mp3";
    
    // Filter
//    theme.filter = [self createFilterMood:fromSystemCamera];
    
    // Animation effects
    NSArray *aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationTextSparkle], nil];
    theme.animationActions = [NSArray arrayWithArray:aniActions];
    
    return theme;
}

- (GPUImageOutput<GPUImageInput> *) createFilterDistortion:(BOOL)fromSystemCamera
{
    GPUImageOutput<GPUImageInput> *filterOldFilm = [[GPUImageFilterGroup alloc] init];
    
    CGFloat rotationAngle = 0;
    if (fromSystemCamera)
    {
        rotationAngle = M_PI_2;
    }
    GPUImageTransformFilter *transformFilter = [[GPUImageTransformFilter alloc] init];
    [(GPUImageTransformFilter *)transformFilter setAffineTransform:CGAffineTransformMakeRotation(rotationAngle)];
    [(GPUImageTransformFilter *)transformFilter setIgnoreAspectRatio:YES];
    [(GPUImageFilterGroup *)filterOldFilm addFilter:transformFilter];
    
    GPUImagePinchDistortionFilter *distortionFilter = [[GPUImagePinchDistortionFilter alloc] init];
    [distortionFilter setScale:0.5];
    [(GPUImageFilterGroup *)filterOldFilm setTerminalFilter:distortionFilter];
    
    [transformFilter addTarget:distortionFilter];
    
    [(GPUImageFilterGroup *)filterOldFilm setInitialFilters:[NSArray arrayWithObject:transformFilter]];
    [(GPUImageFilterGroup *)filterOldFilm setTerminalFilter:distortionFilter];
    
    return filterOldFilm;
}

- (VideoThemes*) createThemeOldFilm
{
    VideoThemes *theme = [[VideoThemes alloc] init];
    theme.ID = KThemeOldFilm;
    theme.thumbImageName = @"themeOldFilm";
    theme.name = GBLocalizedString(@"Distortion");
    theme.textStar = nil;
    theme.textSparkle = nil;
    theme.bgMusicFile = @"Swing Dance Two.mp3";
    theme.imageFile = nil;
    
    // Scroll text
    NSMutableArray *scrollText = [[NSMutableArray alloc] init];
    [scrollText addObject:(id)[self getStringFromDate:[NSDate date]]];
    [scrollText addObject:(id)[self getWeekdayFromDate:[NSDate date]]];
    [scrollText addObject:(id)@"It's a beautiful day!"];
    theme.scrollText = scrollText;
    
    // Filter
//    theme.filter = [self createFilterOldFilm:fromSystemCamera];
    
    // Animation effects
    NSArray *aniActions = [NSArray arrayWithObjects:[NSNumber numberWithInt:kAnimationScrollScreen], [NSNumber numberWithInt:kAnimationTextScroll], [NSNumber numberWithInt:kAnimationBlackWhiteDot], [NSNumber numberWithInt:kAnimationScrollLine], [NSNumber numberWithInt:kAnimationFlashScreen], nil];
    theme.animationActions = [NSArray arrayWithArray:aniActions];
    
    return theme;
}

- (void) initThemesData
{
    self.themesDic = [NSMutableDictionary dictionaryWithCapacity:4];
    
    VideoThemes *theme = nil;
    for (int i = kThemeNone; i <= KThemeOldFilm; ++i)
    {
        switch (i)
        {
            case kThemeNone:
            {
                break;
            }
            case kThemeMood:
            {
                theme = [self createThemeMood];
                break;
            }
            case kThemeNostalgia:
            {
                theme = [self createThemeNostalgia];
                break;
            }
            case KThemeOldFilm:
            {
                theme = [self createThemeOldFilm];
                break;
            }
            default:
                break;
        }
        
        if (i == kThemeNone)
        {
            [self.themesDic setObject:[NSNull null] forKey:[NSNumber numberWithInt:kThemeNone]];
        }
        else
        {
            [self.themesDic setObject:theme forKey:[NSNumber numberWithInt:i]];
        }
    }
}

- (NSMutableDictionary*) createThemeFilter:(BOOL)fromSystemCamera
{
    NSMutableDictionary *themesFilter = [[NSMutableDictionary alloc]initWithCapacity:4];
    for (int i = kThemeNone; i < self.themesDic.count; ++i)
    {
        switch (i)
        {
            case kThemeNone:
            {
                [themesFilter setObject:[NSNull null] forKey:[NSNumber numberWithInt:kThemeNone]];
                break;
            }
            case kThemeMood:
            {
                GPUImageOutput<GPUImageInput> *filterMood = [self createFilterMood:fromSystemCamera];
                if (filterMood == nil)
                {
                    [themesFilter setObject:[NSNull null] forKey:[NSNumber numberWithInt:kThemeMood]];
                }
                else
                {
                    [themesFilter setObject:filterMood forKey:[NSNumber numberWithInt:kThemeMood]];
                }
                
                break;
            }
            case kThemeNostalgia:
            {
                GPUImageOutput<GPUImageInput> *filterNostalgia = [self createFilterNostalgia:fromSystemCamera];
                if (filterNostalgia == nil)
                {
                    [themesFilter setObject:[NSNull null] forKey:[NSNumber numberWithInt:kThemeNostalgia]];
                }
                else
                {
                    [themesFilter setObject:filterNostalgia forKey:[NSNumber numberWithInt:kThemeNostalgia]];
                }

                break;
            }
            case KThemeOldFilm:
            {
                GPUImageOutput<GPUImageInput> *filterOldFilm = [self createFilterDistortion:fromSystemCamera];
                if (filterOldFilm == nil)
                {
                    [themesFilter setObject:[NSNull null] forKey:[NSNumber numberWithInt:KThemeOldFilm]];
                }
                else
                {
                    [themesFilter setObject:filterOldFilm forKey:[NSNumber numberWithInt:KThemeOldFilm]];
                }

                break;
            }
            default:
                break;
        }
    }

    return themesFilter;
}

- (GPUImageOutput<GPUImageInput> *) createThemeFilter:(ThemesType)themeType fromSystemCamera:(BOOL)fromSystemCamera
{
    GPUImageOutput<GPUImageInput> *filter = nil;
    switch (themeType)
    {
        case kThemeNone:
        {
            break;
        }
        case kThemeMood:
        {
            filter = [self createFilterMood:fromSystemCamera];
            break;
        }
        case kThemeNostalgia:
        {
            filter = [self createFilterNostalgia:fromSystemCamera];
            break;
        }
        case KThemeOldFilm:
        {
            filter = [self createFilterDistortion:fromSystemCamera];
            break;
        }
        default:
            break;
    }
    
    return filter;
}

- (NSMutableDictionary*) getThemeFilter:(BOOL)fromSystemCamera
{
    if (fromSystemCamera)
    {
        return self.filterFromSystemCamera;
    }
    else
    {
        return self.filterFromOthers;
    }
}

- (NSMutableDictionary*) getThemeData
{
    return self.themesDic;
}

@end
