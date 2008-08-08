//
//  DictionaryEntry.m
//  Lianxi
//
//  Created by Karan Misra on 08-3-15.
//

#import "DictionaryEntry.h"
#import "Pinyin.h"

@implementation DictionaryEntry

- (id)initWithCEDICTEntry:(NSString *)CEDICTEntry {
	self = [super init];
	if (self != nil) {
		NSScanner *scanner = [NSScanner scannerWithString:CEDICTEntry];
		NSString *firstPart;
		if ([scanner scanUpToString:@"/" intoString:&firstPart] == NO)
			return self;
		
		NSScanner *scanner2 = [NSScanner scannerWithString:firstPart];
		[scanner2 scanUpToString:@" " intoString:&traditional]; // get traditional
		[scanner2 scanUpToString:@" " intoString:&simplified]; // get simplified
		[scanner2 setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
		[scanner2 scanUpToString:@"[" intoString:NULL]; // eliminate [
		[scanner2 scanUpToString:@"]" intoString:&pinyin]; // get pinyin
		assert([traditional length] > 0);
		assert([simplified length] > 0);
		assert([pinyin length] > 0);

		[scanner setScanLocation:[scanner scanLocation] + 1];
		[scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
		NSMutableArray *tempArray = [[NSMutableArray alloc] init];
		while ([scanner isAtEnd] == NO) {
			NSString *aDefinition;
			[scanner scanUpToString:@"/" intoString:&aDefinition];
			[aDefinition retain];
			[tempArray addObject:aDefinition];
		}
		definitions = [[NSArray alloc] initWithArray:tempArray];
		[tempArray release];
	}
	return self;
}

- (id)initWithSimplified:(NSString *)simplifiedText 
			 traditional:(NSString *)traditionalText 
				  pinyin:(NSString *)pinyinText 
			 definitions:(NSArray *)definitionsArray {
	self = [super init];
	if (self != NULL) {
		[self setSimplified:simplifiedText];
		[self setTraditional:traditionalText];
		[self setPinyin:pinyinText];
		[self setDefinitions:definitionsArray];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init];
	if (self != NULL) {
		[self setSimplified:	[[[decoder decodeObjectForKey:@"simplified"] retain] autorelease]];
		[self setTraditional:	[[[decoder decodeObjectForKey:@"traditional"] retain] autorelease]];
		[self setPinyin:		[[[decoder decodeObjectForKey:@"pinyin"] retain] autorelease]];
		[self setDefinitions:	[[[decoder decodeObjectForKey:@"definitions"] retain] autorelease]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:simplified	forKey:@"simplified"];
	[encoder encodeObject:traditional	forKey:@"traditional"];
	[encoder encodeObject:pinyin		forKey:@"pinyin"];
	[encoder encodeObject:definitions	forKey:@"definitions"];
}

- (NSString *)description {
	NSMutableString *toReturn = 
	[NSMutableString stringWithFormat:@"Simplified: %@; Traditional: %@; Pinyin: %@; ", 
															simplified, traditional, pinyin, nil];
	for (NSString *definition in definitions)
		[toReturn appendFormat:@"%@; ", definition, nil];
	return toReturn;
}

- (int)characterCount {
	return [simplified length];
}

/* Comparison Methods */

- (NSComparisonResult)sortByPinyin:(DictionaryEntry *)other {
	return [[self pinyinWithToneMarks] localizedCompare:[other pinyinWithToneMarks]];
}

/* Accessors */

- (NSString *)simplified {
    return [[simplified retain] autorelease];
}

- (void)setSimplified:(NSString *)value {
    if (simplified != value) {
        [simplified release];
        simplified = [value copy];
    }
}

- (NSString *)traditional {
    return [[traditional retain] autorelease];
}

- (void)setTraditional:(NSString *)value {
    if (traditional != value) {
        [traditional release];
        traditional = [value copy];
    }
}

- (NSString *)pinyin {
    return [[pinyin retain] autorelease];
}

- (void)setPinyin:(NSString *)value {
    if (pinyin != value) {
        [pinyin release];
        pinyin = [value copy];
    }
}

- (NSString *)pinyinWithoutTones {
	if (pinyinWithoutTones == nil)
		[self pinyinWithToneMarks]; // to generate tonelessPinyin as a byproduct
	return pinyinWithoutTones;
}

- (NSString *)pinyinWithToneMarks {
	pinyinWithToneMarks = [Pinyin pinyinWithToneMarksFromPinyinWithToneNumbers:pinyin 
																	  toneless:&pinyinWithoutTones];
	return pinyinWithToneMarks;
}

- (NSArray *)definitions {
    return [[definitions retain] autorelease];
}

- (void)setDefinitions:(NSArray *)value {
    if (definitions != value) {
        [definitions release];
        definitions = [value retain];
    }
}

- (NSString *)definitionsAsString {
	return [definitions componentsJoinedByString:@"; "];
}

- (NSArray *)uniqueCharacters {
	NSMutableSet *uniqueCharacters = [[NSMutableSet alloc] init];
	int i;
	NSString *simplifiedChar;
	NSString *traditionalChar;
	for (i = 0; i < [simplified length]; i++) {
		simplifiedChar = [simplified substringWithRange:NSMakeRange(i, 1)];
		traditionalChar = [traditional substringWithRange:NSMakeRange(i, 1)];
		if ([simplifiedChar length] != 1 || [simplifiedChar isEqualToString:@" "]) {
			NSLog(@"DictionaryEntry::uniqueCharacters - Weird simplified character");
			NSLog([self description]);
		}
		if ([traditionalChar length] != 1 || [traditionalChar isEqualToString:@" "]) {
			NSLog(@"DictionaryEntry::uniqueCharacters - Weird traditional character");
			NSLog([self description]);
		}
		[uniqueCharacters addObject:simplifiedChar];
		[uniqueCharacters addObject:traditionalChar];
	}
	return [uniqueCharacters allObjects];
}

@end
