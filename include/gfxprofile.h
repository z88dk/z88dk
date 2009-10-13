/*
 *      Graphics Profiles
 *
 * Meta-language to pack graphics instructions.
 * A first byte holds the command in the first nibble,
 * and a 'dither level' parameter in the second half.
 * When necessary two or four bytes for coordinate follow.
 *
 *
 *	$Id: gfxprofile.h,v 1.1 2009-10-13 11:40:23 stefano Exp $
 */

#ifndef __GFXPF_H__
#define __GFXPF_H__

#define CMD_END 		0x00	/* no parms */
#define	CMD_PLOT		0x10	/* (dither),x,y */
#define	CMD_LINETO		0x20	/* (dither),x,y */
#define	CMD_LINE		0x30	/* (dither),x1,y1,x2,y2 */
#define CMD_AREA_INIT	0x40	/* no parms */
#define CMD_AREA_PLOT	0x50	/*   x,y */
#define CMD_AREA_LINETO	0x60	/*   x,y */
#define CMD_AREA_LINE	0x70	/*   x1,y1,x2,y2 */
#define CMD_AREA_CLOSE	0x80	/* (dither), Render and init */


#endif


