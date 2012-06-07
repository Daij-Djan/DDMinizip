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

