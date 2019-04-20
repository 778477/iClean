//
//  CCApplication.m
//  iCleaner
//
//  Created by miaoyou.gmy on 2019/4/13.
//  Copyright © 2019 miaoyou.gmy. All rights reserved.
//

#import "CCApplication.h"

@implementation CCApplication

- (void)sendEvent:(NSEvent *)event{
    if(event.type == NSEventTypeKeyDown){
        if (([event modifierFlags] & NSEventModifierFlagDeviceIndependentFlagsMask) == NSEventModifierFlagCommand) {
            
            // command + del
            if([event keyCode] == 51){
                if([self sendAction:@selector(detele:) to:nil from:self]) return;
            }
            
            if ([[event charactersIgnoringModifiers] isEqualToString:@"x"]) {
                if ([self sendAction:@selector(cut:) to:nil from:self])
                    return;
            }
            else if ([[event charactersIgnoringModifiers] isEqualToString:@"c"]) {
                if ([self sendAction:@selector(copy:) to:nil from:self])
                    return;
            }
            else if ([[event charactersIgnoringModifiers] isEqualToString:@"v"]) {
                if ([self sendAction:@selector(paste:) to:nil from:self])
                    return;
            }
            else if ([[event charactersIgnoringModifiers] isEqualToString:@"z"]) {
                if ([self sendAction:@selector(undo:) to:nil from:self])
                    return;
            }
            else if ([[event charactersIgnoringModifiers] isEqualToString:@"a"]) {
                if ([self sendAction:@selector(selectAll:) to:nil from:self])
                    return;
            }
        }
    }
    [super sendEvent:event];
}


// Blank Selectors to silence Xcode warnings: 'Undeclared selector undo:/redo:'
- (IBAction)undo:(id)sender {}
- (IBAction)redo:(id)sender {}
- (IBAction)enter:(id)sender {}
- (IBAction)detele:(id)sender {}
@end
