//
//  FKFlickrPhotosGeoRemoveLocation.h
//  FlickrKit
//
//  Generated by FKAPIBuilder on 19 Sep, 2014 at 10:49.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrAPIMethod.h"

typedef enum {
	FKFlickrPhotosGeoRemoveLocationError_PhotoNotFound = 1,		 /* The photo id was either invalid or was for a photo not viewable by the calling user. */
	FKFlickrPhotosGeoRemoveLocationError_PhotoHasNoLocationInformation = 2,		 /* The specified photo has not been geotagged - there is nothing to remove. */
	FKFlickrPhotosGeoRemoveLocationError_SSLIsRequired = 95,		 /* SSL is required to access the Flickr API. */
	FKFlickrPhotosGeoRemoveLocationError_InvalidSignature = 96,		 /* The passed signature was invalid. */
	FKFlickrPhotosGeoRemoveLocationError_MissingSignature = 97,		 /* The call required signing but no signature was sent. */
	FKFlickrPhotosGeoRemoveLocationError_LoginFailedOrInvalidAuthToken = 98,		 /* The login details or auth token passed were invalid. */
	FKFlickrPhotosGeoRemoveLocationError_UserNotLoggedInOrInsufficientPermissions = 99,		 /* The method requires user authentication but the user was not logged in, or the authenticated method call did not have the required permissions. */
	FKFlickrPhotosGeoRemoveLocationError_InvalidAPIKey = 100,		 /* The API key passed was not valid or has expired. */
	FKFlickrPhotosGeoRemoveLocationError_ServiceCurrentlyUnavailable = 105,		 /* The requested service is temporarily unavailable. */
	FKFlickrPhotosGeoRemoveLocationError_WriteOperationFailed = 106,		 /* The requested operation failed due to a temporary issue. */
	FKFlickrPhotosGeoRemoveLocationError_FormatXXXNotFound = 111,		 /* The requested response format was not found. */
	FKFlickrPhotosGeoRemoveLocationError_MethodXXXNotFound = 112,		 /* The requested method was not found. */
	FKFlickrPhotosGeoRemoveLocationError_InvalidSOAPEnvelope = 114,		 /* The SOAP envelope send in the request could not be parsed. */
	FKFlickrPhotosGeoRemoveLocationError_InvalidXMLRPCMethodCall = 115,		 /* The XML-RPC request document could not be parsed. */
	FKFlickrPhotosGeoRemoveLocationError_BadURLFound = 116,		 /* One or more arguments contained a URL that has been used for abuse on Flickr. */

} FKFlickrPhotosGeoRemoveLocationError;

/*

Removes the geo data associated with a photo.




*/
@interface FKFlickrPhotosGeoRemoveLocation : NSObject <FKFlickrAPIMethod>

/* The id of the photo you want to remove location data from. */
@property (nonatomic, copy) NSString *photo_id; /* (Required) */


@end
