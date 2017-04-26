

#import "DDRSAWrapper.h"
#import <CommonCrypto/CommonCrypto.h>

#import <openssl/pem.h>

@implementation DDRSAWrapper
#pragma mark - openssl
#pragma mark ---生成密钥对
+ (BOOL)generateRSAKeyPairWithKeySize:(int)keySize publicKey:(RSA **)publicKey privateKey:(RSA **)privateKey {
	if (keySize == 512 || keySize == 1024 || keySize == 2048) {
		RSA *rsa = RSA_generate_key(keySize,RSA_F4,NULL,NULL);
		if (rsa) {
			*privateKey = RSAPrivateKey_dup(rsa);
			*publicKey = RSAPublicKey_dup(rsa);
			if (publicKey && privateKey) {
				return YES;
			}
		}
	}
	
	return NO;
}
#pragma mark ---密钥格式转换
+ (RSA *)RSAPublicKeyFromPEM:(NSString *)publicKeyPEM
{
	const char *buffer = [publicKeyPEM UTF8String];
	
	BIO *bpubkey = BIO_new_mem_buf(buffer, (int)strlen(buffer));
	
	RSA *rsaPublic = PEM_read_bio_RSA_PUBKEY(bpubkey, NULL, NULL, NULL);
	
	BIO_free_all(bpubkey);
	return rsaPublic;
}

+ (RSA *)RSAPublicKeyFromBase64:(NSString *)publicKey
{
	//格式化公钥
	NSMutableString *result = [NSMutableString string];
	[result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
	int count = 0;
	for (int i = 0; i < [publicKey length]; ++i) {
		
		unichar c = [publicKey characterAtIndex:i];
		if (c == '\n' || c == '\r') {
			continue;
		}
		[result appendFormat:@"%c", c];
		if (++count == 64) {
			[result appendString:@"\n"];
			count = 0;
		}
	}
	[result appendString:@"\n-----END PUBLIC KEY-----"];
	
	return [self RSAPublicKeyFromPEM:result];
	
}

+ (RSA *)RSAPrivateKeyFromBase64:(NSString *)privateKey
{
	//格式化私钥
	const char *pstr = [privateKey UTF8String];
	int len = (int)[privateKey length];
	NSMutableString *result = [NSMutableString string];
	[result appendString:@"-----BEGIN RSA PRIVATE KEY-----\n"];
	int index = 0;
	int count = 0;
	while (index < len) {
		char ch = pstr[index];
		if (ch == '\r' || ch == '\n') {
			++index;
			continue;
		}
		[result appendFormat:@"%c", ch];
		if (++count == 64) {
			
			[result appendString:@"\n"];
			count = 0;
		}
		index++;
	}
	[result appendString:@"\n-----END RSA PRIVATE KEY-----"];
	return [self RSAPrivateKeyFromPEM:result];
	
}
+ (RSA *)RSAPrivateKeyFromPEM:(NSString *)privatePEM {
	
	const char *buffer = [privatePEM UTF8String];
	
	BIO *bpubkey = BIO_new_mem_buf(buffer, (int)strlen(buffer));
	
	RSA *rsaPrivate = PEM_read_bio_RSAPrivateKey(bpubkey, NULL, NULL, NULL);
	BIO_free_all(bpubkey);
	return rsaPrivate;
}

+ (NSString *)PEMFormatPublicKey:(RSA *)publicKey
{	
	if (!publicKey) {
		return nil;
	}
	
	BIO *bio = BIO_new(BIO_s_mem());
	PEM_write_bio_RSA_PUBKEY(bio, publicKey);
	
	BUF_MEM *bptr;
	BIO_get_mem_ptr(bio, &bptr);
	BIO_set_close(bio, BIO_NOCLOSE); /* So BIO_free() leaves BUF_MEM alone */
	BIO_free(bio);
	
	return [NSString stringWithUTF8String:bptr->data];
}


+ (NSString *)PEMFormatPrivateKey:(RSA *)privateKey
{
	
	if (!privateKey) {
		return nil;
	}
	
	BIO *bio = BIO_new(BIO_s_mem());
	PEM_write_bio_RSAPrivateKey(bio, privateKey, NULL, NULL, 0, NULL, NULL);
	
	BUF_MEM *bptr;
	BIO_get_mem_ptr(bio, &bptr);
	BIO_set_close(bio, BIO_NOCLOSE); /* So BIO_free() leaves BUF_MEM alone */
	BIO_free(bio);
	
	return [NSString stringWithUTF8String:bptr->data];
}

+ (NSString *)base64EncodedFromPEMFormat:(NSString *)PEMFormat
{
	return [[PEMFormat componentsSeparatedByString:@"-----"] objectAtIndex:2];
}

#pragma mark ---加解密
+ (NSData *)encryptWithPublicKey:(RSA *)publicKey plainData:(NSData *)plainData
{
	if ([plainData length]) {
		
		int publicRSALength = RSA_size(publicKey);
		double totalLength = [plainData length];
		int blockSize = publicRSALength - 11;
		int blockCount = ceil(totalLength / blockSize);    
		size_t publicEncryptSize = publicRSALength;
		NSMutableData *encryptDate = [NSMutableData data];
		for (int i = 0; i < blockCount; i++) {
			NSUInteger loc = i * blockSize;
			int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
			NSData *dataSegment = [plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
			char *publicEncrypt = malloc(publicRSALength);
			memset(publicEncrypt, 0, publicRSALength);
			const unsigned char *str = [dataSegment bytes];
			
			if(RSA_public_encrypt(dataSegmentRealSize,str,(unsigned char*)publicEncrypt,publicKey,RSA_PKCS1_PADDING)>=0){
				NSData *encryptData = [[NSData alloc] initWithBytes:publicEncrypt length:publicEncryptSize];
				[encryptDate appendData:encryptData];
			}
			free(publicEncrypt);
		}
		return encryptDate;
	}
	
	return nil;
}

+ (NSData *)decryptWithPrivateKey:(RSA *)privateKey cipherData:(NSData *)cipherData
{
	if ([cipherData length]) {
		
		int privateRSALenght = RSA_size(privateKey);
		double totalLength = [cipherData length];
		int blockSize = privateRSALenght;
		int blockCount = ceil(totalLength / blockSize);
		NSMutableData *decrypeData = [NSMutableData data];
		for (int i = 0; i < blockCount; i++) {
			NSUInteger loc = i * blockSize;
			long dataSegmentRealSize = MIN(blockSize, totalLength - loc);
			NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
			const unsigned char *str = [dataSegment bytes];
			unsigned char *privateDecrypt = malloc(privateRSALenght);
			memset(privateDecrypt, 0, privateRSALenght);
			
			if(RSA_private_decrypt(privateRSALenght,str,privateDecrypt,privateKey,RSA_PKCS1_PADDING)>=0){
				NSInteger length =strlen((char *)privateDecrypt);
				NSData *data = [[NSData alloc] initWithBytes:privateDecrypt length:length];
				[decrypeData appendData:data];
			}
			free(privateDecrypt);
		}
		
		return decrypeData;
	}
	
	return nil;
}

+ (NSData *)encryptWithPrivateRSA:(RSA *)privateKey plainData:(NSData *)plainData {
    int privateRSALength = RSA_size(privateKey);
    double totalLength = [plainData length];
    int blockSize = privateRSALength - 11;
    int blockCount = ceil(totalLength / blockSize);
    size_t privateEncryptSize = privateRSALength;
    NSMutableData *encryptDate = [NSMutableData data];
    for (int i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        NSData *dataSegment = [plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        char *publicEncrypt = malloc(privateRSALength);
        memset(publicEncrypt, 0, privateRSALength);
        const unsigned char *str = [dataSegment bytes];
        if(RSA_private_encrypt(dataSegmentRealSize,str,(unsigned char*)publicEncrypt,privateKey,RSA_PKCS1_PADDING)>=0){
            NSData *encryptData = [[NSData alloc] initWithBytes:publicEncrypt length:privateEncryptSize];
            [encryptDate appendData:encryptData];
        }
        free(publicEncrypt);
    }
    return encryptDate;

}

+ (NSData *)decryptWithPublicKey:(RSA *)publicKey cipherData:(NSData *)cipherData {
    int publicRSALenght = RSA_size(publicKey);
    double totalLength = [cipherData length];
    int blockSize = publicRSALenght;
    int blockCount = ceil(totalLength / blockSize);
    NSMutableData *decrypeData = [NSMutableData data];
    for (int i = 0; i < blockCount; i++) {
        NSUInteger loc = i * blockSize;
        long dataSegmentRealSize = MIN(blockSize, totalLength - loc);
        NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
        const unsigned char *str = [dataSegment bytes];
        unsigned char *privateDecrypt = malloc(publicRSALenght);
        memset(privateDecrypt, 0, publicRSALenght);
        if(RSA_public_decrypt(publicRSALenght,str,privateDecrypt,publicKey,RSA_PKCS1_PADDING)>=0){
            NSInteger length =strlen((char *)privateDecrypt);
            NSData *data = [[NSData alloc] initWithBytes:privateDecrypt length:length];
            [decrypeData appendData:data];
        }
        free(privateDecrypt);
    }
    return decrypeData;
}

#pragma mark - SecKeyRef
#pragma mark ---生成密钥对
+ (BOOL)generateSecKeyPairWithKeySize:(NSUInteger)keySize publicKeyRef:(SecKeyRef *)publicKeyRef privateKeyRef:(SecKeyRef *)privateKeyRef{
	OSStatus sanityCheck = noErr;
	if (keySize == 512 || keySize == 1024 || keySize == 2048) {
		NSData *publicTag = [@"com.your.company.publickey" dataUsingEncoding:NSUTF8StringEncoding];
		NSData *privateTag = [@"com.your.company.privateTag" dataUsingEncoding:NSUTF8StringEncoding];
		
		NSMutableDictionary * privateKeyAttr = [[NSMutableDictionary alloc] init];
		NSMutableDictionary * publicKeyAttr = [[NSMutableDictionary alloc] init];
		NSMutableDictionary * keyPairAttr = [[NSMutableDictionary alloc] init];
		
		// Set top level dictionary for the keypair.
		[keyPairAttr setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
		[keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:keySize] forKey:(id)kSecAttrKeySizeInBits];
		
		// Set the private key dictionary.
		[privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecAttrIsPermanent];
		[privateKeyAttr setObject:privateTag forKey:(id)kSecAttrApplicationTag];
		// See SecKey.h to set other flag values.
		
		// Set the public key dictionary.
		[publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecAttrIsPermanent];
		[publicKeyAttr setObject:publicTag forKey:(id)kSecAttrApplicationTag];
		// See SecKey.h to set other flag values.
		
		// Set attributes to top level dictionary.
		[keyPairAttr setObject:privateKeyAttr forKey:(id)kSecPrivateKeyAttrs];
		[keyPairAttr setObject:publicKeyAttr forKey:(id)kSecPublicKeyAttrs];
		
		// SecKeyGeneratePair returns the SecKeyRefs just for educational purposes.
		sanityCheck = SecKeyGeneratePair((CFDictionaryRef)keyPairAttr, publicKeyRef, privateKeyRef);
		if ( sanityCheck == noErr && publicKeyRef != NULL && privateKeyRef != NULL) {
			return YES;
		}
	}
	return NO;
}

#pragma mark ---密钥类型转换
static NSString * const kTransfromIdenIdentifierPublic = @"kTransfromIdenIdentifierPublic";
static NSString * const kTransfromIdenIdentifierPrivate = @"kTransfromIdenIdentifierPrivate";
+ (NSData *)publicKeyBitsFromSecKey:(SecKeyRef)givenKey {
	
	NSData *peerTag = [kTransfromIdenIdentifierPublic dataUsingEncoding:NSUTF8StringEncoding];
	
	OSStatus sanityCheck = noErr;
	NSData * keyBits = nil;
	
	NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
	[queryKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[queryKey setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
	[queryKey setObject:(__bridge id)givenKey forKey:(__bridge id)kSecValueRef];
	[queryKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[queryKey setObject:@YES forKey:(__bridge id)kSecReturnData];
	[queryKey setObject:(id)kSecAttrKeyClassPublic forKey:(id)kSecAttrKeyClass];
	
	CFTypeRef result;
	sanityCheck = SecItemAdd((__bridge CFDictionaryRef) queryKey, &result);
	if (sanityCheck == errSecSuccess) {
		keyBits = CFBridgingRelease(result);
		
		(void)SecItemDelete((__bridge CFDictionaryRef) queryKey);
	}
	
	return keyBits;
}

+ (SecKeyRef)publicSecKeyFromKeyBits:(NSData *)givenData {
	
	NSData *peerTag = [kTransfromIdenIdentifierPublic dataUsingEncoding:NSUTF8StringEncoding];
	
	OSStatus sanityCheck = noErr;
	SecKeyRef secKey = nil;
	
	NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
	[queryKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[queryKey setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
	[queryKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[queryKey setObject:givenData forKey:(__bridge id)kSecValueData];
	[queryKey setObject:@YES forKey:(__bridge id)kSecReturnRef];
	[queryKey setObject:(id)kSecAttrKeyClassPublic forKey:(id)kSecAttrKeyClass];
	
	CFTypeRef result;
	sanityCheck = SecItemAdd((__bridge CFDictionaryRef) queryKey, &result);
	if (sanityCheck == errSecSuccess) {
		secKey = (SecKeyRef)result;
		
		(void)SecItemDelete((__bridge CFDictionaryRef) queryKey);
	}
	
	return secKey;
}

+ (NSData *)privateKeyBitsFromSecKey:(SecKeyRef)givenKey {
	
	NSData *peerTag = [kTransfromIdenIdentifierPrivate dataUsingEncoding:NSUTF8StringEncoding];
	
	OSStatus sanityCheck = noErr;
	NSData * keyBits = nil;
	
	NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
	[queryKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[queryKey setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
	[queryKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[queryKey setObject:(id)kSecAttrKeyClassPrivate forKey:(id)kSecAttrKeyClass];
	
	[queryKey setObject:(__bridge id)givenKey forKey:(__bridge id)kSecValueRef];
	[queryKey setObject:@YES forKey:(__bridge id)kSecReturnData];
	CFTypeRef result;
	sanityCheck = SecItemAdd((__bridge CFDictionaryRef) queryKey, &result);
	if (sanityCheck == errSecSuccess) {
		keyBits = CFBridgingRelease(result);
		
		(void)SecItemDelete((__bridge CFDictionaryRef) queryKey);
	}
	
	return keyBits;
}

+ (SecKeyRef)privateSecKeyFromKeyBits:(NSData *)givenData {
	
	NSData *peerTag = [kTransfromIdenIdentifierPrivate dataUsingEncoding:NSUTF8StringEncoding];
	
	OSStatus sanityCheck = noErr;
	SecKeyRef secKey = nil;
	
	NSMutableDictionary * queryKey = [[NSMutableDictionary alloc] init];
	[queryKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[queryKey setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
	[queryKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[queryKey setObject:(id)kSecAttrKeyClassPrivate forKey:(id)kSecAttrKeyClass];
	[queryKey setObject:givenData forKey:(__bridge id)kSecValueData];
	[queryKey setObject:@YES forKey:(__bridge id)kSecReturnRef];
	
	CFTypeRef result;
	sanityCheck = SecItemAdd((__bridge CFDictionaryRef) queryKey, &result);
	if (sanityCheck == errSecSuccess) {
		secKey = (SecKeyRef)result;
		
		(void)SecItemDelete((__bridge CFDictionaryRef) queryKey);
	}
	
	return secKey;
}

#pragma mark ---加解密

+ (NSData *)encryptwithPublicKeyRef:(SecKeyRef)publciKeyRef plainData:(NSData *)plainData {
	
	size_t publciKeyLenght = SecKeyGetBlockSize(publciKeyRef) * sizeof(uint8_t);
	double totalLength = [plainData length];
	size_t blockSize = publciKeyLenght - 11;
	int blockCount = ceil(totalLength / blockSize);
	NSMutableData *encryptDate = [NSMutableData data];
	for (int i = 0; i < blockCount; i++) {
		NSUInteger loc = i * blockSize;
		int dataSegmentRealSize = MIN(blockSize, totalLength - loc);
		NSData *dataSegment = [plainData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
		unsigned char *cipherBuffer = malloc(publciKeyLenght);
		memset(cipherBuffer, 0, publciKeyLenght);
		
		OSStatus status = noErr;
		size_t cipherBufferSize ;
		status = SecKeyEncrypt(publciKeyRef,
							   kSecPaddingPKCS1,
							   [dataSegment bytes],
							   dataSegmentRealSize,
							   cipherBuffer,
							   &cipherBufferSize
							   );
		
		if(status == noErr){
			NSData *encryptData = [[NSData alloc] initWithBytes:cipherBuffer length:cipherBufferSize];
			[encryptDate appendData:encryptData];
		}
		free(cipherBuffer);
	}
	return encryptDate;

}

+ (NSData *)decryptWithPrivateKeyRef:(SecKeyRef)privateKeyRef cipherData:(NSData *)cipherData {
	
	if ([cipherData length]) {
		
		size_t privateRSALenght = SecKeyGetBlockSize(privateKeyRef) * sizeof(uint8_t);
		double totalLength = [cipherData length];
		size_t blockSize = privateRSALenght;
		int blockCount = ceil(totalLength / blockSize);
		NSMutableData *decrypeData = [NSMutableData data];
		for (int i = 0; i < blockCount; i++) {
			NSUInteger loc = i * blockSize;
			long dataSegmentRealSize = MIN(blockSize, totalLength - loc);
			NSData *dataSegment = [cipherData subdataWithRange:NSMakeRange(loc, dataSegmentRealSize)];
			unsigned char *plainBuffer = malloc(privateRSALenght);
			memset(plainBuffer, 0, privateRSALenght);
			OSStatus status = noErr;
			size_t plainBufferSize ;
			status = SecKeyDecrypt(privateKeyRef,
								   kSecPaddingPKCS1,
								   [dataSegment bytes],
								   dataSegmentRealSize,
								   plainBuffer,
								   &plainBufferSize
								   );
			if(status == noErr){
				NSData *data = [[NSData alloc] initWithBytes:plainBuffer length:plainBufferSize];
				[decrypeData appendData:data];
			}
			free(plainBuffer);
		}
		
		return decrypeData;
	}
	
	return nil;
}


#pragma mark - 公钥与模数和指数转换
//公钥指数
+ (NSData *)getPublicKeyExp:(NSData *)pk {

	if (pk == NULL) return NULL;
	
	int iterator = 0;
	
	iterator++; // TYPE - bit stream - mod + exp
	[self derEncodingGetSizeFrom:pk at:&iterator]; // Total size
	
	iterator++; // TYPE - bit stream mod
	int mod_size = [self derEncodingGetSizeFrom:pk at:&iterator];
	iterator += mod_size;
	
	iterator++; // TYPE - bit stream exp
	int exp_size = [self derEncodingGetSizeFrom:pk at:&iterator];
	
	return [pk subdataWithRange:NSMakeRange(iterator, exp_size)];
}
//模数
+ (NSData *)getPublicKeyMod:(NSData *)pk {
	if (pk == NULL) return NULL;
	
	int iterator = 0;
	
	iterator++; // TYPE - bit stream - mod + exp
	[self derEncodingGetSizeFrom:pk at:&iterator]; // Total size
	
	iterator++; // TYPE - bit stream mod
	int mod_size = [self derEncodingGetSizeFrom:pk at:&iterator];
	
	return [pk subdataWithRange:NSMakeRange(iterator, mod_size)];
}

+ (int)derEncodingGetSizeFrom:(NSData*)buf at:(int*)iterator {
	const uint8_t* data = [buf bytes];
	int itr = *iterator;
	int num_bytes = 1;
	int ret = 0;
	
	if (data[itr] > 0x80) {
		num_bytes = data[itr] - 0x80;
		itr++;
	}
	
	for (int i = 0 ; i < num_bytes; i++) ret = (ret * 0x100) + data[itr + i];
	
	*iterator = itr + num_bytes;
	return ret;
}


//指数模数生成公钥
+ (RSA *)publicKeyFormMod:(NSString *)mod exp:(NSString *)exp {

	RSA * rsa_pub = RSA_new();
	
	const char *N=[mod UTF8String] ;
	const char *E=[exp UTF8String];
	
	if (!BN_hex2bn(&rsa_pub->n, N)) {
		return nil;
	}
	
	if (!BN_hex2bn(&rsa_pub->e, E)) {
		return nil;
	}
	return rsa_pub;
}

+ (NSData *)publicKeyDataWithMod:(NSData *)modBits exp:(NSData *)expBits
{
	
	/*
		整个数据分为8个部分
		0x30 包长 { 0x02 包长 { modBits} 0x02 包长 { expBits } }
	 */
	
	//创建证书存储空间，其中第二第四部分包长按照 ** 1byte ** 处理，如果不够在后面在添加
	NSMutableData *fullKey = [[NSMutableData alloc] initWithLength:6+[modBits length]+[expBits length]];
	unsigned char *fullKeyBytes = [fullKey mutableBytes];
	
	unsigned int bytep = 0; // 当前指针位置
	
	//第一部分：（1 byte）固定位0x30
	fullKeyBytes[bytep++] = 0x30;
	
	//第二部分：（1-3 byte）记录总包长
	NSUInteger ml = 4 + [modBits length]  + [expBits length];
	if (ml >= 256) {
		
		//当长度大于256时占用 3 byte
		fullKeyBytes[bytep++] = 0x82;
		[fullKey increaseLengthBy:2];
		
		//先设置高位数据
		fullKeyBytes[bytep++] = ml >> 8;
	}else if(ml >= 128) {
		
		//当长度大于128时占用 2 byte
		fullKeyBytes[bytep++] = 0x81 ;
		[fullKey increaseLengthBy:1];
	}
	unsigned int seqLenLoc = bytep; // 记录总长数据的位置，如果需要添加可直接取值
	fullKeyBytes[bytep++] = 4 + [modBits length] + [expBits length]; // 默认第二第四部分包长按照 ** 1byte ** 处理
	
	//第三部分 （1 byte）固定位0x02
	fullKeyBytes[bytep++] = 0x02;
	
	//第四部分：（1-3 byte）记录包长
	ml = [modBits length];
	if (ml >= 256) {
		
		//当长度大于256时占用 3 byte
		fullKeyBytes[bytep++] = 0x82;
		[fullKey increaseLengthBy:2];
		
		//先设置高位数据
		fullKeyBytes[bytep++] = ml >> 8;
		
		//第二部分包长+2
		fullKeyBytes[seqLenLoc] += 2;
	}else if(ml >= 128){
		//当长度大于256时占用 2 byte
		fullKeyBytes[bytep++] = 0x81 ;
		[fullKey increaseLengthBy:1];
		
		//第二部分包长＋1
		fullKeyBytes[seqLenLoc]++;
	}
	// 这里如果 [modBits length] > 255 (ff),就会数据溢出，高位会被截断。所以上面 ml >> 8 先对高位进行了复制
	fullKeyBytes[bytep++] = [modBits length];
	
	
	//第五部分
	[modBits getBytes:&fullKeyBytes[bytep] length:[modBits length]];
	bytep += [modBits length];
	
	//第六部分
	fullKeyBytes[bytep++] = 0x02;
	
	//第七部分
	fullKeyBytes[bytep++] = [expBits length];
	
	//第八部分
	[expBits getBytes:&fullKeyBytes[bytep++] length:[expBits length]];
	
	return fullKey;
}

@end
