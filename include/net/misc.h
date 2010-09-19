/*
 *	API For Zsock
 *
 *	Miscellaenous routines which don't fit in
 *	anywhere
 *
 *	djm 13/2/2000
 *
 *	$Id: misc.h,v 1.6 2010-09-19 00:24:08 dom Exp $
 */

#ifndef __NET_MISC_H__
#define __NET_MISC_H__

#include <sys/compiler.h>
#include <net/inet.h>

/*
 * Convert dotted string to network address 
 * CAUTION: RETURNS 0 ON FAILURE!!!
 */

extern ipaddr_t __LIB__ __SHARED__ inet_addr(char *cp);

/* Convert network address to dotted string, returns where the string is */
/* First one assumes base 10 and full complement of digits */
extern char __LIB__ __SHARED__ *inet_ntoa(IPADDR_T in, char *b);

/* full version, may not make it into the final cut! */
extern char __LIB__ __SHARED__ *inet_ntoa_full(IPADDR_T in, char *b);


/*
 * Check and set user timeouts 
 */

extern long __LIB__ __SHARED__ tcp_settimeout(int secs);
extern long __LIB__ __SHARED__ tcp_setctimeout(int centisecs);
extern int __LIB__ __SHARED__ tcp_chktimeout(long time);

/*
 * Page in and out Zsock data bank to segment two
 *
 * pagein returns old binding which pageout needs
 */

extern u8_t __LIB__ __SHARED__ tcp_pagein(void);
extern u8_t __LIB__ __SHARED__ tcp_pageout(u8_t);

/*
 * Allocate memory from the ZSock heap..useful for daemons
 * Since they probably won't have their own memory...use
 * sparingly since we've only got 16k...
 */

extern void __LIB__ __SHARED__ *tcp_malloc(int);
extern void __LIB__ __SHARED__ *tcp_calloc(int,int);
extern void __LIB__ __SHARED__ tcp_free(void *);


/*
 *	Turn the device on/offline
 *	If flag !=0 then hangup line (offline)
 */

#define HANGUP 1
#define NOHANGUP 0

extern void __LIB__ __SHARED__ DeviceOffline(int flag);
extern void __LIB__ __SHARED__ DeviceOnline();



/*
 *	Routines for use by any packet drivers or apps
 *	if they really feel the need..
 */

/* Get the host IP address in network order */
extern ipaddr_t __LIB__ __SHARED__ GetHostAddr(void);

/* Get the current domainname into buf, buf must be MAXDOMSIZ (50) */

extern u8_t __LIB__ __SHARED__ *GetDomain(u8_t *buf);

/*
 * Return the network information structure - copy it into a
 * user supplied buffer for them to mess with - don't let 'em
 * near ours!!! User supplies buf with size size, we copy as
 * much as possible, if size=0 then we have it all
 */

extern size_t __LIB__ __SHARED__ GetNetStat(u8_t *buf, size_t size);

/*
 * Register a CatchAll handler
 */

extern int __LIB__ __SHARED__ tcp_RegCatchall(int);

/*
 * Hopefully Dev only busy call
 */

extern void __LIB__ __SHARED__ GoTCP(void);

/*
 * Kill daemon sockets on port for a particular protocol
 */

extern int __LIB__ __SHARED__ killdaemon(tcpport_t port, char protocol);

#endif /* !_NET_MISC_H */

