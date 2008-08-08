//
//  Pinyinize_AppDelegate.m
//  Pinyinize
//
//  Created by Karan Misra on 08-7-8.
//

#import "Pinyinizer_AppDelegate.h"

#import "DictionaryEntry.h"

@implementation Pinyinize_AppDelegate

- (NSString *)convertPunctuation:(NSString *)original {
	NSMutableString *result = [NSMutableString stringWithString:original];
	[result replaceOccurrencesOfString:@"。" withString:@". " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"，" withString:@", " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"：" withString:@": " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"－" withString:@" – " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"——" withString:@" –– " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"—" withString:@" – " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"……" withString:@"…… " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"…" withString:@"… " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"“" withString:@" \"" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"”" withString:@"\" " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"《" withString:@" \"" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"》" withString:@"\" " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"〈" withString:@" \"" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"〉" withString:@"\" " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"『" withString:@" \"" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"』" withString:@"\" " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"【" withString:@" \"" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"】" withString:@"\" " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"（" withString:@" (" options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"）" withString:@") " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	[result replaceOccurrencesOfString:@"、" withString:@", " options:NSLiteralSearch range:NSMakeRange(0, [result length])];
	return result;
}

- (IBAction)convertToPinyin:(id)sender {
	NSString *hanzi = [self convertPunctuation:[hanziTextView string]];

//	NSLog(@"To Convert: %@", hanzi);
	
	unsigned start = 0; // start of selection
	unsigned end = 0;	// end of selection
	
	unsigned length = [hanzi length];
	
	NSMutableDictionary *pinyin = [[[NSMutableDictionary alloc] init] autorelease];
	
	NSManagedObjectContext *context = [self managedObjectContext];
	NSArray *persistentStores = [[self persistentStoreCoordinator] persistentStores];

	NSEntityDescription *entryEntity = nil;
	NSFetchRequest *entryRequest = nil;
	NSString *selection = nil;
	NSError *error = nil;
	NSDictionary *tempDict = nil;

	NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:@"simplified = $SEARCHSTRING", selection];

	entryEntity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:context];
	
	while (start < length && end < length) {
		NSAssert(start <= end, @"start !<= end");
		
		selection = [hanzi substringWithRange:NSMakeRange(start, end - start + 1)];		

//		NSLog(@"Searching for: \"%@\"", selection);

		entryRequest = [[NSFetchRequest alloc] init];
		[entryRequest setEntity:entryEntity];
		tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:selection, @"SEARCHSTRING", nil];
		[entryRequest setPredicate:[predicateTemplate predicateWithSubstitutionVariables:tempDict]];
		[tempDict release];
		[entryRequest setFetchLimit:1];
		[entryRequest setIncludesSubentities:NO];
		[entryRequest setAffectedStores:persistentStores];
		NSArray *fetchedArray = [context executeFetchRequest:entryRequest error:&error];
		if (error != nil)
			[[NSApplication sharedApplication] presentError:error];
		[entryRequest release];
		
		NSString *fetchedPinyin = nil;
		
		NSString *tempStr = nil;
		NSNumber *tempKey = [[NSNumber alloc] initWithInt:start];
		
		if (fetchedArray != nil) {
			if ([fetchedArray count] > 0) {
				fetchedPinyin = [[fetchedArray objectAtIndex:0] valueForKey:@"pinyin"];
//				NSLog(@"Fetched Entries(0): %@", fetchedPinyin);
				tempStr = [[NSString alloc] initWithFormat:@" %@", fetchedPinyin];
				[pinyin setObject:tempStr forKey:tempKey];
				[tempStr release];
				++end;
			} else {
				if ([selection length] == 1) { // unknown character case
					[pinyin setObject:selection forKey:tempKey];
					++end;
				}
				start = end;
			}
		}
		
		[tempKey release];
	}
	
	NSMutableString *pinyinString = [[[NSMutableString alloc] init] autorelease];
	NSString *tempWord;
	NSNumber *tempKey;
	unsigned i;
	for (i = 0; i < length; i++) {
		tempKey = [[NSNumber alloc] initWithInt:i];
		tempWord = [pinyin objectForKey:tempKey];
		[tempKey release];
		if (tempWord != nil)
			[pinyinString appendString:tempWord];
	}

	if ([pinyinString characterAtIndex:0] == ' ') // Remove Leading Space
		[pinyinString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];

	if ([pinyinString length] > 0) // Capitalize First Letter (incomplete solution)
		[pinyinString replaceCharactersInRange:NSMakeRange(0, 1) withString:[[pinyinString substringToIndex:1] uppercaseString]];
	
	[pinyinTextView setString:pinyinString];
}

- (void)awakeFromNib {
	/* Text View Alignment */
	[hanziTextView setAlignment:NSLeftTextAlignment];
	[pinyinTextView setAlignment:NSLeftTextAlignment];
	
	/* Import Lexicon from Data File if this is the First Run */
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PinyinizeFirstRun"] == NO) {
		NSBundle *appBundle = [NSBundle mainBundle];
		NSString *dictionaryText = [NSString stringWithContentsOfFile:[appBundle pathForResource:@"cedict_ts" ofType:@"u8"] 
															 encoding:NSUTF8StringEncoding 
																error:nil];
		NSArray *lines = [dictionaryText componentsSeparatedByString:@"\n"];
		
		NSError *error = nil;
		
		// Context for Importing
		NSManagedObjectContext *importContext = [[NSManagedObjectContext alloc] init];
		NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
		[importContext setPersistentStoreCoordinator:coordinator];
		[importContext setUndoManager:nil];
		
		// Get the EntityDescription
		NSDictionary *entities = [[self managedObjectModel] entitiesByName];
		NSEntityDescription *entryEntity = [entities valueForKey:@"Entry"];
				
		unsigned loopLimit = 1000;
		unsigned i;
		unsigned linesCount = [lines count];
		NSString *curLine;
		NSManagedObject *curObject;		
		
		// Pool for Loop for Efficient Importing
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

		for (i = 1; i < linesCount; i++) {
			curLine = [lines objectAtIndex:i];
			DictionaryEntry *dictEntry = [[DictionaryEntry alloc] initWithCEDICTEntry:curLine];
			NSString *pinyin = [dictEntry pinyinWithToneMarks];
			if (pinyin != nil) {
				curObject = [[NSManagedObject alloc] initWithEntity:entryEntity insertIntoManagedObjectContext:importContext];
				[curObject setValue:[dictEntry pinyinWithToneMarks] forKey:@"pinyin"];
				[curObject setValue:[dictEntry simplified] forKey:@"simplified"];
				[curObject setValue:[dictEntry traditional] forKey:@"traditional"];
			}
			[dictEntry release];
			
			if ((i % loopLimit == 0) || (i == linesCount - 1)) {
				[importContext save:&error];
				if (error != nil) {
					[[NSApplication sharedApplication] presentError:error];
					error = nil;
				}
				[importContext reset];
				[pool drain], pool = [[NSAutoreleasePool alloc] init];
			}
			
		}
		
		[pool drain];
		[pool release];
		
		[importContext reset];
		
		NSFetchRequest *allEntriesRequest = [[[NSFetchRequest alloc] init] autorelease];
		[allEntriesRequest setEntity:entryEntity];
		NSArray *fetchedArray = [importContext executeFetchRequest:allEntriesRequest error:&error];
		if (error != nil) {
			[[NSApplication sharedApplication] presentError:error];
			error = nil;
		}
		if (fetchedArray != nil) {
			NSLog(@"Fetched Entries: %d", [fetchedArray count]);
			[importContext save:&error];
			if (error != nil) {
				[[NSApplication sharedApplication] presentError:error];
				error = nil;
			}
		}
		
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PinyinizeFirstRun"];
	}
}

/**
    Returns the support folder for the application, used to store the Core Data
    store file.  This code uses a folder named "Pinyinize" for
    the content, either in the NSApplicationSupportDirectory location or (if the
    former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportFolder {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"Pinyinize"];
}


/**
    Creates, retains, and returns the managed object model for the application 
    by merging all of the models found in the application bundle.
 */
 
- (NSManagedObjectModel *)managedObjectModel {

    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
    Returns the persistent store coordinator for the application.  This 
    implementation will create and return a coordinator, having added the 
    store for the application to it.  (The folder for the store is created, 
    if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {

    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }

    NSFileManager *fileManager;
    NSString *applicationSupportFolder = nil;
    NSURL *url;
    NSError *error;
    
    fileManager = [NSFileManager defaultManager];
    applicationSupportFolder = [self applicationSupportFolder];
    if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
        [fileManager createDirectoryAtPath:applicationSupportFolder attributes:nil];
    }
    
    url = [NSURL fileURLWithPath: [applicationSupportFolder stringByAppendingPathComponent: @"Pinyinize.sqlite"]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]){
        [[NSApplication sharedApplication] presentError:error];
    }    

    return persistentStoreCoordinator;
}


/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
 
- (NSManagedObjectContext *) managedObjectContext {

    if (managedObjectContext != nil) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}


/**
    Returns the NSUndoManager for the application.  In this case, the manager
    returned is that of the managed object context for the application.
 */
 
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}


/**
    Performs the save action for the application, which is to send the save:
    message to the application's managed object context.  Any encountered errors
    are presented to the user.
 */
 
- (IBAction) saveAction:(id)sender {

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}


/**
    Implementation of the applicationShouldTerminate: method, used here to
    handle the saving of changes in the application managed object context
    before the application terminates.
 */
 
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    NSError *error;
    int reply = NSTerminateNow;
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext commitEditing]) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
				
                // This error handling simply presents error information in a panel with an 
                // "Ok" button, which does not include any attempt at error recovery (meaning, 
                // attempting to fix the error.)  As a result, this implementation will 
                // present the information to the user and then follow up with a panel asking 
                // if the user wishes to "Quit Anyway", without saving the changes.

                // Typically, this process should be altered to include application-specific 
                // recovery steps.  

                BOOL errorResult = [[NSApplication sharedApplication] presentError:error];
				
                if (errorResult == YES) {
                    reply = NSTerminateCancel;
                } 

                else {
					
                    int alertReturn = NSRunAlertPanel(nil, @"Could not save changes while quitting. Quit anyway?" , @"Quit anyway", @"Cancel", nil);
                    if (alertReturn == NSAlertAlternateReturn) {
                        reply = NSTerminateCancel;	
                    }
                }
            }
        } 
        
        else {
            reply = NSTerminateCancel;
        }
    }
    
    return reply;
}


/**
    Implementation of dealloc, to release the retained variables.
 */
 
- (void) dealloc {

    [managedObjectContext release], managedObjectContext = nil;
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    [managedObjectModel release], managedObjectModel = nil;
    [super dealloc];
}


@end
