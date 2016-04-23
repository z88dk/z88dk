/*
 *	Defs for a ZSock device driver
 *
 *	djm 25/1/2000
 *
 *	$Id: device.h,v 1.9 2016-04-23 08:00:38 dom Exp $
 */

#ifndef __NET_DEVICE_H__
#define __NET_DEVICE_H__

#include <sys/compiler.h>


/* Address to which a plugin device is loaded */

#define DRIVER_ADDR 8192

/* Structure for the pkt drivers */

#ifdef SCCZ80
struct pktdrive {
        char    magic[10];	/* ZS0PKTDRV\0 */
        char    *type;		/* SLIP/PPP etc */
        char    *copymsg;	/* (C) string */
        int     (*initfunc)();	/* Initialise function */
        int     (*queuefn)();	/* Insert packet into queue */
        int     (*sendfn)();	/* Spew bytes out */
        int     (*readfn)();	/* Read packet from dev */
	void	(*onlinefn)();  /* Turn device online */
	void	(*offlinefn)();	/* Turn device offline (supply 1 for hangup, 0 for not hangup */
	int     (*statusfn)();
};
#else
struct pktdrive {
        char    magic[10];	/* ZS0PKTDRV\0 */
        char    *type;		/* SLIP/PPP etc */
        char    *copymsg;	/* (C) string */
        int     (*initfunc)();	/* Initialise function */
        void    (*queuefn)(void *pkt,u16_t len);	/* Insert packet into queue */
        void   *(*sendfn)();	/* Spew bytes out */
        int     (*readfn)(void **pkt);	/* Read packet from dev */
	void	(*onlinefn)();  /* Turn device online */
	void	(*offlinefn)(int);	/* Turn device offline (supply 1 for hangup, 0 for not hangup */
	int	(*statusfn)();
};
#endif


#ifndef _KERNEL
/*
 *	Routines for use by any packet drivers or apps
 *	if they really feel the need..
 */

/* Set the host IP address, returns it as well..network order! */

extern ipaddr_t __LIB__ __SHARED__ SetHostAddr(ipaddr_t ip);

/*
 * Set the name servers - supply both, if ns1 == 0 then no DNS 
 * returns number of nameservers
 */

extern size_t __LIB__ __SHARED__ SetNameServers(ipaddr_t ns1, ipaddr_t ns2);

#endif /* _KERNEL */

#endif /* _NET_DEVICE_H */

