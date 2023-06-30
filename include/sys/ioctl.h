#ifndef SYS_IOCTL_H
#define SYS_IOCTL_H

#include <sys/compiler.h>
#include <stdint.h>

__ZPROTO2(int,,console_ioctl,uint16_t,cmd,void *,arg)

#define IOCTL_GENCON_RAW_MODE	  1  /* Set raw terminal mode (int *) */
#define IOCTL_GENCON_CONSOLE_SIZE 2  /* Get console size (int *) = (d<<8|w)  */
#define IOCTL_GENCON_SET_FONT32   3  /* Set the address for the 32 column font (int *) */
#define IOCTL_GENCON_SET_FONT64   4  /* Set the address for the 64 column font (int *) */
#define IOCTL_GENCON_SET_UDGS     5  /* Set the address for the udgs (int *) */
#define IOCTL_GENCON_SET_MODE     6  /* Set the display mode (int *) */
#define IOCTL_GENCON_GET_CAPS	  7  /* Get capabilities (int *) */


// Capabilities for the gencon
#define CAP_GENCON_CUSTOM_FONT  1
#define CAP_GENCON_UDGS		2
#define CAP_GENCON_FG_COLOUR	4
#define CAP_GENCON_BG_COLOUR	8
#define CAP_GENCON_INVERSE	16
#define CAP_GENCON_BOLD		32
#define CAP_GENCON_UNDERLINE	64

#endif
