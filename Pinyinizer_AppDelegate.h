//
//  Pinyinize_AppDelegate.h
//  Pinyinize
//
//  Created by Karan Misra on 08-7-8.
//

#import <Cocoa/Cocoa.h>

@interface Pinyinize_AppDelegate : NSObject 
{
    IBOutlet NSWindow *window;
	IBOutlet NSTextView *hanziTextView;
	IBOutlet NSTextView *pinyinTextView;
	
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)saveAction:sender;
- (IBAction)convertToPinyin:(id)sender;

@end
