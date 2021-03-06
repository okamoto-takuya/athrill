#ifndef _KERNEL_SERVICE_H_
#define _KERNEL_SERVICE_H_

#include "types.h"

#ifdef SERVICE_CALL_USER
/* 
 * SERVICE_CALL_USER
 */

extern ServiceReturnType svc_call_get_data(SrvUint32 inx, SrvUint32 *ret_data);
extern ServiceReturnType svc_call_set_data(SrvUint32 inx, SrvUint32 data);
extern void svc_call_printf(const char* p);

#define svc_get_data(inx, ret_data)     svc_call_get_data(inx, ret_data)
#define svc_set_data(inx, data)         svc_call_set_data(inx, data)
#define svc_printf(p)                   svc_call_printf(p)

#else

/* 
 * SERVICE_CALL_KERNEL
 */
extern ServiceReturnType kernel_get_data(SrvUint32 inx, SrvUint32 *ret_data);
extern ServiceReturnType kernel_set_data(SrvUint32 inx, SrvUint32 data);
extern void kernel_printf(const char* p);

#define svc_get_data(inx, ret_data)     kernel_get_data(inx, ret_data)
#define svc_set_data(inx, data)         kernel_set_data(inx, data)
#define svc_printf(p)                   kernel_printf(p)
#endif /* SERVICE_CALL_USER */

#endif /* _KERNEL_SERVICE_H_ */