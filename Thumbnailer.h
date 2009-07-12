/*
 *     Generated by class-dump 3.0.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004 by Steve Nygard.
 */

#import <Cocoa/Cocoa.h>

@protocol ThreadManagerTask
- (void)performTask;
@end

@class ImageUserData, NSLock, NSString;

@interface Thumbnailer : NSObject <ThreadManagerTask>
{
    struct _NSRect mMaxBounds;
    unsigned long mMaxFileBytes;
    int mQuality;
    float mRotation;
    float mOriginalRotation;
    BOOL mAutoRotate;
    unsigned int mOutputFormat;
    NSString *mOutputExtension;
    ImageUserData *mUserData;
    void *mJobQueue;
    NSLock *mQueueLock;
    BOOL mThreadActive;
    BOOL mClearRequested;
    struct ComponentInstanceRecord *mImport;
    struct ComponentInstanceRecord *mExport;
    struct UserDataRecord **mUserDataHandle;
    char **mColorProfile;
    struct FSSpec mSrc;
    struct FSSpec mDest;
    struct _NSRect mBounds;
    struct _NSSize mLastImageSize;
    struct _NSSize mLastThumbSize;
    NSLock *mLock;
    short mMovieRef;
    struct MovieType **mMovie;
    struct OpaqueGrafPtr *mSrcGWorld;
    int mDecompressSeqID;
    long mImageSize;
    unsigned int mMovieFrameCount;
    unsigned int mMovieFrameNumber;
    int mMovieTime;
}

+ (id)scaleImage:(id)fp8 fromSize:(struct _NSSize)fp12 toSize:(struct _NSSize)fp20;
- (id)init;
- (void)dealloc;
- (void)setMax:(unsigned int)fp8 width:(unsigned int)fp12 height:(unsigned int)fp16;
- (struct _NSSize)maxBounds;
- (void)setQuality:(int)fp8;
- (int)quality;
- (void)setRotation:(float)fp8;
- (float)rotation;
- (void)setOriginalRotation:(float)fp8;
- (float)originalRotation;
- (void)setAutoRotate:(BOOL)fp8;
- (float)autoRotate;
- (void)setOutputFormat:(unsigned long)fp8;
- (unsigned long)outputFormat;
- (id)userData;
- (void)setUserData:(id)fp8;
- (void)setOutputExtension:(id)fp8;
- (id)outputExtension;
- (void)clearJobQueue;
- (void)addToJobQueue:(id)fp8 dest:(id)fp12 useTempFile:(BOOL)fp16;
- (void)processJobQueue;
- (int)_queueCount;
- (id)_canTerminate;
- (void)performTask;
- (void)thumbThread;
- (id)userDataForSrc:(id)fp8;
- (BOOL)createThumbnailFromJPEG:(void *)fp8 dest:(id)fp12;
- (BOOL)createThumbnailFromJPEG:(void *)fp8 handle:(char **)fp12;
- (BOOL)createThumbnail:(id)fp8 dest:(id)fp12;
- (char **)retrieveColorProfile:(id)fp8;
- (BOOL)retrieveMetadata:(id)fp8 userData:(id *)fp12;
- (BOOL)copyUserDataFromPath:(id)fp8 toPath:(id)fp12;
- (struct _NSSize)lastImageSize;
- (struct _NSSize)lastThumbSize;
- (void)releaseImporter;
- (void)releaseExporter;
- (void)releaseUserData;
- (void)releaseColorProfile;
- (struct OpaqueGrafPtr *)_makeGWorldForMovie;
- (long)_initDecompressSeq;
- (short)_decompress;
- (short)_endDecompress;
- (unsigned long)_countMovieFrames;
- (void)_nextFrame;
- (BOOL)_createImporterForJPEG:(void *)fp8;
- (void)_openMovie:(id)fp8;
- (BOOL)_createImporterForPath:(id)fp8;
- (void)_getUserData;
- (BOOL)ensureImporterForJPEG:(void *)fp8;
- (BOOL)ensureImporterForPath:(id)fp8;
- (void)_prepareImporter;
- (BOOL)ensureExporterCore;
- (BOOL)ensureExporterForPath:(id)fp8;
- (BOOL)ensureExporterForHandle:(char **)fp8;

@end

