#ifndef __NET_ZSOCKERRS_H__
#define __NET_ZSOCKERRS_H__

/*
 *	This file lists the errors returned by ZSock to an
 *	application. They overlap with OZ errors (*have* to)
 *
 *	UNIX errnos in brackets in comment
 *
 *	djm 7/1/2000
 *
 *	Still not sure how to tie these in....
 *
 *	$Id: zsockerrs.h,v 1.3 2001-10-16 18:30:32 dom Exp $
 */

#define EOK		0	/* Hey we're fine! RC_OK */

#define ENETDOWN	6	/* (50) Network down RC_Na */
#define EMSGSIZE	7	/* (41) Message too long (UDP) */
#define ENOMEM		0x0A	/* (12) Out of memory */
#define EPROTONOSUPPORT 0x46	/* (46) Protocol family not supp */
#define EADDRINUSE	0x47	/* (48) Address already in use */
#define ETIMEDOUT	2	/* (60) Conn timed out */
#define ECONNREFUSED	0x66	/* (61) Conn refused */
#define EDESTADDRREQ	0x0C	/* (39) Dest addr needed */
#define ESHUTDOWN	0x0B	/* (58) Can't send after shutdown */

#endif /* !_NET_ZSOCKERRS_H */
