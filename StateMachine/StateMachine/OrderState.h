//
//  OrderState.h
//  StateMachine
//
//  Created by fenglin on 7/1/16.
//  Copyright © 2016 fenglin. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, OrderStatus) {
    NoOrder = 0,       //没有订单
    AcceptOrder,      //接收到订单
    TakeCarPhoto,    //拍汽车照
    TakeKeyPhoto,   //拍车钥匙照片
    GetCarKey,         //拿到车钥匙页面
    GetCar,           //拿到车的页面
    LeaveGarage,     //离开车库。
    OrderFinished   //订单完成
};

@interface OrderState : NSObject

@property (nonatomic ,assign) OrderStatus orderStatus;

@end
