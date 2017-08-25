include(__link__.m4)

#ifndef __SYS_IOCTL_H__
#define __SYS_IOCTL_H__

// ioctls are defined in arch.h

#include <arch.h>
#include <stdint.h>

__VPROTO(,,int,,ioctl,int fd,uint16_t request,...)
__DPROTO(,,int,,vioctl,int fd,uint16_t request,void *arg)

#endif
