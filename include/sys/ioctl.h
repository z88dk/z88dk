#ifndef SYS_IOCTL_H
#define SYS_IOCTL_H

#include <sys/types.h>

extern int __LIB__ fputc_cons_generic_ioctl(uint16_t cmd, void *arg) __smallc;

#define IOCTL_GENCON_RAW_MODE	  1  /* Set raw terminal mode (int *) */
#define IOCTL_GENCON_CONSOLE_SIZE 2  /* Get console size (int *) = (d<<8|w)  */


#endif
