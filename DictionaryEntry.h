//
//  DictionaryEntry.h
//  Lianxi
//
//  Created by Karan Misra on 08-3-15.
//

#import <Cocoa/Cocoa.h>

@interface DictionaryEntry : NSObject {
	NSString	*simplified;
	NSString	*traditional;
	NSString	*pinyin;
	NSArray		*definitions;
@private
	NSString	*pinyinWithToneMarks;
	NSString	*pinyinWithoutTones;
}
- (id)initWithCEDICTEntry:(NSString *)CEDICTEntry;
- (id)initWithSimplified:(NSString *)simplified 
			 traditional:(NSString *)traditional 
				  pinyin:(NSString *)pinyin 
			 definitions:(NSArray *)definitions;

- (int)characterCount;

/* Convenience Methods */
- (NSString *)pinyinWithoutTones;
- (NSString *)pinyinWithToneMarks;
- (NSString *)definitionsAsString;
- (NSArray *)uniqueCharacters;

- (NSComparisonResult)sortByPinyin:(DictionaryEntry *)other;

- (NSString *)simplified;
- (void)setSimplified:(NSString *)value;

- (NSString *)traditional;
- (void)setTraditional:(NSString *)value;

- (NSString *)pinyin;
- (void)setPinyin:(NSString *)value;

- (NSArray *)definitions;
- (void)setDefinitions:(NSArray *)value;


@end
