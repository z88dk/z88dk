/*
 *      Small C+ Library
 *
 *      TRDOS/Beta low level support
 *
 *      Stefano Bodrato - 31/01/2008
 *
 *	$Id: zxbeta.h,v 1.2 2010-09-19 00:24:08 dom Exp $
 */


#ifndef __ZXBETA_H__
#define __ZXBETA_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <fcntl.h>


#ifndef __ZX_CHANNELS__
#define	__ZX_CHANNELS__

struct BASE_CHAN {
	// base channel descriptor
	u16_t	out;		/* pointer to the output routine     */
	u16_t	in;		/* pointer to the input routine      */
	u8_t	id_char;	/* upper (if permanent) or lower "M".. char  */
	u16_t	len;		/* length of channel                 */
};


#endif /*__ZX_CHANNELS__*/


// Returns true if the Beta disk interface is present
extern int __LIB__ zx_betadisk();

// Returns true if the TRDOS is active
extern int __LIB__ trdos_installed();



#endif /* _ZXBETA_H */
