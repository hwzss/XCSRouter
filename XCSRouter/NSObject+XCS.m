//
//  NSObject+XCS.m
//  XCSRouter
//
//  Created by kaifa on 2020/6/23.
//  Copyright © 2020 MC_MaoDou. All rights reserved.
//

#import "NSObject+XCS.h"
#import <objc/runtime.h>


@implementation NSObject (XCS)

- (void)xcsSetValue:(id)value forKey:(NSString *)key {
    // todo: key 获取方法 set 方法
    
    
    // todo: 获取参数类型
    
    // todo: 按照类型赋值
    
    // todo： 通过方法地址赋值
}


#pragma mark - methods from GUNStep
static void
CanSetValueForKey(NSObject *self, id anObject, const char *key)
{
    
    unsigned size = strlen(key);
    SEL        sel = 0;
    const char    *type = 0;
    int        off = 0;
    
    if (size > 0)
    {
        const char    *name;
        char        buf[size + 6];
        char        lo;
        char        hi;
        
        strncpy(buf, "_set", 4);
        strncpy(&buf[4], key, size);
        lo = buf[4];
        hi = islower(lo) ? toupper(lo) : lo;
        buf[4] = hi;
        buf[size + 4] = ':';
        buf[size + 5] = '\0';
        
        name = &buf[1];    // setKey:
        type = NULL;
        sel = sel_getUid(name);
        if (sel == 0 || [self respondsToSelector: sel] == NO)
        {
            name = buf;    // _setKey:
            sel = sel_getUid(name);
            if (sel == 0 || [self respondsToSelector: sel] == NO)
            {
                sel = 0;
                if ([[self class] accessInstanceVariablesDirectly] == YES)
                {
                    buf[size + 4] = '\0';
                    buf[3] = '_';
                    buf[4] = lo;
                    name = &buf[3];    // _key
                    if (GSObjCFindVariable(self, name, &type, &size, &off) == NO)
                    {
                        buf[4] = hi;
                        buf[3] = 's';
                        buf[2] = 'i';
                        buf[1] = '_';
                        name = &buf[1];    // _isKey
                        if (GSObjCFindVariable(self,
                                               name, &type, &size, &off) == NO)
                        {
                            buf[4] = lo;
                            name = &buf[4];    // key
                            if (GSObjCFindVariable(self,
                                                   name, &type, &size, &off) == NO)
                            {
                                buf[4] = hi;
                                buf[3] = 's';
                                buf[2] = 'i';
                                name = &buf[2];    // isKey
                                GSObjCFindVariable(self,
                                                   name, &type, &size, &off);
                            }
                        }
                    }
                }
            }
            else
            {
                //          GSOnceFLog(@"Key-value access using _setKey: is deprecated:");
            }
        }
    }
    
    //  GSObjCSetVal(self, key, anObject, sel, type, size, off);
}
/**
 * This function is used to locate information about the instance
 * variable of obj called name.  It returns YES if the variable
 * was found, NO otherwise.  If it returns YES, then the values
 * pointed to by type, size, and offset will be set (except where
 * they are null pointers).
 */
BOOL
GSObjCFindVariable(id obj, const char *name,
                   const char **type, unsigned int *size, int *offset)
{
    Class        class = object_getClass(obj);
    Ivar        ivar = class_getInstanceVariable(class, name);
    
    if (ivar == 0)
    {
        return NO;
    }
    else
    {
        const char    *enc = ivar_getTypeEncoding(ivar);
        
        if (type != 0)
        {
            *type = enc;
        }
        if (size != 0)
        {
            NSUInteger    s;
            NSUInteger    a;
            
            NSGetSizeAndAlignment(enc, &s, &a);
            *size = s;
        }
        if (offset != 0)
        {
            *offset = ivar_getOffset(ivar);
        }
        return YES;
    }
}


@end
