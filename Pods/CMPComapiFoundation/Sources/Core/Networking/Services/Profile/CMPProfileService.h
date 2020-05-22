//
// The MIT License (MIT)
// Copyright (c) 2017 Comapi (trading name of Dynmark International Limited)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "CMPBaseService.h"
#import "CMPResult.h"

@class CMPQueryElements;
@class CMPProfile;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ProfileServiceable)
@protocol CMPProfileServiceable <NSObject>

/**
 @brief Fetches a profile for specified Id.
 @param profileID Id of the searched profile.
 @param completion Block with a result value, the @b object returned is of type @a CMPProfile* or nil if an error occurred.
 */
- (void)getProfileWithProfileID:(NSString *)profileID completion:(void(^)(CMPResult<CMPProfile *> *))completion NS_SWIFT_NAME(getProfile(profileID:completion:));

/**
 @brief Updates a profile for specified Id with listed attributes.
 @param profileID Id of the profile being updated.
 @param attributes Attributes being inserted/updated with respective values.
 @param eTag ETag value that checks if the data we are expecting matches the one on the server (helps prevent conflicts when multiple updates happen simultanously).
 @param completion completion Block with a result value, the @b object returned is of type @a CMPProfile* or nil if an error occurred.
 */
- (void)updateProfileWithProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void(^)(CMPResult<CMPProfile *> *))completion
    NS_SWIFT_NAME(updateProfile(profileID:attributes:eTag:completion:));

/**
 @brief Patch a profile for specified Id with listed attributes.
 @param profileID Id of the profile being patched.
 @param attributes Attributes being inserted/patched with respective values.
 @param eTag ETag value that checks if the data we are expecting matches the one on the server (helps prevent conflicts when multiple patches happen simultanously).
 @param completion completion Block with a result value, the @b object returned is of type @a CMPProfile* or nil if an error occurred.
 */
- (void)patchProfileWithProfileID:(NSString *)profileID attributes:(NSDictionary<NSString *, NSString *> *)attributes eTag:(NSString * _Nullable)eTag completion:(void(^)(CMPResult<CMPProfile *> *))completion NS_SWIFT_NAME(patchProfile(profileID:attributes:eTag:completion:));

/**
 @brief Queries profiles with a query builder.
 @param queryElements Filter criteria for searched profiles.
 @param completion Block with a result value, the @b object returned is of type @a NSArray<CMPProfile*>* or nil if an error occurred.
 */
- (void)queryProfilesWithQueryElements:(NSArray<CMPQueryElements *> *)queryElements completion:(void (^)(CMPResult<NSArray<CMPProfile *> *> *))completion
    NS_SWIFT_NAME(queryProfiles(queryElements:completion:));

@end

/**
 @brief Profile related Comapi services.
 */
NS_SWIFT_NAME(ProfileService)
@interface CMPProfileService : CMPBaseService <CMPProfileServiceable>

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
