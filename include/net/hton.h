/*
 *      Small C+ TCP Implementation
 *
 *      hton.h
 *
 *      Routines for the conversiono between network and host types
 *
 *      djm 24/4/99
 *
 *	$Id: hton.h,v 1.5 2010-09-19 00:24:08 dom Exp $
 */


#ifndef __HTON_H__
#define __HTON_H__

/* Get the types */
#include <sys/compiler.h>
#include <sys/types.h>
#include <net/inet.h>


extern IPADDR_T __LIB__ __FASTCALL__ htonl(IPADDR_T);

extern TCPPORT_T __LIB__ __FASTCALL__ htons(TCPPORT_T);


#define ntohs(x) htons(x)
#define ntohl(x) htonl(x)
#define HTONS(x) htons(x)
#define HTONL(x) htonl(x)
#define NTOHS(x) htons(x)
#define NTOHL(x) htonl(x)


#endif /* HTON_H */
