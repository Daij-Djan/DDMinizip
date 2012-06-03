#About
this project providers a wrapper around libz for iOS5 and OSX.

Based on code from acsolu@gmail.com for iOS I expanded and modified it to work as a 'drop-in' static library for OSX 10.7 and IOS 5.

I split the code into a Writer and a Reader, added a proper Delegate that gets asked about what to extract and and made the original framework to work with ARC, compile as a separate lib and use ARC. 

#example usage
##zip
	DDZipWriter *w = [[DDZipWriter alloc] init];
	[w newZipFile:@"testfile.zip"];
	for(NSString *file in files) {
	    BOOL res = [w addFileToZip:file newname:[NSString stringWithFormat:@"modified_%@", file]];
    
	    if(res) {
	        NSString *n = [file lastPathComponent];
	        NSLog(@"added file to zip: %@", n);
	    }       
	}
	[w closeZipFile];

##unzip
	DDZipReader *z = [[DDZipReader alloc] init];
	z.delegate = self;
	for(NSString *zip in zips) {
	    [z openZipFile:zip];
	    BOOL res = [z UnzipFileTo:path overwriteAlways:NO flattenStructure:NO];
	    [z closeZipFile];

	    if(res) {
	        NSString *n = [zip lastPathComponent];
	        NSLog(@"Extracted zip file: %@", n);
	    }       
	}
	...
	- (BOOL)zipArchive:(DDZipReader *)zip shouldExtractFile:(NSString *)file {
	    return ([file rangeOfString:@"__MACOSX"].location==NSNotFound);
	}

	- (BOOL)zipArchive:(DDZipReader *)zip shouldOverwriteFile:(NSString *)file {
	//    NSLog(@"%@", file);
	    return NO;
	}

	