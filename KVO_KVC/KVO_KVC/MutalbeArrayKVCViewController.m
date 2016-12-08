//
//  MutalbeArrayKVCViewController.m
//  KVO_KVC
//
//  Created by ddn on 16/12/8.
//  Copyright © 2016年 张永俊. All rights reserved.
//

/*
 而当对象的属性是可变的容器时，对于有序的容器，可以用下面的方法：
 
 - (NSMutableArray *)mutableArrayValueForKey:(NSString *)key;
 该方法返回一个可变有序数组，如果调用该方法，KVC的搜索顺序如下
 
 搜索insertObject:in<Key>AtIndex: , removeObjectFrom<Key>AtIndex: 或者 insert<Key>AdIndexes , remove<Key>AtIndexes 格式的方法
 如果至少找到一个insert方法和一个remove方法，那么同样返回一个可以响应NSMutableArray所有方法代理集合(类名是NSKeyValueFastMutableArray2)，那么给这个代理集合发送NSMutableArray的方法，以insertObject:in<Key>AtIndex: , removeObjectFrom<Key>AtIndex: 或者 insert<Key>AdIndexes , remove<Key>AtIndexes组合的形式调用。还有两个可选实现的接口：replaceOnjectAtIndex:withObject: , replace<Key>AtIndexes:with<Key>: 。
 如果上步的方法没有找到，则搜索set<Key>: 格式的方法，如果找到，那么发送给代理集合的NSMutableArray最终都会调用set<Key>:方法。 也就是说，mutableArrayValueForKey:取出的代理集合修改后，用·set<Key>:· 重新赋值回去去。这样做效率会低很多。所以推荐实现上面的方法。
 如果上一步的方法还还没有找到，再检查类方法+ (BOOL)accessInstanceVariablesDirectly,如果返回YES(默认行为)，会按_<key>,<key>,的顺序搜索成员变量名，如果找到，那么发送的NSMutableArray消息方法直接交给这个成员变量处理。
 如果还是找不到，调用valueForUndefinedKey:
 关于mutableArrayValueForKey:的适用场景，我在网上找了很多，发现其一般是用在对NSMutableArray添加Observer上。
 如果对象属性是个NSMutableAArray、NSMutableSet、NSMutableDictionary等集合类型时，你给它添加KVO时，你会发现当你添加或者移除元素时并不能接收到变化。因为KVO的本质是系统监测到某个属性的内存地址或常量改变时，会添加上- (void)willChangeValueForKey:(NSString *)key
 和- (void)didChangeValueForKey:(NSString *)key方法来发送通知，所以一种解决方法是手动调用者两个方法，但是并不推荐，你永远无法像系统一样真正知道这个元素什么时候被改变。另一种便是利用使用mutableArrayValueForKey:了。
 */
#import "MutalbeArrayKVCViewController.h"

@interface MutalbeArrayKVCViewController ()
@property (strong, nonatomic) NSMutableArray *arr;
@end

@implementation MutalbeArrayKVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arr = [NSMutableArray array];
    [self addObserver:self forKeyPath:@"arr" options:0x03 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@",change);
    
    //删除的元素change[@"old"]
    //添加的元素change[@"new"]
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"arr"];
}

//这样不能触发KVO
- (IBAction)addItem:(id)sender {
    [_arr addObject:@".."];
}

//这样可以触发KVO
- (IBAction)addItemObserver:(id)sender {
    [[self mutableArrayValueForKey:@"arr"] addObject:@"1"];
}

//这样可以触发KVO
- (IBAction)removeItemObserver:(id)sender {
    if (_arr.count > 0) {
        [[self mutableArrayValueForKey:@"arr"] removeLastObject];
    }
}

@end
