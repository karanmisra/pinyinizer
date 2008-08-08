//
//  Pinyin.h
//  Lianxi
//
//  Created by Karan Misra on 08-3-23.
//

#import <Cocoa/Cocoa.h>


@interface Pinyin : NSObject {
}
+ (void)initialize;
+ (NSString *)pinyinWithToneMarksFromPinyinWithToneNumbers:(NSString *)oldPinyin toneless:(NSString **)tonelessToReturn;
+ (NSString *)pinyinFromSyllable:(NSString *)syllable andToneNumber:(int)toneNumber;
@end
