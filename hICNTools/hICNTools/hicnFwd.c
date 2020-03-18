//
//  metis_wrapper.c
//  Metis4iOs
//
//  Created by Angelo Mantellini on 07/04/2017.
//  Copyright © 2017 Angelo Mantellini. All rights reserved.
//

#include "hicnFwd.h"
#include <unistd.h>
#include <parc/security/parc_Security.h>
#include <parc/security/parc_IdentityFile.h>

#include <parc/algol/parc_Memory.h>
#include <parc/algol/parc_SafeMemory.h>
#include <parc/algol/parc_List.h>
#include <parc/algol/parc_ArrayList.h>
#include <hicn/core/dispatcher.h>
#include <parc/algol/parc_FileOutputStream.h>
#include <parc/logging/parc_LogLevel.h>
#include <parc/logging/parc_LogReporterFile.h>
#include <parc/logging/parc_LogReporterTextStdout.h>
#include <hicn/core/forwarder.h>
static bool _isRunning = false;
static Forwarder *hicnFwd = NULL;
static Logger *logger = NULL;

void startHicnFwd(const char *path, size_t pathSize) {
    char *pathTemp = (char *)malloc(sizeof(char) * (1 + pathSize - 7));
    strcpy(pathTemp, path + 7);
    printf("%s\n", pathTemp);
    if (!_isRunning) {
        
        logger = NULL;
        int logLevelArray[LoggerFacility_END];
        for (int i = 0; i < LoggerFacility_END; i++) {
            logLevelArray[i] = -1;
        }
        PARCLogReporter *stdoutReporter = parcLogReporterTextStdout_Create();
        logger = logger_Create(stdoutReporter, parcClock_Wallclock());
        parcLogReporter_Release(&stdoutReporter);
        for (int i = 0; i < LoggerFacility_END; i++) {
            if (logLevelArray[i] > -1) {
                logger_SetLogLevel(logger, i, logLevelArray[i]);
            }
        }

        hicnFwd = forwarder_Create(logger);
        Configuration *hicnFwdConfiguration = forwarder_GetConfiguration(hicnFwd);
        configuration_SetObjectStoreSize(hicnFwdConfiguration, 0);
        if (pathTemp != NULL && strlen(pathTemp) >0) {
            forwarder_SetupFromConfigFile(hicnFwd, pathTemp);
        } else {
            forwarder_SetupAllListeners(hicnFwd, PORT_NUMBER, NULL);
        }
        _isRunning = true;
        dispatcher_Run(forwarder_GetDispatcher(hicnFwd));
    }
    free(pathTemp);
}

void stopHicnFwd() {
    if(_isRunning) {
        dispatcher_Stop(forwarder_GetDispatcher(hicnFwd));
        
        sleep(1);
        forwarder_Destroy(&hicnFwd);
        sleep(2);
        logger_Release(&logger);
        _isRunning = false;
    }
}

int isRunning() {
    return _isRunning;
}


