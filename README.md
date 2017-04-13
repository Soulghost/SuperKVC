# SuperKVC

SuperKVC is a light-weight injection framework to convert JSON to Model. SuperKVC has its own config DSL which provides a chainable way of describing your injection config concise and readable. SuperKVC supports iOS and macOS.

Samples are at the **SuperKVCDemo** project in the SuperKVC workspace. There are three sample to show shallow and deep injection configurations.

## What's wrong with KVC?
Apple provide KVC for us to inject dictionary to model, but it cannot solve problems below.

1. KVC simplely mapping the dictionary key to model key, but many times their name are not the same. For example, `id` is a keyword in Objective-C while not a keyword in backend, so many network interface response `id` as a key, in Objective-C model, we may use `userId`, so `id` cannot mapping to `userId`, if we use KVC in this time, the app will crash because there are not a `id` property in the model.

2. KVC cannot handle data format convert, for example, our `UserModel` has a `NSDate` property `birthday`, while the network interface response a `date string`, we need to use  `NSDateFormatter` to convert, but KVC cannot config a converter, so it inject a `NSString` to a `NSDate` property.

3. KVC cannot handle deep injection, for example, our `UserModel` has a `CardModel` property `card`, while the network interface response a `NSDictionary`, we need to inject the dictionary to card property, but KVC only inject one level.

## Prepare to meet your Injector!
Think about we have the response and the model structure below.

```json
{
    "id": 100075,
    "name": "Greedy",
    "birthday": "1993-03-06",
    "isVip": true,
    "partners": [100236, 100244, 100083]
}
```

```objc
@interface UserModel : NSObject

@property (nonatomic, assign) int64_t userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, assign) BOOL isVip;
@property (nonatomic, strong) NSArray *partners;

@end
```

Now we need to convert json to `UserModel` instance, please note that the response key `id` is called `userId` in the model, and the `birthday` property type is not a `NSString`. By using SuperKVC, you even not need to create the model, tell the injector your config, and it returns what you want.

```objc
// responseObject is a JSONObject(NSDictionary).
UserModel *userModel = [responseObject sk_injectWithInjector:^(SuperKVCInjector *injector) {
    injector.bind([UserModel class]);
    injector.mapping(@"id").to(@"userId");
    injector.format(@"birthday").with.converter(^NSDate* (NSString *birthdayString) {
        NSDateFormatter *fmt = [NSDateFormatter new];
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt dateFromString:birthdayString];
    });
}];
```

The config descriptions are below. 

|Name|Function|Usage|
|:---:|:---:|:---:|
|bind|tell the injector what model should be created and injected.|injector.bind(#Class#);|
|mapping|tell the injector to mapping the response key to another property name.|injector.mapping(#responseKey#).to(#propertyName#);|
|format|format a property with a block filter.|injector.format(#propertyName#).with.converter(^id (id oldVar) { /* your format code */ return #newVar#; });|
|ignore|ignore some property which should not be injected. note that ignores can be joined by `and` in one line.|injector.ignore(#propName1#).and(#propName2#) ...|
|synthesize|to tell the injector mapping a property to a specific ivar. such as when @synthesize userId = userId_, the injector cannot get ivar by default|injector.synthesize(#propertyName#).to(#ivarName#);|

## Array Injection
Think about we have another json below.

```json
[{
    "id": 100075,
    "name": "Greedy",
    "birthday": "1993-03-06",
    "isVip": true,
    "partners": [100236, 100244, 100083]
},
{
    "id": 100724,
    "name": "Charlie",
    "birthday": "1996-08-12",
    "isVip": false,
    "partners": [100710, 100715]
},{},]
```

We needn't to modify any codes to get a `UserModel` array.

```objc
// responseObject is a JSONObject(NSArray).
NSArray<UserModel *> *userModels = [responseObject sk_injectWithInjector:^(SuperKVCInjector *injector) {
    injector.bind([UserModel class]);
    injector.mapping(@"id").to(@"userId");
    injector.format(@"birthday").with.converter(^NSDate* (NSString *birthdayString) {
        NSDateFormatter *fmt = [NSDateFormatter new];
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt dateFromString:birthdayString];
    });
}];
```

## Deep Injection
Think about we have a two level json.

```json
[{
    "id": 100075,
    "name": "Greedy",
    "birthday": "1993-03-06",
    "isVip": false,
    "cards": [
        {
            "id": 400820666,
            "name": "King Card of Unity",
            "expire": "2026-03-27"
        },
        {
            "id": 622800333,
            "name": "Silver Card of Glory",
            "expire": "2029-02-21"
        },
        {
            "id": 623400765,
            "name": "King Card of Floyt",
            "expire": "2024-08-15"
        }
    ]
},{},]
```

And our class structures are below.

```objc
@interface UserModel : NSObject

@property (nonatomic, assign) int64_t userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, assign) BOOL isVip;
@property (nonatomic, strong) NSArray<CardModel *> *cards;

@end

@interface CardModel : NSObject

@property (nonatomic, assign) int64_t cardId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *expireDate;

@end
```

To make a deep injection, we need to use the converter to nested call injector on the `cards` property.
To be efficient, we create the `NSDateFormatter` out of the block and resue it.

```objc
// responseObject is a JSONObject(NSArray).
NSDateFormatter *fmt = [NSDateFormatter new];
fmt.dateFormat = @"yyyy-MM-dd";
NSArray *userArray = [responseObject sk_injectWithInjector:^(SuperKVCInjector *injector) {
    injector.bind([UserModel class]);
    injector.mapping(@"id").to(@"userId");
    injector.format(@"birthday").with.converter(^NSDate* (NSString *birthdayString) {
        return [fmt dateFromString:birthdayString];
    });
    injector.format(@"cards").with.converter(^CardModel* (NSDictionary *cardDictArray) {
        return [cardDictArray sk_dequeInjectorForClass:[CardModel class] emptyHandler:^(SuperKVCInjector *injector) {
            injector.bind([CardModel class]);
            injector.mapping(@"id").to(@"cardId");
            injector.mapping(@"expire").to(@"expireDate");
            injector.format(@"expireDate").with.converter(^NSDate* (NSString *birthdayString) {
                return [fmt dateFromString:birthdayString];
            });
        }];
    });
}];
```

Please note that we use `sk_dequeInjectorForClass::` method in the nested call, it can handle injector reuse for class to improve execution efficiency.

## Installation
1. Clone the repo, and drag the `SuperKVC` folder to your project.
2. `#import "SuperKVC.h"`

## Cache Configuration
The SuperKVC framework cached reflection result and injector configuration in memory using a 10 limit LRU(NSCache), you can change the limit or clear cache by the property `cacheLimit` and the method `claerCache` in `SKVManager` singleton.

## TODO
- Disk cache.
- More tests and examples. 
