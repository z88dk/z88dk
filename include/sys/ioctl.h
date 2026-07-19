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
#define IOCTL_GENCON_SET_FONT_H   8  /* Set the font height in gfx modes (int *) */
#define IOCTL_GENCON_CURSOR_XY    9  /* Position + show hw cursor (int *) = (row<<8|col) */
#define IOCTL_GENCON_CURSOR_ON   10  /* Show hw cursor at current console position */
#define IOCTL_GENCON_CURSOR_OFF  11  /* Hide the hw cursor */
#define IOCTL_GENCON_CRT_RESET   12  /* Reprogram CRTC (unsigned char par[N]) */

/* RC700 Intel 8275 CRTC reset parameters (arg = unsigned char par[4]).
 * par[0] S HHHHHHH : spaced-rows + chars/row-1        (RC700 default 0x4F = 80 cols)
 * par[1] VV RRRRRR : VRTC row-count + rows/frame-1    (RC700 default 0x98 = 25 rows)
 * par[2] UUUU LLLL : underline line + lines/char-1    (RC700 default 0x7A)
 * par[3] M F CC ZZZZ: line-mode, field-attr, CURSOR FORMAT (bits5:4), HRTC
 *                     (RC700 default 0x6D = steady reverse block)
 * The driver re-enables the display after reset, so the screen stays live. */
#define RC700_CRT_PAR0           0x4F  /* 80 chars/row */
#define RC700_CRT_PAR1           0x98  /* 25 rows/frame */
#define RC700_CRT_PAR2           0x7A  /* underline + lines/char */
#define RC700_CRT_PAR3_BASE      0x4D  /* par[3] with cursor-format bits cleared */

/* 8275 cursor format = par[3] bits 5:4.  par3 = RC700_CRT_PAR3_BASE | (fmt << 4) */
#define CURSOR_FMT_BLINK_BLOCK       0  /* blinking reverse-video block */
#define CURSOR_FMT_BLINK_UNDERLINE   1  /* blinking underline */
#define CURSOR_FMT_STEADY_BLOCK      2  /* steady reverse-video block (RC700 default) */
#define CURSOR_FMT_STEADY_UNDERLINE  3  /* steady underline */


// Capabilities for the gencon
#define CAP_GENCON_CUSTOM_FONT  1
#define CAP_GENCON_UDGS		2
#define CAP_GENCON_FG_COLOUR	4
#define CAP_GENCON_BG_COLOUR	8
#define CAP_GENCON_INVERSE	16
#define CAP_GENCON_BOLD		32
#define CAP_GENCON_UNDERLINE	64

#endif
