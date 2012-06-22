//
//  main.c
//  demo
//
//  Created by Dominik Pich on 07.06.12.
//  Copyright (c) 2012 doo GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDZipReader.h"
#import "DDZipWriter.h"

int unzip(NSString *file);
int unzip(NSString *file) 
{
    DDZipReader *reader = [[DDZipReader alloc] init];
    if([reader openZipFile:file]) 
    {
        NSString *path = [[file stringByDeletingPathExtension] stringByAppendingFormat:@"-Unpack"];
        if([[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) 
        {
            NSUInteger c = [reader unzipFileTo:path flattenStructure:NO];
            [reader closeZipFile];
            printf("%lu files extracted", c);
            return c==0 ? 3 : 0;
        }
        else 
        {
            printf("Failed to create target directory: %s", path.UTF8String);
            return 2;
        }
    }
    else
    {
        printf("Failed to open zip");
        return 2;
    }
}

int writeZip(NSArray *files, NSString *zip);
int writeZip(NSArray *files, NSString *zip) 
{
    DDZipWriter *writer = [[DDZipWriter alloc] init];
    if([writer newZipFile:zip])                        
    {
        NSUInteger c = 0;
        for (NSString *file in files) {
            if([writer addFileToZip:file newname:nil])
            {
                printf("added %s", file.UTF8String);
                c++;
            }
            else 
            {
                printf("failed to add %s", file.UTF8String);
                return 4;
            }
        }
        
        [writer closeZipFile];
        return c==0 ? 3 : 0;
    }
    else 
    {
        printf("failed to create empty zip");
        return 2;
    }
}

int main(int argc, const char * argv[])
{
//    NSDate *d1980 = [DDZippedFileInfo dateWithTimeIntervalSince1980:0];
//    //dos date and back
//    NSTimeInterval d = [[NSDate date] timeIntervalSinceDate:d1980];
//    NSLog(@"%@ = %@", [NSDate date], [DDZippedFileInfo dateWithTimeIntervalSince1980:d]);
//
//    //dos date and back
//    tm_zip t1 = [DDZippedFileInfo mzDateWithDate:[NSDate date]];
//    tm_unz t2;
//    t2.tm_hour = t1.tm_hour;
//    t2.tm_mday = t1.tm_mday;
//    t2.tm_min = t1.tm_min;
//    t2.tm_mon = t1.tm_mon;
//    t2.tm_sec = t1.tm_sec;
//    t2.tm_year = t1.tm_year;
//    NSLog(@"%@ = %@", [NSDate date], [DDZippedFileInfo dateWithMUDate:t2]);
//
//    //via tmz->dos and back
//    tm_zip z = [DDZippedFileInfo mzDateWithDate:[NSDate date]];
//    long d2 = ziplocal_TmzDateToDosDate(&z, 0);
//    NSLog(@"%@ = %@, %d", [NSDate date], [DDZippedFileInfo dateWithTimeIntervalSince1980:d2], (uLong)d==d2);
//    
//    //dos to unzip and back
//    tm_unz u;
//    unzlocal_DosDateToTmuDate(d, &u);
//    NSLog(@"%@ = %@", [NSDate date], [DDZippedFileInfo dateWithMUDate:u]);
//    
    if(argc<2)
    {
        printf("Usage of minizip demo is: %s ZIPFILE or LISTFILES_TO_ZIP\n \
               if first arg is a zip it is unpacked into subdir '%%file%%-Unpack', else all is packed into '%%file%%-pack.zip' in dir of file 1", argv[0]);
        return 1;
    }
    
    @autoreleasepool {
        NSString *file = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        if([file.pathExtension isEqualToString:@"zip"]) 
        {
            return unzip(file);
        }
        else 
        {
            NSMutableArray *files = [NSMutableArray arrayWithCapacity:argc-1];
            [files addObject:file];
            for (NSUInteger i=2; i<argc; i++) {
                [files addObject:[NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding]];
            }
            
            NSString *zip = [[[file stringByDeletingPathExtension] stringByAppendingFormat:@"-Pack"] stringByAppendingPathExtension:@"zip"];
            return writeZip(files, zip);
        }
    }
}

