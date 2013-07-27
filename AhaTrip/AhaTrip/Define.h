//
//  Define.h
//  JiaDe
//
//  Created by tagux-mac-04 on 13-1-25.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#ifndef JiaDe_Define_h
#define JiaDe_Define_h

#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
//本地语言key
#define USERDEFAULT     [NSUserDefaults standardUserDefaults]
#define INTERNATIONAL_KEY   @"CustomLanguage"
#define ENGLISH_STRING_FILE @"English"
#define CHINISE_STRING_FILE @"Chinese"
#define VALUE               [USERDEFAULT objectForKey: INTERNATIONAL_KEY]
#define LOCALIZEDSTRING(key) (NSLocalizedStringFromTable((key), VALUE == nil ? CHINISE_STRING_FILE : VALUE, nil))



#endif
