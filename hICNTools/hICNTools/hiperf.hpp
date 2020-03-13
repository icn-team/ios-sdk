//
//  hiperf.hpp
//  hICNTools
//
//  Created by manangel on 3/13/20.
//  Copyright © 2020 manangel. All rights reserved.
//

#ifndef hiperf_hpp
#define hiperf_hpp


int execute = 1;
#ifdef __cplusplus
extern "C" {
#endif
void startHiperf(const char *hicn_name,
            float beta_parameter,
            float drop_factor_parameter,
            int window_size,
            long stats_interval,
            long rtc_protocol,
            long interest_lifetime);

int stopHiperf();

float getValue();

#ifdef __cplusplus
}
#endif


#endif /* hiperf_hpp */
