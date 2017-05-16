//
//  NHAutoCompleteTextBox.h
//  NHAutoCompleteTextBox
//
//  Created by Shahan on 12/12/2014.
//  Copyright (c) 2014 Shahan. All rights reserved.
//

#import "UIView+NHExtension.h"
#import "NHConstants.h"
#import "UILabel+Boldify.h"

@class NHAutoCompleteTextField;

@protocol NHAutoCompleteTextFieldDataFilterDelegate <NSObject>

@optional

/**
 If you wants to filter out records. It should return YES.
 */
-(BOOL)shouldFilterDataSource:(NHAutoCompleteTextField *)autoCompleteTextBox;

/**
 This function will help out to keep the filtered records only.
 */
-(void)autoCompleteTextBox:(NHAutoCompleteTextField *)autoCompleteTextBox didFilterSourceUsingText:(NSString *)text;

@end


@protocol NHAutoCompleteTextFieldDataSourceDelegate <NSObject>

@required;

/**
 Depicts the items available in the list.
 */
- (NSInteger)autoCompleteTextBox:(NHAutoCompleteTextField *)autoCompleteTextBox numberOfRowsInSection:(NSInteger)section;

/**
 Create a customized cell as per your need.
 */
- (UITableViewCell *)autoCompleteTextBox:(NHAutoCompleteTextField *)autoCompleteTextBox cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NHAutoCompleteTextField : UIView<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (void)initTextFieldWithPlaceholder:(NSString *)placeholder withTextAlignment:(NSTextAlignment)textAlignment withTextColor:(UIColor *)textColor withFont:(UIFont *)font withLeftView:(UIView *)leftView withRightView:(UIView *)rightView;
- (void)tableViewReloadData;
@property (nonatomic, retain) UITextField *suggestionTextField;
@property (nonatomic, retain) NSString *filterString;
@property (nonatomic, assign) NHDropDownDirection dropDownDirection;
@property (nonatomic, retain) UITableView *suggestionListView;
@property (nonatomic, weak) id<NHAutoCompleteTextFieldDataSourceDelegate> dataSourceDelegate;
@property (nonatomic, weak) id<NHAutoCompleteTextFieldDataFilterDelegate> dataFilterDelegate;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
