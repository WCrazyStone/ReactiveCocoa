//
//  UIGestureRecognizer+RACSupport.m
//  Talks
//
//  Created by Josh Vera on 5/5/13.
//  Copyright (c) 2013 GitHub. All rights reserved.
//

#import "UIGestureRecognizer+RACSupport.h"
#import "EXTScope.h"
#import "NSObject+RACDeallocating.h"
#import "RACCompoundDisposable.h"
#import "RACDisposable.h"
#import "RACSignal.h"
#import "RACSubscriber.h"
#import "NSObject+RACDescription.h"

@implementation UIGestureRecognizer (RACSupport)

- (RACSignal *)rac_gestureSignal {
	@weakify(self);

	return [[RACSignal
		createSignal:^(id<RACSubscriber> subscriber) {
			@strongify(self);

			[self addTarget:subscriber action:@selector(sendNext:)];
			[self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
				[subscriber sendCompleted];
			}]];

			return [RACDisposable disposableWithBlock:^{
				@strongify(self);
				[self removeTarget:subscriber action:@selector(sendNext:)];
			}];
		}]
		setNameWithFormat:@"%@ -rac_gestureSignal", [self rac_description]];
}

@end