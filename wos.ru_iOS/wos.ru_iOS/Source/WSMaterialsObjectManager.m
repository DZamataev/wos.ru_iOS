//
//  WSMaterialsObjectManager.m
//  wos.ru_iOS
//
//  Created by Denis on 4/21/14.
//  Copyright (c) 2014 DZamataev. All rights reserved.
//

#import "WSMaterialsObjectManager.h"
#import <RKXMLDictionarySerialization.h>

@implementation WSMaterialsObjectManager
/**
 This method is the `RKObjectManager` analog for the method of the same name on `AFHTTPClient`.
 */
//- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
//                                      path:(NSString *)path
//                                parameters:(NSDictionary *)parameters
//{
//    NSMutableURLRequest* request;
//    if (parameters && !([method isEqualToString:@"GET"] || [method isEqualToString:@"HEAD"] || [method isEqualToString:@"DELETE"])) {
//        // NOTE: If the HTTP client has been subclasses, then the developer may be trying to perform signing on the request
//        NSDictionary *parametersForClient = [self.HTTPClient isMemberOfClass:[AFHTTPClient class]] ? nil : parameters;
//        request = [self.HTTPClient requestWithMethod:method path:path parameters:parametersForClient];
//		
//        NSError *error = nil;
//        NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.HTTPClient.stringEncoding));
//        [request setValue:[NSString stringWithFormat:@"%@; charset=%@", self.requestSerializationMIMEType, charset] forHTTPHeaderField:@"Content-Type"];
//        // HACK: force XML serialization
////        NSData *requestBody = [RKMIMETypeSerialization dataFromObject:parameters MIMEType:self.requestSerializationMIMEType error:&error];
//        NSData *requestBody = [RKXMLDictionarySerialization dataFromObject:parameters error:&error];
//        [request setHTTPBody:requestBody];
//	} else {
//        request = [self.HTTPClient requestWithMethod:method path:path parameters:parameters];
//    }
//    
//	return request;
//}

@end
