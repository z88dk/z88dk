/*
 *      Graphics Profiles
 *
 * Meta-language to pack graphics instructions.
 * A first byte holds the command in the first nibble,
 * and a 'dither level' parameter in the second half.
 * When necessary two or four bytes for coordinate follow.
 *
 *
 *	$Id: gfxprofile.h,v 1.3 2009-11-13 11:09:09 stefano Exp $
 */

#ifndef __GFXPF_H__
#define __GFXPF_H__

#define CMD_END  		0x00	/* no parms */

#define	CMD_PLOT 		0x10	/* (dither),x,y */
#define	CMD_LINETO		0x20	/* (dither),x,y */
#define	CMD_LINE 		0x30	/* (dither),x1,y1,x2,y2 */

#define CMD_AREA_INIT	0x80	/* no parms */
#define CMD_AREA_INITB	0x81	/* activate border mode */

#define CMD_AREA_PLOT	0x90	/*   x,y */
#define CMD_AREA_LINETO	0xA0	/*   x,y */
#define CMD_AREA_LINE	0xB0	/*   x1,y1,x2,y2 */

#define CMD_AREA_CLOSE	0xF0	/* (dither), Render and init */

#define DITHER_WHITE 	0
#define DITHER_GRAY  	6
#define DITHER_BLACK 	11

#define DITHER_BOLD  	15
#define DITHER_BOLD_8 	12
#define DITHER_BOLD_9 	13
#define DITHER_BOLD_10 	14
#define DITHER_BOLD_11	15

#define AREA_BRD_4	12
#define AREA_BRD_5	13
#define AREA_BRD_6	14
#define AREA_BRD_7	15


#endif


