# WaterFallFlowLayout
瀑布流

## 使用方法

1. 创建 `TKWaterFallFlowLayout`
2. 设置属性
* delegate，设置代理，遵守协议方法
* columnCount  有几列。默认值 2
* columnSpacing  列间距。默认值 10.f
* rowSpacing  行间距。默认值 10.f
* sectionInset  collectionView内边距。默认值 UIEdgeInsetsZero
3. 实现代理方法

```
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        TKWaterFallFlowLayout *flowLayout = [[TKWaterFallFlowLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.columnCount = 3;
        flowLayout.columnSpacing = 5.f;
        flowLayout.rowSpacing = 5.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(10.f, 0.f, 0.f, 0.f);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:TKCollectionViewCell.class forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}

#pragma mark - TKWaterFallFlowLayout

- (CGFloat)layout:(TKWaterFallFlowLayout *)layout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    return [_heightArray objectAtIndex:index].doubleValue;
}

```
