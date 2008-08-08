//
//  Pinyin.m
//  Lianxi
//
//  Created by Karan Misra on 08-3-23.
//

#import "Pinyin.h"

NSArray *initials;
NSArray *allSyllables;
NSArray *syllablesWithToneMarkOnSecondVowel;
NSString *aTones = @"āáǎàa";
NSString *oTones = @"ōóǒòo";
NSString *eTones = @"ēéěèe";
NSString *iTones = @"īíǐìi";
NSString *uTones = @"ūúǔùu";
NSString *vTones = @"ǖǘǚǜü";

@implementation Pinyin
+ (void)initialize {
	if (self == [Pinyin class]) {
		initials = [[NSArray arrayWithObjects:
						@"b", @"p", @"m", @"f", @"d", @"t", @"n", @"l", @"g", @"k", @"h", @"zh", @"ch", @"sh", @"z", @"c", @"s", @"r", @"j", @"q", @"x", @"w", @"y", 
						nil] retain];
		
		allSyllables = [[NSArray arrayWithObjects:
						@"a", @"ba", @"pa", @"ma", @"fa", @"da", @"ta", @"na", @"la", @"ga", @"ka", @"ha", @"za", @"ca", @"sa", @"zha", @"cha", @"sha",
						@"o", @"bo", @"po", @"mo", @"fo",
						@"e", @"me", @"de", @"te", @"ne", @"le", @"ge", @"ke", @"he", @"ze", @"ce", @"se", @"zhe", @"che", @"she", @"re",
						@"ai", @"bai", @"pai", @"mai", @"dai", @"tai", @"nai", @"lai", @"gai", @"kai", @"hai", @"zai", @"cai", @"sai", @"zhai", @"chai", @"shai",
						@"ei", @"bei", @"pei", @"mei", @"fei", @"dei", @"tei", @"nei", @"lei", @"gei", @"kei", @"hei", @"zei", @"zhei", @"shei",
						@"ao", @"bao", @"pao", @"mao", @"dao", @"tao", @"nao", @"lao", @"gao", @"kao", @"hao", @"zao", @"cao", @"sao", @"zhao", @"chao", @"shao", @"rao",
						@"ou", @"pou", @"mou", @"fou", @"dou", @"tou", @"nou", @"lou", @"gou", @"kou", @"hou", @"zou", @"cou", @"sou", @"zhou", @"chou", @"shou", @"rou",
						@"an", @"ban", @"pan", @"man", @"fan", @"dan", @"tan", @"nan", @"lan", @"gan", @"kan", @"han", @"zan", @"can", @"san", @"zhan", @"chan", @"shan", @"ran",
						@"ang", @"bang", @"pang", @"mang", @"fang", @"dang", @"tang", @"nang", @"lang", @"gang", @"kang", @"hang", @"zang", @"cang", @"sang", @"zhang", @"chang", @"shang", @"rang",
						@"en", @"ben", @"pen", @"men", @"fen", @"den", @"nen", @"gen", @"ken", @"hen", @"zen", @"cen", @"sen", @"zhen", @"chen", @"shen", @"ren",
						@"eng", @"beng", @"peng", @"meng", @"feng", @"deng", @"teng", @"neng", @"leng", @"geng", @"keng", @"heng", @"zeng", @"ceng", @"seng", @"zheng", @"cheng", @"sheng", @"reng",
						@"dong", @"tong", @"nong", @"long", @"gong", @"kong", @"hong", @"zong", @"cong", @"song", @"zhong", @"chong", @"rong",
						@"wu", @"bu", @"pu", @"mu", @"fu", @"du", @"tu", @"nu", @"lu", @"gu", @"ku", @"hu", @"zu", @"cu", @"su", @"zhu", @"chu", @"shu", @"ru",
						@"wa", @"gua", @"kua", @"hua", @"zhua", @"chua", @"shua", @"rua",
						@"wo", @"duo", @"tuo", @"nuo", @"luo", @"guo", @"kuo", @"huo", @"zuo", @"cuo", @"suo", @"zhuo", @"chuo", @"shuo", @"ruo",
						@"wai", @"guai", @"kuai", @"huai", @"zhuai", @"chuai", @"shuai",
						@"wei", @"dui", @"tui", @"gui", @"kui", @"hui", @"zui", @"cui", @"sui", @"zhui", @"chui", @"shui", @"rui",
						@"wan", @"duan", @"tuan", @"nuan", @"luan", @"guan", @"kuan", @"huan", @"zuan", @"cuan", @"suan", @"zhuan", @"chuan", @"shuan", @"ruan",
						@"wang", @"guang", @"kuang", @"huang", @"zhuang", @"chuang", @"shuang",
						@"wen", @"dun", @"tun", @"nun", @"lun", @"gun", @"kun", @"hun", @"zun", @"cun", @"sun", @"zhun", @"chun", @"shun", @"run",
						@"weng",
						@"yi", @"bi", @"pi", @"mi", @"di", @"ti", @"ni", @"li", @"zi", @"ci", @"si", @"zhi", @"shi", @"chi", @"ri", @"ji", @"qi", @"xi",
						@"ya", @"dia", @"lia", @"jia", @"qia", @"xia",
						@"ye", @"bie", @"pie", @"mie", @"die", @"tie", @"nie", @"lie", @"jie", @"qie", @"xie",
						@"yao", @"biao", @"piao", @"miao", @"diao", @"tiao", @"niao", @"liao", @"jiao", @"qiao", @"xiao",
						@"you", @"miu", @"diu", @"niu", @"liu", @"jiu", @"qiu", @"xiu",
						@"yan", @"bian", @"pian", @"mian", @"dian", @"tian", @"nian", @"lian", @"jian", @"qian", @"xian",
						@"yang", @"niang", @"liang", @"jiang", @"qiang", @"xiang",
						@"yin", @"bin", @"pin", @"min", @"nin", @"lin", @"jin", @"qin", @"xin",
						@"ying", @"bing", @"ping", @"ming", @"ding", @"ting", @"ning", @"ling", @"jing", @"qing", @"xing",
						@"yong", @"jiong", @"xiong", @"qiong",
						@"yu", @"nü", @"nv", @"lü", @"lv", @"ju", @"qu", @"xu",
						@"yue", @"nüe", @"nve", @"lüe", @"lve", @"jue", @"que", @"xue",
						@"yuan", @"juan", @"quan", @"xuan",
						@"yun", @"jun", @"qun", @"xun",
						@"er",
						nil] retain];
		
		syllablesWithToneMarkOnSecondVowel = [[NSArray arrayWithObjects:
											  @"gua", @"kua", @"hua", @"zhua", @"chua", @"shua", @"rua",
											  @"duo", @"tuo", @"nuo", @"luo", @"guo", @"kuo", @"huo", @"zuo", @"cuo", @"suo", @"zhuo", @"chuo", @"shuo", @"ruo",
											  @"guai", @"kuai", @"huai", @"zhuai", @"chuai", @"shuai",
											  @"dui", @"tui", @"gui", @"kui", @"hui", @"zui", @"cui", @"sui", @"zhui", @"chui", @"shui", @"rui",
											  @"duan", @"tuan", @"nuan", @"luan", @"guan", @"kuan", @"huan", @"zuan", @"cuan", @"suan", @"zhuan", @"chuan", @"shuan", @"ruan",
											  @"guang", @"kuang", @"huang", @"zhuang", @"chuang", @"shuang",
											  @"dia", @"lia", @"jia", @"qia", @"xia",
											  @"bie", @"pie", @"mie", @"die", @"tie", @"nie", @"lie", @"jie", @"qie", @"xie",
											  @"biao", @"piao", @"miao", @"diao", @"tiao", @"niao", @"liao", @"jiao", @"qiao", @"xiao",
											  @"miu", @"diu", @"niu", @"liu", @"jiu", @"qiu", @"xiu",
											  @"bian", @"pian", @"mian", @"dian", @"tian", @"nian", @"lian", @"jian", @"qian", @"xian",
											  @"niang", @"liang", @"jiang", @"qiang", @"xiang",
											  @"jiong", @"xiong", @"qiong",
											  @"yue", @"nüe", @"nve", @"lüe", @"lve", @"jue", @"que", @"xue",
											  nil] retain];
	}
}

+ (NSString *)pinyinWithToneMarksFromPinyinWithToneNumbers:(NSString *)oldPinyin toneless:(NSString **)tonelessToReturn {
	if (oldPinyin == nil || [oldPinyin length] == 0)
		return nil;

	NSScanner		*scanner;
	NSMutableString	*newPinyin;
	NSMutableString	*tonelessPinyin;
	NSString		*syllable;
	NSCharacterSet	*toneNumbers = [NSCharacterSet characterSetWithCharactersInString:@"12345"];

	scanner			= [NSScanner scannerWithString:oldPinyin];
	newPinyin		= [[NSMutableString alloc] init];
	tonelessPinyin	= [[NSMutableString alloc] init];
	*tonelessToReturn = tonelessPinyin;

	while ([scanner isAtEnd] == NO) {
		// Scanner will return YES and put the entire syllable into syllable even if it
		// does not end in a number we specified, so check that the character is actually
		// a number
		if ([scanner scanUpToCharactersFromSet:toneNumbers intoString:&syllable] == NO)
			break;
		if ([scanner isAtEnd])
			break;
		int toneNumber = 
		[[[scanner string] substringWithRange:NSMakeRange([scanner scanLocation], 1)] intValue];
		
		NSString *result = [Pinyin pinyinFromSyllable:syllable andToneNumber:toneNumber];
		
		if (result == nil) {
			NSLog(@"Error in pinyinWithToneMarksFromPinyinWithToneNumbers with syllable: %@", syllable);
			return nil;
		}
		
		// Pinyin Apostrophe Rule
		if ([newPinyin length] != 0 && 
			([syllable hasPrefix:@"a"] == YES || 
			 [syllable hasPrefix:@"o"] == YES ||
			 [syllable hasPrefix:@"e"] == YES) ) {
			[newPinyin appendString:@"'"];
		}
		
		[newPinyin appendString:result];
		[tonelessPinyin appendString:syllable];
		
		[scanner setScanLocation:[scanner scanLocation]+1];
	}
	return newPinyin;
}

+ (NSString *)pinyinFromSyllable:(NSString *)aSyllable andToneNumber:(int)toneNumber {
	/* Replace all occurrences of "u:" and "v" with "ü" */
	NSMutableString *syllable = [NSMutableString stringWithString:[aSyllable lowercaseString]];
	[syllable replaceOccurrencesOfString:@"v" withString:@"ü" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [syllable length])];
	[syllable replaceOccurrencesOfString:@"u:" withString:@"ü" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [syllable length])];

	/* Now make sure that it's a proper Mandarin syllable using the allSyllables array */
	if ([allSyllables containsObject:[syllable lowercaseString]] == NO) /* Convert the string to lowercase because the allSyllables array has all strings in lowercase */
		return nil;
	
	/* This is the string we will add the tone marks to and subsequently return */
	NSMutableString *toReturn = [NSMutableString stringWithString:syllable];

	/* Create a mapping of vowels to strings containing all forms of those vowels (with each tone) */
	NSDictionary *toneMarks = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:aTones, oTones, eTones, iTones, uTones, vTones, nil] 
														  forKeys:[NSArray arrayWithObjects:@"a", @"o", @"e", @"i", @"u", @"ü", nil]];
	
	/* Get the initial for the syllable */
	NSString *theInitial = nil;
	for (NSString *anInitial in initials) {
		if ([[syllable lowercaseString] hasPrefix:anInitial] == YES) { /* Convert the string to lowercase because the initials array has everything in lowercase */
			theInitial = anInitial;
			break;
		}
	}

	/* Find out which character in the syllable gets the tone mark */
	int lengthOfInitial = (theInitial == nil) ? 0 : [theInitial length];
	int vowelPosition = ([syllablesWithToneMarkOnSecondVowel containsObject:syllable]) ? lengthOfInitial+1 : lengthOfInitial;
	NSString *vowel = [syllable substringWithRange:NSMakeRange(vowelPosition, 1)];
	NSString *toneCharacter = [[toneMarks objectForKey:vowel] substringWithRange:NSMakeRange(toneNumber-1, 1)];

	if (toneCharacter == nil) {
		NSLog(@"Error 于 Syllable: %@", syllable);
		NSLog(@"Error 于 Vowel: %@", vowel);
		return nil;
	}
	
	/* Everything is Go; do the replacement */
	[toReturn replaceCharactersInRange:NSMakeRange(vowelPosition, 1) withString:toneCharacter];
	
	return toReturn;
}
@end