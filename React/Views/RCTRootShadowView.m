/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTRootShadowView.h"

#import "RCTI18nUtil.h"

@implementation RCTRootShadowView

/**
 * Init the RCTRootShadowView with RTL status.
 * Returns a RTL CSS layout if isRTL is true (Default is LTR CSS layout).
 */
- (instancetype)init
{
  self = [super init];
  if (self) {
    _baseDirection = [[RCTI18nUtil sharedInstance] isRTL] ? YGDirectionRTL : YGDirectionLTR;
    _availableSize = CGSizeMake(INFINITY, INFINITY);
  }
  return self;
}

- (NSSet<RCTShadowView *> *)collectViewsWithUpdatedFrames
{
  // Treating `INFINITY` as `YGUndefined` (which equals `NAN`).
  float availableWidth = _availableSize.width == INFINITY ? YGUndefined : _availableSize.width;
  float availableHeight = _availableSize.height == INFINITY ? YGUndefined : _availableSize.height;

  YGUnit widthUnit = YGNodeStyleGetWidth(self.yogaNode).unit;
  if (widthUnit == YGUnitUndefined || widthUnit == YGUnitAuto) {
    YGNodeStyleSetWidthPercent(self.yogaNode, 100);
  }

  YGUnit heightUnit = YGNodeStyleGetHeight(self.yogaNode).unit;
  if (heightUnit == YGUnitUndefined || heightUnit == YGUnitAuto) {
    YGNodeStyleSetHeightPercent(self.yogaNode, 100);
  }

  YGNodeCalculateLayout(self.yogaNode, availableWidth, availableHeight, _baseDirection);

  NSMutableSet<RCTShadowView *> *viewsWithNewFrame = [NSMutableSet set];
  [self applyLayoutNode:self.yogaNode viewsWithNewFrame:viewsWithNewFrame absolutePosition:CGPointZero];
  return viewsWithNewFrame;
}

@end
