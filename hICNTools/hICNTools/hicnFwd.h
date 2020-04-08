//
//  hicnFwd.h
//  hICNTools
//
//  Created by manangel on 3/17/20.
//  Copyright © 2020 manangel. All rights reserved.
//

#ifndef hicnFwd_h
#define hicnFwd_h


#include <stdio.h>
int isRunning(void);
void stopHicnFwd(void);
void startHicnFwd(const char *path, size_t pathSize);

#endif /* hicnFwd_h */
