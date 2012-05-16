/*
 *      Small C+ Library
 *
 *  pc.h - old apps compatibility
 * 
 *	This helps expecially with the kbhit() instruction
 *	it exists on many old compilers
 *
 *	$Id: pc.h,v 1.1 2012-05-16 16:59:56 stefano Exp $
 */

#ifndef __PC_H__
#define __PC_H__

#ifndef kbhit
#define kbhit() (getk() ? 1 : 0)
#endif

#endif
