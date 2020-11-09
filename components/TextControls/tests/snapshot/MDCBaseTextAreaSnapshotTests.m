// Copyright 2020-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "MDCBaseTextAreaSnapshotTests.h"

#import <UIKit/UIKit.h>

#import "supplemental/MDCTextControlSnapshotTestHelpers.h"
#import "MDCBaseTextArea.h"

@interface MDCBaseTextArea (AnimationDuration)
@property(nonatomic, assign) NSTimeInterval animationDuration;
@end

@interface MDCBaseTextAreaSnapshotTests ()
@property(strong, nonatomic) MDCBaseTextArea *textArea;
@property(nonatomic, assign) BOOL areAnimationsEnabled;
@end

@implementation MDCBaseTextAreaSnapshotTests

- (void)setUp {
  [super setUp];

  self.areAnimationsEnabled = UIView.areAnimationsEnabled;
  [UIView setAnimationsEnabled:NO];
  [MDCTextControlSnapshotTestHelpers setUpViewControllerHierarchy];

  self.textArea = [self createTextAreaWithFrame:[self defaultTextAreaFrame]];
  [self prepareTextAreaForSnapshotTesting:self.textArea];
}

- (void)tearDown {
  [super tearDown];
  [MDCTextControlSnapshotTestHelpers
      removeTextControlFromViewHierarchy:(UIView<MDCTextControl> *)self.textArea];
  self.textArea = nil;
  [MDCTextControlSnapshotTestHelpers tearDownViewControllerHierarchy];
  [UIView setAnimationsEnabled:self.areAnimationsEnabled];
}

- (MDCBaseTextArea *)createTextAreaWithFrame:(CGRect)frame {
  MDCBaseTextArea *textArea = [[MDCBaseTextArea alloc] initWithFrame:frame];
  textArea.layer.cornerRadius = 2;
  textArea.layer.borderColor = [UIColor lightGrayColor].CGColor;
  textArea.layer.borderWidth = 1;
  return textArea;
}

- (CGRect)defaultTextAreaFrame {
  return CGRectMake(0, 0, 200, 200);
}

- (void)prepareTextAreaForSnapshotTesting:(MDCBaseTextArea *)textArea {
  // Set the animation duration to 0 so we don't take a snapshot during an animation
  textArea.animationDuration = 0;

  // Use a dummy inputView instead of the system keyboard because it cuts the execution time roughly
  // in half, at least locally.
  UIView *dummyInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  textArea.textView.inputView = dummyInputView;

  // Add the text field to a valid view hierarchy so things like `-becomeFirstResponder` work
  UIView<MDCTextControl> *textControl = (UIView<MDCTextControl> *)textArea;
  [MDCTextControlSnapshotTestHelpers addTextControlToViewHierarchy:textControl];
}

- (void)validateTextArea:(MDCBaseTextArea *)textArea {
  [MDCTextControlSnapshotTestHelpers validateTextControl:(UIView<MDCTextControl> *)textArea
                                            withTestCase:self];
}

#pragma mark - Tests

- (void)testTextAreaWithText {
  // Given
  MDCBaseTextArea *textArea = self.textArea;

  // When
  textArea.textView.text = @"This is some text.";

  // Then
  [self validateTextArea:textArea];
}

@end
