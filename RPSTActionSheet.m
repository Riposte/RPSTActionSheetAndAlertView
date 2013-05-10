//
//  RPSTActionSheet.m
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

#import "RPSTActionSheet.h"

@implementation RPSTActionSheetButtonItem

- (id)initWithTitle:(NSString *)title actionBlock:(RPSTActionSheetActionBlock)actionBlock {
    self = [super init];
    if (self) {
        _title = [title copy];
        _actionBlock = [actionBlock copy];
    }
    return self;
}

@end

@interface RPSTActionSheet () <UIActionSheetDelegate>

@property (strong, nonatomic) RPSTActionSheetButtonItem *cancelButtonItem;
@property (strong, nonatomic) RPSTActionSheetButtonItem *destructiveButtonItem;
@property (strong, nonatomic) NSMutableArray *buttonItems;

@end

@implementation RPSTActionSheet

- (id)initWithTitle:(NSString *)optionalTitle
    cancelButtonItem:(RPSTActionSheetButtonItem *)cancelButtonItem
    destructiveButtonItem:(RPSTActionSheetButtonItem *)destructiveButtonItem
    otherButtonItems:(NSArray *)otherButtonItems {
    
    self = [super initWithTitle:optionalTitle
                       delegate:nil
              cancelButtonTitle:nil
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
    if (self) {
        self.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        _cancelButtonItem = cancelButtonItem;
        _destructiveButtonItem = destructiveButtonItem;
        if (otherButtonItems.count) {
            _buttonItems = [NSMutableArray arrayWithCapacity:otherButtonItems.count];
            for (RPSTActionSheetButtonItem *buttonItem in otherButtonItems) {
                [_buttonItems addObject:buttonItem];
                [self addButtonWithTitle:buttonItem.title];
            }
        }
        NSInteger buttonCount = _buttonItems.count;
        if (destructiveButtonItem) {
            [self addButtonWithTitle:destructiveButtonItem.title];
            [self setDestructiveButtonIndex:buttonCount];
            buttonCount += 1;
        }
        if (cancelButtonItem) {
            [self addButtonWithTitle:cancelButtonItem.title];
            [self setCancelButtonIndex:buttonCount];
        }
        self.delegate = self;
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        if (self.cancelButtonItem.actionBlock) {
            self.cancelButtonItem.actionBlock();
        }
    }
    else if (buttonIndex == actionSheet.destructiveButtonIndex) {
        if (self.destructiveButtonItem.actionBlock) {
            self.destructiveButtonItem.actionBlock();
        }
    }
    else {
        RPSTActionSheetButtonItem *item = [self.buttonItems objectAtIndex:buttonIndex];
        if (item.actionBlock) {
            item.actionBlock();
        }
    }
}

@end



