//
//  RNSelectContactPhone.m
//  RNSelectContactPhone
//
//  Created by Ross Haker on 10/22/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "RNSelectContactPhone.h"

@implementation RNSelectContactPhone

// Expose this module to the React Native bridge
RCT_EXPORT_MODULE()

// Persist data
RCT_EXPORT_METHOD(selectPhone:(BOOL *)boolType
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    
    // save the resolve promise
    self.resolve = resolve;
    
    // set up an error message
    NSError *error = [
                      NSError errorWithDomain:@"some_domain"
                      code:100
                      userInfo:@{
                                 NSLocalizedDescriptionKey:@"ios8 or higher required"
                                 }];
    
    
    // detect the ios version
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
    // check that ios is version 8.0 or higher
    if (ver_float < 8.0) {
        
        reject(error);
        
    } else {
        
        ABPeoplePickerNavigationController *picker;
        picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        
        UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [vc presentViewController:picker animated:YES completion:nil];
        
    }
    
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    
    // set the fields from the adddress book
    NSString *phoneNumber = nil;
    
    // get the phone
    if (ABRecordCopyValue(person, kABPersonPhoneProperty)) {
        ABMultiValueRef phone = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFStringRef phoneID = ABMultiValueCopyValueAtIndex(phone, 0);
        phoneNumber = (__bridge_transfer NSString *)phoneID;
    }
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
    
    // resolve the phone number
    self.resolve(phoneNumber);
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end
