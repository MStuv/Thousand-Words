//
//  TWPictureDataTransformer.m
//  Thousand Words
//
//  Created by Mark Stuver on 12/4/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "TWPictureDataTransformer.h"

@implementation TWPictureDataTransformer

// Set the class that the transformer value will be
+(Class)transformedValueClass
{
    return [NSDate class];
}

// Setting that we will allow transforming
+(BOOL)allowsReverseTransformation
{
    return YES;
}

// Converting UIImage to NSData
-(id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value);
}

// Converting NSData to UIImage
-(id)reverseTransformedValue:(id)value
{
    UIImage *image = [UIImage imageWithData:value];
    return image;
}

@end
