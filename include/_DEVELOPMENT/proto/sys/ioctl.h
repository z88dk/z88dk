include(__link__.m4)

#ifndef _SYS_IOCTL_H
#define _SYS_IOCTL_H

// ioctls are defined in arch.h

#include <arch.h>
#include <stdint.h>

__VPROTO(,,int,,ioctl,int fd,uint16_t request,...)
__DPROTO(,,int,,vioctl,int fd,uint16_t request,void *arg)

#endif
