//
//  MealDetailViewController.h
//  EatSmart
//
//  Created by Frederik Riedel on 28.11.14.
//  Copyright (c) 2014 Larissa Laich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meal.h"
#import "MealHeadView.h"
#import "MealDetailTableViewCell.h"
#import "AppDelegate.h"
#import "Review.h"
@import MapKit;
@import CoreLocation;

@interface MealDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property(nonatomic) UIWebView *mealView;
@property(nonatomic) MealHeadView *mealHeadView;
@property(nonatomic) UITableView *table;
@property(nonatomic) UISegmentedControl *segmentControl;
@property(nonatomic) Meal *meal;
@property(nonatomic) User *host;
@property(nonatomic) NSMutableArray *reviews;

@property(nonatomic) NSMutableArray *pendingUsers;
@property(nonatomic) NSMutableArray *confirmedUsers;




-(id) initWithMeal:(Meal *) meal;


@end
