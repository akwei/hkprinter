//
//  WBluetoothPort.h
//  StarIOPort
//
//  Created by u3237 on 12/10/22.
//
//

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>

#ifdef TARGET_OS_IPHONE
#ifdef BUILDING_STARIO
#include <starmicronics/StarIOPort.h>
#else
#include <StarIO/starmicronics/StarIOPort.h>

#endif
#else
#include <starmicronics/StarIOPort.h>
#endif

@interface WBluetoothPort : NSObject<NSStreamDelegate> {
    NSString *portName_;
    NSString *portSettings_;
    u_int32_t timeout_;
    
    EAAccessory* _selectedAccessory;
    EASession* _session;
    
    NSMutableData *_writeData;
    NSMutableData *_readData;
}
@property (readonly, getter = isConnected) BOOL connected;

+ (BOOL)matchPort:(NSString *)portName portSettings:(NSString *)portSettings;
- (id)initWithPortName:(NSString *)portName portSettings:(NSString *)portSettings timeout:(u_int32_t)timeout;
- (void)dealloc;
- (BOOL)open;
- (u_int32_t)write:(NSData *)data;
- (NSData * )read:(NSUInteger)bytesToRead;
- (BOOL)getParsedStatus:(StarPrinterStatus_2 *)starPrinterStatus level:(u_int32_t)level;
- (BOOL)getOnlineStatus:(BOOL *)onlineStatus;
- (BOOL)beginCheckedBlock;
- (BOOL)endCheckedBlock;
- (BOOL)isConnected;
- (void)close;

@end
