
#import "HTTPConnection.h"

@class MultipartFormDataParser;

@interface MyHTTPConnection : HTTPConnection  {

    MultipartFormDataParser*        parser;             //
	NSFileHandle*					storeFile;          //文件操作
	NSMutableArray*					uploadedFiles;      //上传文件数组
}

@end
