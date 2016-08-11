//
//  SFlowLayout.m
//  SFlowLayout
//
//  Created by tongxuan on 16/8/11.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "SBrowsePhotoFlowLayout.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width

#define MaxChangeRange 100

@implementation SBrowsePhotoFlowLayout

-(void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(300, 500);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    for (UICollectionViewLayoutAttributes *attr in array)
    {
        if (CGRectIntersectsRect(attr.frame, rect)) {
            
            BOOL isAtRight = YES;
            CGFloat distance = (attr.center.x - CGRectGetMidX(visibleRect));
            if (distance<0) {
                distance = -distance;
                isAtRight = NO;
            }
            CGFloat precent ;
            if (distance < 160)
            {
                precent = 1.0;
            }
            else
            {
                precent = ((screenWidth / 2) - distance) / (screenWidth / 2 -160);
            }
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0 / 600;
            
            if (precent < 0.5) {
                precent = 0.5;
            }
            transform = CATransform3DScale(transform, 1, precent, 1);
            CGFloat p = isAtRight?M_PI_4:-M_PI_4;
            transform = CATransform3DRotate(transform, p * (1 - precent), 0, 1, 0);
            attr.transform3D = transform;
            attr.zIndex = 1;
            attr.alpha = precent; 
        }
    }
    
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offset = MAXFLOAT;
    
    CGFloat hCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect currentRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray* array = [super layoutAttributesForElementsInRect:currentRect];
    for (UICollectionViewLayoutAttributes* layoutAttributes in array)
    {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - hCenter) < ABS(offset))
        {
            
            offset = itemHorizontalCenter - hCenter;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offset, proposedContentOffset.y);
}

@end
