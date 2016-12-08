//
//  KVCGetViewController.m
//  KVO_KVC
//
//  Created by ddn on 16/12/7.
//  Copyright © 2016年 张永俊. All rights reserved.
//

//http://www.jianshu.com/p/45cbd324ea65
/*
 当调用ValueforKey：@”name“的代码时，KVC对key的搜索方式不同于setValue：属性值 forKey：@”name“，其搜索方式如下
 
 首先按get<Key>,<key>,is<Key>的顺序方法查找getter方法，找到的话会直接调用。如果是BOOL或者int等值类型， 会做NSNumber转换
 如果上面的getter没有找到并且没有对应的实例变量(key, _key)，KVC则会查找countOf<Key>,objectIn<Key>AtIndex,<Key>AtIndex格式的方法。如果countOf<Key>和另外两个方法中的要个被找到，那么就会返回一个可以响应NSArray所的方法的代理集合(它是NSKeyValueArray，是NSArray的子类)，调用这个代理集合的方法，或者说给这个代理集合发送NSArray的方法，就会以countOf<Key>,objectIn<Key>AtIndex,<Key>AtIndex这几个方法组合的形式调用。还有一个可选的get<Ket>:range:方法。所以你想重新定义KVC的一些功能，你可以添加这些方法，需要注意的是你的方法名要符合KVC的标准命名方法，包括方法签名。
 如果上面的方法没有找到，那么会查找countOf<Key>，enumeratorOf<Key>,memberOf<Key>格式的方法。如果这三个方法都找到，那么就返回一个可以响应NSSet所的方法的代理集合，以送给这个代理集合消息方法，就会以countOf<Key>，enumeratorOf<Key>,memberOf<Key>组合的形式调用。
 如果还没有找到，再检查类方法+ (BOOL)accessInstanceVariablesDirectly,如果返回YES(默认行为)，那么和先前的设值一样，会按_<key>,_is<Key>,<key>,is<Key>的顺序搜索成员变量名，这里不推荐这么做，因为这样直接访问实例变量破坏了封装性，使代码更脆弱。如果重写了类方法+ (BOOL)accessInstanceVariablesDirectly返回NO的话，那么会直接调用valueForUndefinedKey:
 还没有找到的话，调用valueForUndefinedKey:
 */
#import "KVCGetViewController.h"

@interface KVCGetViewController ()
{
    NSString *_name;
    NSUInteger _count;
    NSArray *_num;
}
@end

@implementation KVCGetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _name = @"zhangsan";
    
    if ([self respondsToSelector:NSSelectorFromString(@"getName")] || [self respondsToSelector:NSSelectorFromString(@"name")] || [self respondsToSelector:NSSelectorFromString(@"isName")]) {
        NSLog(@"===============");
    }
    
    NSLog(@"%@", [self valueForKey:@"name"]);
    
    id s = [self valueForKey:@"num"];
    NSLog(@"%@,%@", s, NSStringFromClass([s class]));
    
    [self incrementCount];
    NSLog(@"%@,%@", s, NSStringFromClass([s class]));
    
    [self incrementCount];
    NSLog(@"%@,%@", s, NSStringFromClass([s class]));
}

- (NSString *)getName {
    NSLog(@"%s", __func__);
    return _name;
}

- (NSUInteger)countOfNum {
    NSLog(@"%s", __func__);
    return _count;
}

- (void)incrementCount {
    NSLog(@"%s", __func__);
    _count ++;
}

- (id)objectInNumAtIndex:(NSUInteger)index {
    NSLog(@"%s", __func__);
    return @(index * 2);
}

@end
