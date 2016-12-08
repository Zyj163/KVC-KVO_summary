//
//  KVCSetViewController.m
//  KVO_KVC
//
//  Created by ddn on 16/12/7.
//  Copyright © 2016年 张永俊. All rights reserved.
//

//http://www.jianshu.com/p/45cbd324ea65
/*
 当调用setValue：属性值 forKey：@”name“的代码时，底层的执行机制如下：
 
 程序优先调用set<Key>:属性值方法，代码通过setter方法完成设置。注意，这里的<key>是指成员变量名，首字母大清写要符合KVC的全名规则，下同
 如果没有找到setName：方法，KVC机制会检查+ (BOOL)accessInstanceVariablesDirectly方法有没有返回YES，默认该方法会返回YES，如果你重写了该方法让其返回NO的话，那么在这一步KVC会执行setValue：forUNdefinedKey：方法，不过一般开发者不会这么做。所以KVC机制会搜索该类里面有没有名为_<key>的成员变量，无论该变量是在类接口部分定义，还是在类实现部分定义，也无论用了什么样的访问修饰符，只在存在以_<key>命名的变量，KVC都可以对该成员变量赋值。
 如果该类即没有set<Key>：方法，也没有_<key>成员变量，KVC机制会搜索_is<Key>的成员变量，
 和上面一样，如果该类即没有set<Key>：方法，也没有_<key>和_is<Key>成员变量，KVC机制再会继续搜索<key>和is<Key>的成员变量。再给它们赋值。
 如果上面列出的方法或者成员变量都不存在，系统将会执行该对象的setValue：forUNdefinedKey：方法，默认是抛出异常。
 如果开发者想让这个类禁用KVC里，那么重写+ (BOOL)accessInstanceVariablesDirectly方法让其返回NO即可，这样的话如果KVC没有找到set<Key>:属性名时，会直接用setValue：forUNdefinedKey：方法。
 */
#import "KVCSetViewController.h"

@interface KVCSetViewController ()
{
    NSString *_name;
}
@end

@implementation KVCSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setValue:@"zhangsan" forKey:@"name"];
}

+ (BOOL)accessInstanceVariablesDirectly {
    NSLog(@"%s",__func__);
    return YES;
}

- (void)setName:(NSString *)name {
    NSLog(@"%s", __func__);
    _name = name;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%s", __func__);
    [super setValue:value forUndefinedKey:key];
}


@end
