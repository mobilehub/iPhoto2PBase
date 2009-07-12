/*
 *  PBaseConstants.m
 *  iPhoto2PBase
 *
 *  Created by Scott Andrew on 6/24/06.
 *  Copyright 2006 New Wave Digital Media. All rights reserved.
 *
 */

#include <Cocoa/Cocoa.h>

NSString* pbaseBaseURL = @"http://www.pbase.com";
NSString* pbaseLogOut = @"/logout";
NSString* pbaseLogin = @"/login";
NSString* pbaseQuota = @"/quota.html";
NSString* pbaseLoginData = @"login_id=%@&password=%@&view=&r=&submit=login";
NSString* pbasePostHeader = @"application/x-www-form-urlencoded";
NSString* pbaseViewGalleries = @"/client?view=galleries";

NSString* pbaseMustBeLoggedInErr = @"must be logged in";

NSString* pbaseBoundry = @"wEAreBuGars";

NSString* pbaseUpload = @"http://upload.pbase.com/edit_gallery/";
NSString* pbaseUploadHeader = @"multipart/form-data; boundary=%@";
NSString* contentDisposition = @"Content-Disposition: form-data; name=\"fname\"; filename=\"%@\"\r\nContent-Type: image/jpeg\r\n\r\n";
NSString* contentType = @"Content-Type: image/jpeg\r\n\r\n";
NSString* createGalleryLineData = @"parent_gid=%@&gallery_name=%@&root_flag=%@&submit=New+Gallery";
NSString* createdGalleryCheck = @"Created new gallery %@.";
NSString* updatedGalleryCheck = @"Updated gallery.";

NSString* pbaseEditGalleryURL = @"%@/edit_gallery/%@/%@";

NSString* pbaseGalleryDetails = @"gallery_no=%@&title=%@&description=%@&country_id=%@&show_titles=%@&public_flag=%@&max_columns=%@&table_width=%@" \
@"&cell_spacing=%@&cell_padding=%@&old_max_images_per_page=%@&max_images_per_page=%@0&bgcolor=%@&textcolor=%@" \
@"&css_id=%@&upload_process_code=0&passkey_apply=0&new_password=&cascade_add_passkey=on&gallery_id=%@&submit=Update+Gallery" \
@"&.cgifields=public_flag&.cgifields=description_html_flag&.cgifields=show_titles";


NSString* pbaseGalleryAdvanced = @"enable_vote_flag=%@&no_tech_flag=%@&no_comment_flag=%@&copyright=%@&show_captions=%@&align_captions=%@&raw_image_flag=%@&locked_image=-2&locked_image_id=&submit=Update+Advanced+Settings";

NSString* pbaseUpdateImageString = @"submit=Update+Image&title=%@&caption=%@&artist=&location=&shot_date=%@&camera_body_id=%@&" \
								    "camera_body=%@&camera_lens_id=%@&camera_lens=%@&film_id=&film_type=&description=%@&"\
								    "keywords=%@&public_flag=Y";
