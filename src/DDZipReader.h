//
//  DDZipReader.h
//  updated 2011, Dominik Pich
//

#import <Foundation/Foundation.h>
#include "unzip.h"

@class DDZipReader;

@protocol DDZipReaderDelegate <NSObject>
@optional
-(BOOL) zipArchive:(DDZipReader*)zip shouldExtractFile:(NSString*)file;
-(void) zipArchive:(DDZipReader*)zip errorMessage:(NSString*) msg;
-(BOOL) zipArchive:(DDZipReader*)zip shouldOverwriteFile:(NSString*)file withZippedFile:(unz_file_info)fileInfo;

@end

@interface DDZipReader : NSObject {
@private
	unzFile		_unzFile;
}

@property (nonatomic, unsafe_unretained) id<DDZipReaderDelegate> delegate;

-(BOOL) openZipFile:(NSString*) zipFile;
-(NSInteger) UnzipFileTo:(NSString*) path overwriteAlways:(BOOL) overwrite flattenStructure: (BOOL)flatten;
-(BOOL) closeZipFile;

+ (NSDate*)Date1980;
@end
