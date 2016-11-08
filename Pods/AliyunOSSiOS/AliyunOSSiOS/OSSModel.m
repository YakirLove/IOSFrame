//
//  OSSModel.m
//  oss_ios_sdk
//
//  Created by zhouzhuo on 8/16/15.
//  Copyright (c) 2015 aliyun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Bolts/Bolts.h>
#import "OSSModel.h"
#import "OSSUtil.h"
#import "OSSNetworking.h"
#import "OSSLog.h"
#import "OSSXMLDictionary.h"

NSString * const OSSListBucketResultXMLTOKEN = @"ListBucketResult";
NSString * const OSSNameXMLTOKEN = @"Name";
NSString * const OSSDelimiterXMLTOKEN = @"Delimiter";
NSString * const OSSMarkerXMLTOKEN = @"Marker";
NSString * const OSSMaxKeyXMLTOKEN = @"MaxKeys";
NSString * const OSSIsTruncatedXMLTOKEN = @"IsTruncated";
NSString * const OSSContentXMLTOKEN = @"Contents";
NSString * const OSSKeyXMLTOKEN = @"Key";
NSString * const OSSLastModifiedXMLTOKEN = @"LastModified";
NSString * const OSSETagXMLTOKEN = @"ETag";
NSString * const OSSTypeXMLTOKEN = @"Type";
NSString * const OSSSizeXMLTOKEN = @"Size";
NSString * const OSSStorageClassXMLTOKEN = @"StorageClass";
NSString * const OSSCommonPrefixesXMLTOKEN = @"CommonPrefixes";
NSString * const OSSPrefixXMLTOKEN = @"Prefix";
NSString * const OSSUploadIdXMLTOKEN = @"UploadId";
NSString * const OSSLocationXMLTOKEN = @"Location";
NSString * const OSSNextPartNumberMarkerXMLTOKEN = @"NextPartNumberMarker";
NSString * const OSSMaxPartsXMLTOKEN = @"MaxParts";
NSString * const OSSPartXMLTOKEN = @"Part";
NSString * const OSSPartNumberXMLTOKEN = @"PartNumber";

NSString * const OSSClientErrorDomain = @"com.aliyun.oss.clientError";
NSString * const OSSServerErrorDomain = @"com.aliyun.oss.serverError";

NSString * const OSSErrorMessageTOKEN = @"ErrorMessage";

NSString * const OSSUAPrefix = @"MBAAS_OSS_IOS";
NSString * const OSSSDKVersion = @"2.0.2";

NSString * const OSSHttpHeaderContentDisposition = @"Content-Disposition";
NSString * const OSSHttpHeaderContentEncoding = @"Content-Encoding";
NSString * const OSSHttpHeaderContentType = @"Content-Type";
NSString * const OSSHttpHeaderContentMD5 = @"Content-MD5";
NSString * const OSSHttpHeaderCacheControl = @"Cache-Control";
NSString * const OSSHttpHeaderExpires = @"Expires";

@implementation NSString (OSS)

- (NSString *)oss_stringByAppendingPathComponentForURL:(NSString *)aString {
    if ([self hasSuffix:@"/"]) {
        return [NSString stringWithFormat:@"%@%@", self, aString];
    } else {
        return [NSString stringWithFormat:@"%@/%@", self, aString];
    }
}

@end

@implementation NSDate (OSS)

NSString * const serverReturnDateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";

static NSTimeInterval _clockSkew = 0.0;

+ (void)oss_setClockSkew:(NSTimeInterval)clockSkew {
    @synchronized(self) {
        _clockSkew = clockSkew;
    }
}

+ (NSDate *)oss_clockSkewFixedDate {
    NSTimeInterval skew = 0.0;
    @synchronized(self) {
        skew = _clockSkew;
    }
    return [[NSDate date] dateByAddingTimeInterval:(-1 * skew)];
}

+ (NSDate *)oss_dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = serverReturnDateFormat;

    return [dateFormatter dateFromString:string];
}

- (NSString *)oss_asStringValue {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = serverReturnDateFormat;

    return [dateFormatter stringFromDate:self];
}

@end

@implementation OSSSyncMutableDictionary

- (instancetype)init {
    if (self = [super init]) {
        _dictionary = [NSMutableDictionary new];
        _dispatchQueue = dispatch_queue_create("com.aliyun.aliyunsycmutabledictionary", DISPATCH_QUEUE_SERIAL);
    }

    return self;
}

- (NSArray *)allKeys {
    __block NSArray *allKeys = nil;
    dispatch_sync(self.dispatchQueue, ^{
        allKeys = [self.dictionary allKeys];
    });
    return allKeys;
}

- (id)objectForKey:(id)aKey {
    __block id returnObject = nil;

    dispatch_sync(self.dispatchQueue, ^{
        returnObject = [self.dictionary objectForKey:aKey];
    });

    return returnObject;
}

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey {
    dispatch_sync(self.dispatchQueue, ^{
        [self.dictionary setObject:anObject forKey:aKey];
    });
}

- (void)removeObjectForKey:(id)aKey {
    dispatch_sync(self.dispatchQueue, ^{
        [self.dictionary removeObjectForKey:aKey];
    });
}

@end

@implementation OSSFederationToken
@end

@implementation OSSPlainTextAKSKPairCredentialProvider

- (instancetype)initWithPlainTextAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey {
    if (self = [super init]) {
        self.accessKey = accessKey;
        self.secretKey = secretKey;
    }
    return self;
}

- (NSString *)sign:(NSString *)content error:(NSError **)error {
    if (!self.accessKey || !self.secretKey) {
        *error = [NSError errorWithDomain:OSSClientErrorDomain
                                     code:OSSClientErrorCodeSignFailed
                                 userInfo:@{OSSErrorMessageTOKEN: @"accessKey or secretKey can't be null"}];
        return nil;
    }
    NSString * sign = [OSSUtil calBase64Sha1WithData:content withSecret:self.secretKey];
    return [NSString stringWithFormat:@"OSS %@:%@", self.accessKey, sign];
}

@end

@implementation OSSCustomSignerCredentialProvider

- (instancetype)initWithImplementedSigner:(OSSCustomSignContentBlock)signContent {
    if (self = [super init]) {
        self.signContent = signContent;
    }
    return self;
}

- (NSString *)sign:(NSString *)content error:(NSError **)error {
    NSString * signature = @"";
    @synchronized(self) {
        signature = self.signContent(content, error);
    }
    if (*error) {
        *error = [NSError errorWithDomain:OSSClientErrorDomain
                                     code:OSSClientErrorCodeSignFailed
                                 userInfo:[[NSDictionary alloc] initWithDictionary:[*error userInfo]]];
        return nil;
    }
    return signature;
}

@end

@implementation OSSFederationCredentialProvider

static volatile uint64_t tag = 0;

- (instancetype)initWithFederationTokenGetter:(OSSGetFederationTokenBlock)federationTokenGetter {
    if (self = [super init]) {
        self.federationTokenGetter = federationTokenGetter;
    }
    return self;
}

- (NSString *)sign:(NSString *)content error:(NSError **)error {
    OSSFederationToken * token = [self getToken:error];
    if (!token) {
        *error = [NSError errorWithDomain:OSSClientErrorDomain
                                     code:OSSClientErrorCodeSignFailed
                                 userInfo:@{OSSErrorMessageTOKEN: @"Can't get a federation token"}];
        return nil;
    }

    NSString * sign = [OSSUtil calBase64Sha1WithData:content withSecret:token.tSecretKey];
    return [NSString stringWithFormat:@"OSS %@:%@", token.tAccessKey, sign];
}

- (OSSFederationToken *)getToken:(NSError **)error {
    OSSFederationToken * validToken = nil;
    static BOOL isNewlyGotten = NO;
    @synchronized(self) {
        if (!self.cachedToken) {
            self.cachedToken = self.federationTokenGetter();
            isNewlyGotten = YES;
            tag ++;
        }

        NSDate * expirationDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)(self.cachedToken.expirationTimeInMilliSecond / 1000)];
        NSTimeInterval interval = [expirationDate timeIntervalSinceDate:[NSDate oss_clockSkewFixedDate]];
        // OSSLogVerbose(@"get federation token, after %lf second it would be expired", interval);
        /* if this token will be expired after less than 15s, we abort it in case of when request arrived oss server,
           it's expired already. */
        if (interval < 15) {
            OSSLogDebug(@"get federation token, but after %lf second it would be expired", interval);
            if (isNewlyGotten) {
                /* if the newly gotten token is expired already, we can't abort it which will lead to a dead loop */
                /* we use it for 30s */
                self.cachedToken.expirationTimeInMilliSecond += [[NSDate oss_clockSkewFixedDate] timeIntervalSince1970] * 1000 + (15 + 30) * 1000;
                isNewlyGotten = NO;
            } else {
                self.cachedToken = self.federationTokenGetter();
                isNewlyGotten = YES;
                tag ++;
            }
        }

        validToken = self.cachedToken;
    }
    if (!validToken) {
        *error = [NSError errorWithDomain:OSSClientErrorDomain
                                     code:OSSClientErrorCodeSignFailed
                                 userInfo:@{OSSErrorMessageTOKEN: @"Can't get a federation token"}];
        return nil;
    }
    return validToken;
}

- (uint64_t)currentTagNumber {
    uint64_t currenTagNum = 0;
    @synchronized(self) {
        currenTagNum = tag;
    }
    return currenTagNum;
}

@end

@implementation OSSClientConfiguration
@end

@implementation OSSSignerInterceptor

- (instancetype)initWithCredentialProvider:(id<OSSCredentialProvider>)credentialProvider {
    if (self = [super init]) {
        self.credentialProvider = credentialProvider;
    }
    return self;
}

- (BFTask *)interceptRequestMessage:(OSSAllRequestNeededMessage *)requestMessage {
    OSSLogVerbose(@"signing intercepting - ");
    NSError * error = nil;

    /* define a constant array to contain all specified subresource */
    static NSArray * OSSSubResourceARRAY = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OSSSubResourceARRAY = @[@"acl", @"uploadId", @"partNumber", @"uploads", @"logging", @"website", @"location",
                                @"lifecycle", @"referer", @"cors", @"delete", @"append", @"position", @"security-token"];
    });
    /****************************************************************/

    /* initial each part of content to sign */
    NSString * method = requestMessage.httpMethod;
    NSString * contentType = @"";
    NSString * contentMd5 = @"";
    NSString * date = requestMessage.date;
    NSString * xossHeader = @"";
    NSString * resource = @"";

    OSSFederationToken * federationToken = nil;
    uint64_t startTagNumber = 0;

    if (requestMessage.contentType) {
        contentType = requestMessage.contentType;
    }
    if (requestMessage.contentMd5) {
        contentMd5 = requestMessage.contentMd5;
    }

    /* if credential provider is a federation token provider, it need to specially handle */
    if ([self.credentialProvider respondsToSelector:@selector(getToken:)]) {
        startTagNumber = [((OSSFederationCredentialProvider *)self.credentialProvider) currentTagNumber];
        federationToken = [((OSSFederationCredentialProvider *)self.credentialProvider) getToken:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }
        [requestMessage.headerParams setObject:federationToken.tToken forKey:@"x-oss-security-token"];
    }

    /* construct CanonicalizedOSSHeaders */
    if (requestMessage.headerParams) {
        NSMutableArray * params = [[NSMutableArray alloc] init];
        NSArray * sortedKey = [[requestMessage.headerParams allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        for (NSString * key in sortedKey) {
            if ([key hasPrefix:@"x-oss-"]) {
                [params addObject:[NSString stringWithFormat:@"%@:%@", key, [requestMessage.headerParams objectForKey:key]]];
            }
        }
        if ([params count]) {
            xossHeader = [NSString stringWithFormat:@"%@\n", [params componentsJoinedByString:@"\n"]];
        }
    }

    /* construct CanonicalizedResource */
    resource = [NSString stringWithFormat:@"/%@/", requestMessage.bucketName];
    if (requestMessage.objectKey) {
        resource = [resource oss_stringByAppendingPathComponentForURL:requestMessage.objectKey];
    }
    if (requestMessage.querys) {
        NSMutableArray * querys = [[NSMutableArray alloc] init];
        NSArray * sortedKey = [[requestMessage.querys allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        for (NSString * key in sortedKey) {
            NSString * value = [requestMessage.querys objectForKey:key];

            if (![OSSSubResourceARRAY containsObject:key]) { // notice it's based on content compare
                continue;
            }

            if ([value isEqualToString:@""]) {
                [querys addObject:[NSString stringWithFormat:@"%@", key]];
            } else {
                [querys addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
            }
        }
        if ([querys count]) {
            resource = [resource stringByAppendingString:[NSString stringWithFormat:@"?%@",[querys componentsJoinedByString:@"&"]]];
        }
    }

    /* now, join every part of content and sign */
    NSString * stringToSign = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@%@", method, contentMd5, contentType, date, xossHeader, resource];
    OSSLogDebug(@"string to sign: %@", stringToSign);
    if ([self.credentialProvider respondsToSelector:@selector(getToken:)]) {
        NSString * signature = [self.credentialProvider sign:stringToSign error:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }
        uint64_t endTagNumber = [((OSSFederationCredentialProvider *)self.credentialProvider) currentTagNumber];
        if (endTagNumber == startTagNumber) {
            [requestMessage.headerParams setObject:signature forKey:@"Authorization"];
        } else {
            /* if the former is inconsistent with latter, do it again */
            OSSLogDebug(@"get sts token, former tag: %llu, latter tag: %llu", startTagNumber, endTagNumber);
            [self interceptRequestMessage:requestMessage];
        }
    } else { // now we only have two type of credential provider
        NSString * signature = [self.credentialProvider sign:stringToSign error:&error];
        if (error) {
            return [BFTask taskWithError:error];
        }
        [requestMessage.headerParams setObject:signature forKey:@"Authorization"];
    }
    return [BFTask taskWithResult:nil];
}

@end

@implementation OSSUASettingInterceptor

- (NSString *)getUserAgent {
    static NSString * _userAgent = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSString *systemName = [[[UIDevice currentDevice] systemName] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
        _userAgent = [NSString stringWithFormat:@"%@_%@_%@_%@_%@", OSSUAPrefix, OSSSDKVersion, systemName, systemVersion, localeIdentifier];
    });
    return _userAgent;
}

- (BFTask *)interceptRequestMessage:(OSSAllRequestNeededMessage *)request {
    NSString * userAgent = [self getUserAgent];
    [request.headerParams setObject:userAgent forKey:@"User-Agent"];
    return [BFTask taskWithResult:nil];
}

@end

@implementation OSSTimeSkewedFixingInterceptor

- (BFTask *)interceptRequestMessage:(OSSAllRequestNeededMessage *)request {
    request.date = [[NSDate oss_clockSkewFixedDate] oss_asStringValue];
    return [BFTask taskWithResult:nil];
}

@end

@implementation OSSRange

- (instancetype)initWithStart:(int64_t)start withEnd:(int64_t)end {
    if (self = [super init]) {
        self.startPosition = start;
        self.endPosition = end;
    }
    return self;
}

- (NSString *)toHeaderString {

    NSString * rangeString = nil;

    if (self.startPosition < 0 && self.endPosition < 0) {
        rangeString = [NSString stringWithFormat:@"bytes=%lld-%lld", self.startPosition, self.endPosition];
    } else if (self.startPosition < 0) {
        rangeString = [NSString stringWithFormat:@"bytes=-%lld", self.endPosition];
    } else if (self.endPosition < 0) {
        rangeString = [NSString stringWithFormat:@"bytes=%lld-", self.startPosition];
    } else {
        rangeString = [NSString stringWithFormat:@"bytes=%lld-%lld", self.startPosition, self.endPosition];
    }

    return rangeString;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Range: %@", [self toHeaderString]];
}

@end

#pragma mark request and result objects

@interface OSSRequest ()
@property (nonatomic, strong) OSSNetworkingRequestDelegate * requestDelegate;
@end

@implementation OSSRequest

- (instancetype)init {
    if (self = [super init]) {
        self.requestDelegate = [OSSNetworkingRequestDelegate new];
        self.isAuthenticationRequired = YES;
    }
    return self;
}

- (void)cancel {
    if (self.requestDelegate) {
        [self.requestDelegate cancel];
    }
}

@end

@implementation OSSResult
@end

@implementation OSSCreateBucketRequest
@end

@implementation OSSCreateBucketResult
@end

@implementation OSSDeleteBucketRequest
@end

@implementation OSSDeleteBucketResult
@end

@implementation OSSGetBucketRequest

- (NSDictionary *)getQueryDict {
    NSMutableDictionary * querys = [NSMutableDictionary new];
    if (self.delimiter) {
        [querys setObject:self.delimiter forKey:@"delimiter"];
    }
    if (self.prefix) {
        [querys setObject:self.prefix forKey:@"prefix"];
    }
    if (self.marker) {
        [querys setObject:self.marker forKey:@"marker"];
    }
    if (self.maxKeys) {
        [querys setObject:[@(self.maxKeys) stringValue] forKey:@"max-keys"];
    }
    return querys;
}

@end

@implementation OSSGetBucketResult
@end

@implementation OSSHeadObjectRequest
@end

@implementation OSSHeadObjectResult
@end

@implementation OSSGetObjectRequest
@end

@implementation OSSGetObjectResult
@end

@implementation OSSPutObjectRequest

- (instancetype)init {
    if (self = [super init]) {
        self.objectMeta = [NSDictionary new];
    }
    return self;
}

@end

@implementation OSSPutObjectResult
@end

@implementation OSSAppendObjectRequest

- (instancetype)init {
    if (self = [super init]) {
        self.objectMeta = [NSDictionary new];
    }
    return self;
}

@end

@implementation OSSAppendObjectResult
@end

@implementation OSSDeleteObjectRequest
@end

@implementation OSSDeleteObjectResult
@end

@implementation OSSCopyObjectRequest

- (instancetype)init {
    if (self = [super init]) {
        self.objectMeta = [NSDictionary new];
    }
    return self;
}

@end

@implementation OSSCopyObjectResult
@end

@implementation OSSInitMultipartUploadRequest

- (instancetype)init {
    if (self = [super init]) {
        self.objectMeta = [NSDictionary new];
    }
    return self;
}

@end

@implementation OSSInitMultipartUploadResult
@end

@implementation OSSUploadPartRequest
@end

@implementation OSSUploadPartResult
@end

@implementation OSSPartInfo

+ (instancetype)partInfoWithPartNum:(int32_t)partNum
                               eTag:(NSString *)eTag
                               size:(int64_t)size {
    OSSPartInfo * instance = [OSSPartInfo new];
    instance.partNum = partNum;
    instance.eTag = eTag;
    instance.size = size;
    return instance;
}

@end

@implementation OSSCompleteMultipartUploadRequest
@end

@implementation OSSCompleteMultipartUploadResult
@end

@implementation OSSAbortMultipartUploadRequest
@end

@implementation OSSAbortMultipartUploadResult
@end

@implementation OSSListPartsRequest
@end

@implementation OSSListPartsResult
@end

#pragma mark response parser


@implementation OSSHttpResponseParser {

    OSSOperationType _operationTypeForThisParser;

    NSFileHandle * _fileHandle;
    NSMutableData * _collectingData;
    NSHTTPURLResponse * _response;
}

- (void)reset {
    _collectingData = nil;
    _fileHandle = nil;
    _response = nil;
}

- (instancetype)initForOperationType:(OSSOperationType)operationType {
    if (self = [super init]) {
        _operationTypeForThisParser = operationType;
    }
    return self;
}

- (void)consumeHttpResponse:(NSHTTPURLResponse *)response {
    _response = response;
}

- (BFTask *)consumeHttpResponseBody:(NSData *)data {

    if (self.onRecieveBlock) {
        self.onRecieveBlock(data);
        return [BFTask taskWithResult:nil];
    }

    NSError * error;
    if (self.downloadingFileURL) {
        if (!_fileHandle) {
            NSFileManager * fm = [NSFileManager defaultManager];
            if (![fm fileExistsAtPath:[self.downloadingFileURL path]]) {
                [fm createFileAtPath:[self.downloadingFileURL path] contents:nil attributes:nil];
                if (![fm fileExistsAtPath:[self.downloadingFileURL path]]) {
                    return [BFTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
                                                                     code:OSSClientErrorCodeFileCantWrite
                                                                 userInfo:@{OSSErrorMessageTOKEN: [NSString stringWithFormat:@"Can't write to %@", [self.downloadingFileURL path]]}]];
                }
            }
            _fileHandle = [NSFileHandle fileHandleForWritingToURL:self.downloadingFileURL error:&error];
            if (error) {
                return [BFTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
                                                                 code:OSSClientErrorCodeFileCantWrite
                                                             userInfo:[error userInfo]]];
            }
            [_fileHandle writeData:data];
        } else {
            OSSLogVerbose(@"write data: %lld", (int64_t)[data length]);
            @try {
                [_fileHandle writeData:data];
            }
            @catch (NSException *exception) {
                return [BFTask taskWithError:[NSError errorWithDomain:OSSServerErrorDomain
                                                                 code:OSSClientErrorCodeFileCantWrite
                                                             userInfo:@{OSSErrorMessageTOKEN: [exception description]}]];
            }
        }
    } else {
        if (!_collectingData) {
            _collectingData = [[NSMutableData alloc] initWithData:data];
        } else {
            [_collectingData appendData:data];
        }
    }
    return [BFTask taskWithResult:nil];
}

- (void)parseResponseHeader:(NSHTTPURLResponse *)response toResultObject:(OSSResult *)result {
    result.httpResponseCode = [_response statusCode];
    result.httpResponseHeaderFields = [NSDictionary dictionaryWithDictionary:[_response allHeaderFields]];
    [[_response allHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString * keyString = (NSString *)key;
        if ([keyString isEqualToString:@"x-oss-request-id"]) {
            result.requestId = obj;
        }
    }];
}

- (NSDictionary *)parseResponseHeaderToGetMeta:(NSHTTPURLResponse *)response {
    NSMutableDictionary * meta = [NSMutableDictionary new];

    /* define a constant array to contain all meta header name */
    static NSArray * OSSObjectMetaFieldNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OSSObjectMetaFieldNames = @[@"Content-Type", @"Content-Length", @"Etag", @"Last-Modified", @"x-oss-request-id", @"x-oss-object-type",
                                @"If-Modified-Since", @"If-Unmodified-Since", @"If-Match", @"If-None-Match"];
    });
    /****************************************************************/

    [[_response allHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString * keyString = (NSString *)key;
        if ([OSSObjectMetaFieldNames containsObject:keyString] || [keyString hasPrefix:@"x-oss-meta"]) {
            [meta setObject:obj forKey:key];
        }
    }];
    return meta;
}

- (id)constructResultObject {
    if (self.onRecieveBlock) {
        return nil;
    }

    switch (_operationTypeForThisParser) {

        case OSSOperationTypeCreateBucket: {
            OSSCreateBucketResult * createBucketResult = [OSSCreateBucketResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:createBucketResult];
                [_response.allHeaderFields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([((NSString *)key) isEqualToString:@"Location"]) {
                        createBucketResult.location = obj;
                        *stop = YES;
                    }
                }];
            }
            return createBucketResult;
        }

        case OSSOperationTypeDeleteBucket: {
            OSSDeleteBucketResult * deleteBucketResult = [OSSDeleteBucketResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:deleteBucketResult];
            }
            return deleteBucketResult;
        }

        case OSSOperationTypeGetBucket: {
            OSSGetBucketResult * getBucketResult = [OSSGetBucketResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:getBucketResult];
            }
            if (_collectingData) {
                OSSLogVerbose(@"Get bucket dict: %@", [NSDictionary dictionaryWithXMLData:_collectingData]);
                NSDictionary * parsedDict = [NSDictionary dictionaryWithXMLData:_collectingData];

                if (parsedDict) {
                    getBucketResult.bucketName = [parsedDict objectForKey:OSSNameXMLTOKEN];
                    getBucketResult.prefix = [parsedDict objectForKey:OSSPrefixXMLTOKEN];
                    getBucketResult.marker = [parsedDict objectForKey:OSSMarkerXMLTOKEN];
                    getBucketResult.maxKeys = (int32_t)[[parsedDict objectForKey:OSSMaxKeyXMLTOKEN] integerValue];
                    getBucketResult.delimiter = [parsedDict objectForKey:OSSDelimiterXMLTOKEN];
                    getBucketResult.isTruncated = [[parsedDict objectForKey:OSSIsTruncatedXMLTOKEN] boolValue];
                    getBucketResult.contents = [parsedDict objectForKey:OSSContentXMLTOKEN];
                    NSMutableArray * commentPrefixes = [NSMutableArray new];
                    for (NSDictionary * prefix in [parsedDict objectForKey:OSSCommonPrefixesXMLTOKEN]) {
                        [commentPrefixes addObject:[prefix objectForKey:@"Prefix"]];
                    }
                    getBucketResult.commentPrefixes = commentPrefixes;
                }
            }
            return getBucketResult;
        }

        case OSSOperationTypeHeadObject: {
            OSSHeadObjectResult * headObjectResult = [OSSHeadObjectResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:headObjectResult];
                headObjectResult.objectMeta = [self parseResponseHeaderToGetMeta:_response];
            }
            return headObjectResult;
        }

        case OSSOperationTypeGetObject: {
            OSSGetObjectResult * getObejctResult = [OSSGetObjectResult new];
            OSSLogDebug(@"GetObjectResponse: %@", _response);
            if (_response) {
                [self parseResponseHeader:_response toResultObject:getObejctResult];
                getObejctResult.objectMeta = [self parseResponseHeaderToGetMeta:_response];
            }
            if (_fileHandle) {
                [_fileHandle closeFile];
            }
            if (_collectingData) {
                getObejctResult.downloadedData = _collectingData;
            }
            return getObejctResult;
        }

        case OSSOperationTypePutObject: {
            OSSPutObjectResult * putObjectResult = [OSSPutObjectResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:putObjectResult];
                [_response.allHeaderFields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([((NSString *)key) isEqualToString:@"Etag"]) {
                        putObjectResult.eTag = obj;
                        *stop = YES;
                    }
                }];
            }
            if (_collectingData) {
                putObjectResult.serverReturnJsonString = [[NSString alloc] initWithData:_collectingData encoding:NSUTF8StringEncoding];
            }
            return putObjectResult;
        }

        case OSSOperationTypeAppendObject: {
            OSSAppendObjectResult * appendObjectResult = [OSSAppendObjectResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:appendObjectResult];
                [_response.allHeaderFields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([((NSString *)key) isEqualToString:@"Etag"]) {
                        appendObjectResult.eTag = obj;
                    }
                    if ([((NSString *)key) isEqualToString:@"x-oss-next-append-position"]) {
                        appendObjectResult.xOssNextAppendPosition = [((NSString *)obj) longLongValue];
                    }
                }];
            }
            return appendObjectResult;
        }

        case OSSOperationTypeDeleteObject: {
            OSSDeleteObjectResult * deleteObjectResult = [OSSDeleteObjectResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:deleteObjectResult];
            }
            return deleteObjectResult;
        }

        case OSSOperationTypeCopyObject: {
            OSSCopyObjectResult * copyObjectResult = [OSSCopyObjectResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:copyObjectResult];
            }
            if (_collectingData) {
                OSSLogVerbose(@"copy object dict: %@", [NSDictionary dictionaryWithXMLData:_collectingData]);
                NSDictionary * parsedDict = [NSDictionary dictionaryWithXMLData:_collectingData];
                if (parsedDict) {
                    copyObjectResult.lastModifed = [parsedDict objectForKey:OSSLastModifiedXMLTOKEN];
                    copyObjectResult.eTag = [parsedDict objectForKey:OSSETagXMLTOKEN];
                }
            }
            return copyObjectResult;
        }

        case OSSOperationTypeInitMultipartUpload: {
            OSSInitMultipartUploadResult * initMultipartUploadResult = [OSSInitMultipartUploadResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:initMultipartUploadResult];
            }
            if (_collectingData) {
                NSDictionary * parsedDict = [NSDictionary dictionaryWithXMLData:_collectingData];
                OSSLogVerbose(@"init multipart upload result: %@", parsedDict);
                if (parsedDict) {
                    initMultipartUploadResult.uploadId = [parsedDict objectForKey:OSSUploadIdXMLTOKEN];
                }
            }
            return initMultipartUploadResult;
        }

        case OSSOperationTypeUploadPart: {
            OSSUploadPartResult * uploadPartResult = [OSSUploadPartResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:uploadPartResult];
                [_response.allHeaderFields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([((NSString *)key) isEqualToString:@"Etag"]) {
                        uploadPartResult.eTag = obj;
                        *stop = YES;
                    }
                }];
            }
            return uploadPartResult;
        }

        case OSSOperationTypeCompleteMultipartUpload: {
            OSSCompleteMultipartUploadResult * completeMultipartUploadResult = [OSSCompleteMultipartUploadResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:completeMultipartUploadResult];
            }
            if (_collectingData) {
                OSSLogVerbose(@"complete multipart upload result: %@", [NSDictionary dictionaryWithXMLData:_collectingData]);
                NSDictionary * parsedDict = [NSDictionary dictionaryWithXMLData:_collectingData];
                if (parsedDict) {
                    completeMultipartUploadResult.location = [parsedDict objectForKey:OSSLocationXMLTOKEN];
                    completeMultipartUploadResult.eTag = [parsedDict objectForKey:OSSETagXMLTOKEN];
                }
            }
            return completeMultipartUploadResult;
        }

        case OSSOperationTypeListMultipart: {
            OSSListPartsResult * listPartsReuslt = [OSSListPartsResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:listPartsReuslt];
            }
            if (_collectingData) {
                OSSLogVerbose(@"list multipart upload result: %@", [NSDictionary dictionaryWithXMLData:_collectingData]);
                NSDictionary * parsedDict = [NSDictionary dictionaryWithXMLData:_collectingData];
                if (parsedDict) {
                    listPartsReuslt.nextPartNumberMarker = [[parsedDict objectForKey:OSSNextPartNumberMarkerXMLTOKEN] intValue];
                    listPartsReuslt.maxParts = [[parsedDict objectForKey:OSSMaxKeyXMLTOKEN] intValue];
                    listPartsReuslt.isTruncate = [[parsedDict objectForKey:OSSMaxKeyXMLTOKEN] boolValue];
                    listPartsReuslt.parts = [parsedDict objectForKey:OSSPartXMLTOKEN];
                }
            }
            return listPartsReuslt;
        }

        case OSSOperationTypeAbortMultipartUpload: {
            OSSAbortMultipartUploadResult * abortMultipartUploadResult = [OSSAbortMultipartUploadResult new];
            if (_response) {
                [self parseResponseHeader:_response toResultObject:abortMultipartUploadResult];
            }
            return abortMultipartUploadResult;
        }

        default: {
            OSSLogError(@"unknown operation type");
            break;
        }
    }
    return nil;
}

@end
