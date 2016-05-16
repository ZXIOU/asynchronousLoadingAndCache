//
//  AXUContactPerson.h
//  Chat
//
//  Created by zxiou on 15-11-11.
//  Copyright © 2015年 Meng To. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXUContactPerson : NSObject

@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *nickname;
@property(nonatomic, strong) NSString *sex;
@property(nonatomic, strong) NSNumber *age;
@property(nonatomic, strong) NSString *birthday;
@property(nonatomic, strong) NSString *company;
@property(nonatomic, strong) NSString *phone;

@end
