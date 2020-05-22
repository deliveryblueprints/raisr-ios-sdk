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

#import <CMPComapiFoundation/CMPHTTPHeader.h>
#import <CMPComapiFoundation/CMPStateDelegate.h>
#import <CMPComapiFoundation/CMPComapi.h>
#import <CMPComapiFoundation/CMPComapiClient.h>
#import <CMPComapiFoundation/CMPAPIConfiguration.h>
#import <CMPComapiFoundation/CMPComapiConfig.h>
#import <CMPComapiFoundation/CMPComapiConfigBuilder.h>
#import <CMPComapiFoundation/CMPLogConfig.h>
#import <CMPComapiFoundation/CMPConstants.h>
#import <CMPComapiFoundation/CMPErrors.h>
#import <CMPComapiFoundation/CMPLog.h>
#import <CMPComapiFoundation/CMPLogger.h>
#import <CMPComapiFoundation/CMPLogLevel.h>
#import <CMPComapiFoundation/CMPFileDestination.h>
#import <CMPComapiFoundation/CMPLoggingDestination.h>
#import <CMPComapiFoundation/CMPXcodeConsoleDestination.h>
#import <CMPComapiFoundation/CMPAuthenticationDelegate.h>
#import <CMPComapiFoundation/CMPJSONConstructable.h>
#import <CMPComapiFoundation/CMPJSONDecoding.h>
#import <CMPComapiFoundation/CMPJSONEncoding.h>
#import <CMPComapiFoundation/CMPJSONRepresentable.h>
#import <CMPComapiFoundation/CMPRequestManager.h>
#import <CMPComapiFoundation/CMPRequestPerformer.h>
#import <CMPComapiFoundation/CMPRequestPerforming.h>
#import <CMPComapiFoundation/CMPBaseService.h>
#import <CMPComapiFoundation/CMPServices.h>
#import <CMPComapiFoundation/CMPMessagingService.h>
#import <CMPComapiFoundation/CMPProfileService.h>
#import <CMPComapiFoundation/CMPSessionService.h>
#import <CMPComapiFoundation/CMPAuthChallengeHandler.h>
#import <CMPComapiFoundation/CMPSessionAuthProvider.h>
#import <CMPComapiFoundation/CMPSessionDelegate.h>
#import <CMPComapiFoundation/CMPSessionManager.h>
#import <CMPComapiFoundation/CMPEventDelegate.h>
#import <CMPComapiFoundation/CMPEventParser.h>
#import <CMPComapiFoundation/CMPEvent.h>
#import <CMPComapiFoundation/CMPConversationEvents.h>
#import <CMPComapiFoundation/CMPConversationMessageEvents.h>
#import <CMPComapiFoundation/CMPProfileEvents.h>
#import <CMPComapiFoundation/CMPSocketEvents.h>
#import <CMPComapiFoundation/CMPAddConversationTemplate.h>
#import <CMPComapiFoundation/CMPAddParticipantsTemplate.h>
#import <CMPComapiFoundation/CMPContentUploadTemplate.h>
#import <CMPComapiFoundation/CMPDeleteConversationTemplate.h>
#import <CMPComapiFoundation/CMPEventQueryTemplate.h>
#import <CMPComapiFoundation/CMPGetConversationsTemplate.h>
#import <CMPComapiFoundation/CMPGetConversationTemplate.h>
#import <CMPComapiFoundation/CMPGetMessagesTemplate.h>
#import <CMPComapiFoundation/CMPGetParticipantsTemplate.h>
#import <CMPComapiFoundation/CMPParticipantTypingOffTemplate.h>
#import <CMPComapiFoundation/CMPParticipantTypingTemplate.h>
#import <CMPComapiFoundation/CMPPendingOperation.h>
#import <CMPComapiFoundation/CMPRemoveParticipantsTemplate.h>
#import <CMPComapiFoundation/CMPSendMessagesTemplate.h>
#import <CMPComapiFoundation/CMPSendStatusUpdateTemplate.h>
#import <CMPComapiFoundation/CMPUpdateConversationTemplate.h>
#import <CMPComapiFoundation/CMPContentData.h>
#import <CMPComapiFoundation/CMPContentUploadResult.h>
#import <CMPComapiFoundation/CMPConversation.h>
#import <CMPComapiFoundation/CMPConversationParticipant.h>
#import <CMPComapiFoundation/CMPConversationScope.h>
#import <CMPComapiFoundation/CMPConversationUpdate.h>
#import <CMPComapiFoundation/CMPGetMessagesResult.h>
#import <CMPComapiFoundation/CMPMessage.h>
#import <CMPComapiFoundation/CMPMessageAlert.h>
#import <CMPComapiFoundation/CMPMessageAlertPlatforms.h>
#import <CMPComapiFoundation/CMPMessageContext.h>
#import <CMPComapiFoundation/CMPMessageDeliveryStatus.h>
#import <CMPComapiFoundation/CMPMessagePart.h>
#import <CMPComapiFoundation/CMPMessageParticipant.h>
#import <CMPComapiFoundation/CMPMessageStatus.h>
#import <CMPComapiFoundation/CMPMessageStatusUpdate.h>
#import <CMPComapiFoundation/CMPNewConversation.h>
#import <CMPComapiFoundation/CMPOrphanedEvent.h>
#import <CMPComapiFoundation/CMPRole.h>
#import <CMPComapiFoundation/CMPRoleAttributes.h>
#import <CMPComapiFoundation/CMPRoles.h>
#import <CMPComapiFoundation/CMPSendableMessage.h>
#import <CMPComapiFoundation/CMPSendMessagesResult.h>
#import <CMPComapiFoundation/CMPGetProfileTemplate.h>
#import <CMPComapiFoundation/CMPPatchProfileTemplate.h>
#import <CMPComapiFoundation/CMPQueryProfilesTemplate.h>
#import <CMPComapiFoundation/CMPUpdateProfileTemplate.h>
#import <CMPComapiFoundation/CMPProfile.h>
#import <CMPComapiFoundation/CMPQueryBuilder.h>
#import <CMPComapiFoundation/CMPSetAPNSDetailsTemplate.h>
#import <CMPComapiFoundation/CMPAPNSDetails.h>
#import <CMPComapiFoundation/CMPAPNSDetailsBody.h>
#import <CMPComapiFoundation/CMPHTTPRequestTemplate.h>
#import <CMPComapiFoundation/CMPRequestTemplate.h>
#import <CMPComapiFoundation/CMPResult.h>
#import <CMPComapiFoundation/CMPAuthorizeSessionTemplate.h>
#import <CMPComapiFoundation/CMPDeleteSessionTemplate.h>
#import <CMPComapiFoundation/CMPStartNewSessionTemplate.h>
#import <CMPComapiFoundation/CMPAuthenticationChallenge.h>
#import <CMPComapiFoundation/CMPAuthorizeSessionBody.h>
#import <CMPComapiFoundation/CMPSession.h>
#import <CMPComapiFoundation/CMPSessionAuth.h>
#import <CMPComapiFoundation/CMPSocketTemplate.h>
#import <CMPComapiFoundation/CMPURLResult.h>
#import <CMPComapiFoundation/CMPBroadcastDelegate.h>
#import <CMPComapiFoundation/CMPSocketDelegate.h>
#import <CMPComapiFoundation/CMPSocketManager.h>
#import <CMPComapiFoundation/CMPTokenState.h>
#import <CMPComapiFoundation/CMPKeychain.h>
#import <CMPComapiFoundation/NSData+CMPUtility.h>
#import <CMPComapiFoundation/NSDate+CMPUtility.h>
#import <CMPComapiFoundation/NSDateFormatter+CMPUtility.h>
#import <CMPComapiFoundation/NSString+CMPUtility.h>
#import <CMPComapiFoundation/NSURLRequest+CMPUtility.h>
#import <CMPComapiFoundation/NSURLResponse+CMPUtility.h>






