//
//  JMAnimatedLog.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 10/09/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#ifndef JMAnimatedImageView_JMAnimatedLog_h
#define JMAnimatedImageView_JMAnimatedLog_h

// Log using the same parameters above but include the function name and source code line number in the log statement
#ifdef DEBUG
#define JMLog(fmt, ...) NSLog((@"Func: %s, Line: %d, " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define JMLog(...)
#endif

#endif
