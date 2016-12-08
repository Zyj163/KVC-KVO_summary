//
//  ViewController.m
//  KVO_KVC
//
//  Created by ddn on 16/12/6.
//  Copyright © 2016年 张永俊. All rights reserved.
//

//http://nshipster.cn/kvc-collection-operators/
#import "ViewController.h"



@interface NSString (mmm)

@end

@implementation NSString (mmm)

- (BOOL)prefix {
    return [self hasPrefix:@"e"];
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //数组和集合操作符
    [self composeArrays];
    
    //简单集合操作符
    [self calculate];
    
    //对象操作符
    [self makeUpArrayFromObjArray];
    
    //同时操作数组中的每个元素
    [self doWithAll];
}

/*
 数组和集合操作符作用对象是嵌套的集合，也就是说，是一个集合且其内部每个元素是一个集合。数组和集合操作符包括 @distinctUnionOfArrays，@unionOfArrays，@distinctUnionOfSets:
 
 @distinctUnionOfArrays / @unionOfArrays 返回一个数组，其中包含这个集合中每个数组对于这个操作符右面指定的 key path 进行操作之后的值。 distinct 版本会移除重复的值。
 @distinctUnionOfSets 和 @distinctUnionOfArrays 差不多, 但是它期望的是一个包含着 NSSet 对象的 NSSet ，并且会返回一个 NSSet 对象。因为集合不能包含重复的值，所以它只有 distinct 操作。
 返回的是一个数组或者集合
 */
- (void)composeArrays {
    NSArray *a = @[@1, @2, @3];
    NSArray *b = @[@3, @4, @5];
    NSArray *c = @[@5, @6, @7];
    
    NSArray *d = [@[a, b, c] valueForKeyPath:@"@unionOfArrays.self"];
    NSLog(@"数组合并===============%@", d);
    
    NSArray *e = [@[a, b, c] valueForKeyPath:@"@distinctUnionOfArrays.self"];
    NSLog(@"数组合并并去重===============%@", e);
}

/*
 对象操作符包括 @distinctUnionOfObjects 和 @unionOfObjects, 返回一个由操作符右边的 key path 所指定的对象属性组成的数组。其中 @distinctUnionOfObjects 会对数组去重，而 @unionOfObjects 不会
 返回的是一个数组
 */
- (void)makeUpArrayFromObjArray {
    NSMutableArray *ma = [NSMutableArray array];
    int i = 10;
    while (i > 0) {
        NSDictionary *d = @{@"name": [NSString stringWithFormat:@"zhangsan%d", i]};
        [ma addObject:d];
        [ma addObject:d];
        i--;
    }
    NSArray *a = [ma valueForKeyPath:@"@unionOfObjects.name"];
    NSArray *aa = [ma valueForKeyPath:@"name"];//简写
    NSLog(@"提取属性组成数组=======%@, %@",a, aa);
    
    NSArray *b = [ma valueForKeyPath:@"@distinctUnionOfObjects.name"];
    NSLog(@"提取属性组成数组并去重=======%@",b);
}

/*
 集合操作是以 @ 开始的字符串
 格式：
 keypathToCollection.@collectionOperator.keypathToProperty
 其中左边的键路径(keypathToCollection)指定了相对消息接收者的 NSArray 或者 NSSet，右边的键路径(keypathToProperty)指定了相对于集合内对象的键路径，集合操作作用于该键路径
 对于数组 @[@(1), @(2), @(3)] 可使用 valueForKeyPath:@"@max.self" 来获取
 返回的是strings, number, 或者 dates
 */
- (void)calculate {
    NSMutableArray *ma = [NSMutableArray array];
    int i = 10;
    while (i > 0) {
        NSDictionary *d = @{@"price": @(i)};
        [ma addObject:d];
        i--;
    }
    
    NSLog(@"数组个数========%@", [ma valueForKeyPath:@"@count"]);
    NSLog(@"求和========%@", [ma valueForKeyPath:@"@sum.price"]);
    NSLog(@"最大值========%@", [ma valueForKeyPath:@"@max.price"]);
    NSLog(@"最小值========%@", [ma valueForKeyPath:@"@min.price"]);
    NSLog(@"平均值========%@", [ma valueForKeyPath:@"@avg.price"]);
}

- (void)doWithAll {
    NSString *one = @"english";
    NSString *two = @"china";
    NSArray *a = @[one, two];
    
    NSArray *b = [a valueForKey:@"capitalizedString"];//首字母大写
    
    NSLog(@"对数组中的每个元素执行相同的操作，并返回========%@",b);
    
    NSArray *c = [a valueForKey:@"length"];//获取长度
    
    NSLog(@"对数组中的每个元素执行相同的操作，并返回========%@",c);
    
    NSArray *d = [a valueForKey:@"prefix"];//自定义方法(不知道怎么传参。。。)
    
    NSLog(@"对数组中的每个元素执行相同的操作，并返回========%@",d);
}

@end










