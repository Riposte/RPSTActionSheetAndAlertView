//
//  RPSTAlertView.m
//
//  Copyright (c) 2013 Riposte LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software
//  is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RPSTAlertView.h"

@implementation RPSTAlertViewButtonItem

- (id)initWithTitle:(NSString *)title actionBlock:(RPSTAlertViewActionBlock)actionBlock {
    self = [super init];
    if (self) {
        _title = [title copy];
        _actionBlock = [actionBlock copy];
    }
    return self;
}

@end

@interface RPSTAlertView ()

@property (strong, nonatomic) NSMutableArray *buttonItems;
@property (strong, nonatomic) RPSTAlertViewButtonItem *cancelButtonItem;

@end

@implementation RPSTAlertView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
   cancelButtonItem:(RPSTAlertViewButtonItem *)cancelButtonItem
   otherButtonItems:(NSArray *)otherButtonItems {
    self = [super init];
    if (self) {
        [self setTitle:title];
        [self setMessage:message];
        [self setDelegate:self];
        _buttonItems = [NSMutableArray array];
        
        [self addButtonWithTitle:cancelButtonItem.title];
        [self setCancelButtonIndex:0];
        _cancelButtonItem = cancelButtonItem;
        [_buttonItems addObject:cancelButtonItem];
        
        for (RPSTAlertViewButtonItem *buttonItem in otherButtonItems) {
            [self addButtonWithTitle:buttonItem.title];
            [_buttonItems addObject:buttonItem];
        }
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        if (self.cancelButtonItem.actionBlock) {
            self.cancelButtonItem.actionBlock();
        }
    }
    else {
        RPSTAlertViewButtonItem *item = [self.buttonItems objectAtIndex:buttonIndex];
        if (item.actionBlock) {
            item.actionBlock();
        }
    }
}

@end
