/*
 *      Small C+ TCP Implementation
 *
 *      hton.h
 *
 *      Routines for the conversiono between network and host types
 *
 *      djm 24/4/99
 *
 *	$Id: hton.h,v 1.2 2001-04-20 16:04:25 dom Exp $
 */


#ifndef HTON_H
#define HTON_H

/* Get the types */

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
