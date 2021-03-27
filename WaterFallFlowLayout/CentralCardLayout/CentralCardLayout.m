//
//  CentralCardLayout.m
//  iOS_14_0_1
//
//  Created by hello on 2021/3/25.
//

#import "CentralCardLayout.h"


CGFloat maxScaleOffset = 200;
CGFloat minScale = 0.9;
CGFloat minAlpha = 0.3;

@interface CentralCardLayout ()

@end

@implementation CentralCardLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scaled = NO;
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.minimumLineSpacing = 25.f;
        
    }
    return self;
}


- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    [super invalidateLayoutWithContext:context];
    
    if (self.collectionView == nil) return;
    
    if (CGSizeEqualToSize(self.collectionView.bounds.size, self.lastCollectionViewSize)) {
        [self configureInset];
    }
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    if (!self.scaled) {
        return attribute;
    }
    
    [self centerScaledAttribute:attribute];
    
    return attribute;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray<__kindof UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];
    
    if (!self.scaled) {
        return attributes;
    }
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        [self centerScaledAttribute:attribute];
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    if (self.collectionView == nil) return proposedContentOffset;
    
    CGRect proposeRect = CGRectMake(proposedContentOffset.x,
                                    0,
                                    self.collectionView.bounds.size.width,
                                    self.collectionView.bounds.size.height);
    
    NSArray *layoutAttributes = [self layoutAttributesForElementsInRect:proposeRect];
    if (layoutAttributes == nil || layoutAttributes.count == 0) {
        return proposedContentOffset;
    }
    
    UICollectionViewLayoutAttributes *shouldBeChosenAttributes;
    
    int shouldBeChosenIndex = -1;
    
    CGFloat proposedCenterX = [self centerXWithRect:proposeRect];
    
    for (int i = 0; i < layoutAttributes.count; i ++) {
        UICollectionViewLayoutAttributes *attribute = layoutAttributes[i];
        
        
        if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
            continue;
        }
        
        UICollectionViewLayoutAttributes *currentChosenAttributes = shouldBeChosenAttributes;
        
        if (shouldBeChosenAttributes == nil) {
            shouldBeChosenAttributes = attribute;
            shouldBeChosenIndex = i;
            continue;
        }
        
        if (fabs([self centerXWithRect:attribute.frame] - proposedCenterX) < fabs([self centerXWithRect:currentChosenAttributes.frame] - proposedCenterX)) {
            shouldBeChosenAttributes = attribute;
            shouldBeChosenIndex = i;
        }
    }
    
    // Adjust the case where a quick but small scroll occurs.
    if (fabs(self.collectionView.contentOffset.x - proposedContentOffset.x) < self.itemSize.width) {
        
        if (velocity.x < -0.3) {
            shouldBeChosenIndex = shouldBeChosenIndex > 0 ? (shouldBeChosenIndex - 1) : shouldBeChosenIndex;
        } else if (velocity.x > 0.3) {
            shouldBeChosenIndex = (shouldBeChosenIndex < layoutAttributes.count - 1) ?
            (shouldBeChosenIndex + 1) : shouldBeChosenIndex;
        }
        
        if (shouldBeChosenIndex < layoutAttributes.count) {
            shouldBeChosenAttributes = layoutAttributes[shouldBeChosenIndex];
        }
    }
    
    UICollectionViewLayoutAttributes *finalAttributes = shouldBeChosenAttributes;
    if (finalAttributes == nil) {
        return proposedContentOffset;
    }
    
    return CGPointMake([self centerXWithRect:finalAttributes.frame] - CGRectGetWidth(self.collectionView.bounds)/2.f, proposedContentOffset.y);
}

- (CGFloat)centerXWithRect:(CGRect)rect {
    return CGRectGetMinX(rect) + CGRectGetWidth(rect)/2.f;;
}

#pragma mark - Private Methods

- (void)configureInset {
    if (self.collectionView == nil) return;
    
    CGFloat inset = self.collectionView.bounds.size.width/2.f - self.itemSize.width/2.f;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0.f, inset, 0.f, inset);
    
    self.collectionView.contentOffset = CGPointMake(-inset, 0.f);
}

- (void)centerScaledAttribute:(UICollectionViewLayoutAttributes *)attribute {
    if (self.collectionView == nil) return;
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    self.collectionView.bounds.size.width,
                                    self.collectionView.bounds.size.height);
    
    CGFloat visibleCenterX = CGRectGetMinX(visibleRect) + CGRectGetWidth(visibleRect)/2.f;
    CGFloat distanceFromCenter = visibleCenterX - attribute.center.x;
    CGFloat distance = MIN(fabs(distanceFromCenter), maxScaleOffset);
    CGFloat scale = distance * (minScale - 1) / maxScaleOffset + 1;
    attribute.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1);
    attribute.alpha = distance * (minAlpha - 1) / maxScaleOffset + 1;
}
@end
