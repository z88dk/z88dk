#ifndef SYS_IOCTL_H
#define SYS_IOCTL_H

#include <sys/types.h>

extern int __LIB__ fputc_cons_generic_ioctl(uint16_t cmd, void *arg) __smallc;

#define IOCTL_GENCON_RAW_MODE	  1  /* Set raw terminal mode (int *) */
#define IOCTL_GENCON_CONSOLE_SIZE 2  /* Get console size (int *) = (d<<8|w)  */
#define IOCTL_GENCON_SET_FONT32   3  /* Set the address for the 32 column font (int *) */
#define IOCTL_GENCON_SET_FONT64   4  /* Set the address for the 64 column font (int *) */
#define IOCTL_GENCON_SET_UDGS     4  /* Set the address for the 64 column udgs (int *) */

#endif
