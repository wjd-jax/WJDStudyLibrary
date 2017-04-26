
#import <Foundation/Foundation.h>
#import <openssl/rsa.h>

@interface DDRSAWrapper : NSObject
#pragma mark - openssl

+ (BOOL)generateRSAKeyPairWithKeySize:(int)keySize publicKey:(RSA **)publicKey privateKey:(RSA **)privateKey;

+ (RSA *)RSAPublicKeyFromBase64:(NSString *)publicKey;
+ (RSA *)RSAPrivateKeyFromBase64:(NSString *)privateKey;
+ (RSA *)RSAPublicKeyFromPEM:(NSString *)publicKeyPEM;
+ (RSA *)RSAPrivateKeyFromPEM:(NSString *)privatePEM;

+ (NSString *)PEMFormatPublicKey:(RSA *)publicKey;
+ (NSString *)PEMFormatPrivateKey:(RSA *)privateKey;

+ (NSString *)base64EncodedFromPEMFormat:(NSString *)PEMFormat;

+ (NSData *)encryptWithPublicKey:(RSA *)publicKey plainData:(NSData *)plainData;
+ (NSData *)decryptWithPrivateKey:(RSA *)privateKey cipherData:(NSData *)cipherData;

+ (NSData *)encryptWithPrivateRSA:(RSA *)privateKey plainData:(NSData *)plainData;
+ (NSData *)decryptWithPublicKey:(RSA *)publicKey cipherData:(NSData *)cipherData;
#pragma mark - SecKeyRef
+ (BOOL)generateSecKeyPairWithKeySize:(NSUInteger)keySize publicKeyRef:(SecKeyRef *)publicKeyRef privateKeyRef:(SecKeyRef *)privateKeyRef;

+ (NSData *)publicKeyBitsFromSecKey:(SecKeyRef)givenKey;
+ (SecKeyRef)publicSecKeyFromKeyBits:(NSData *)givenData;

+ (NSData *)privateKeyBitsFromSecKey:(SecKeyRef)givenKey;
+ (SecKeyRef)privateSecKeyFromKeyBits:(NSData *)givenData;

+ (NSData *)encryptwithPublicKeyRef:(SecKeyRef)publciKeyRef plainData:(NSData *)plainData;
+ (NSData *)decryptWithPrivateKeyRef:(SecKeyRef)privateKeyRef cipherData:(NSData *)cipherData;

#pragma mark - 指数和模数
+ (NSData *)getPublicKeyExp:(NSData *)pk;
+ (NSData *)getPublicKeyMod:(NSData *)pk ;

+ (RSA *)publicKeyFormMod:(NSString *)mod exp:(NSString *)exp;
+ (NSData *)publicKeyDataWithMod:(NSData *)modBits exp:(NSData *)expBits;
@end
