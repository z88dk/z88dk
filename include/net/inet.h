/*
 *      Small C+ TCP Implementation
 *
 *      inet.h
 *
 *      Defines all constants
 *
 *      djm 24/4/99
 */


#ifndef _NET_INET_H
#define _NET_INET_H

#include <sys/types.h>

typedef unsigned long ipaddr_t;
typedef unsigned int tcpport_t;

#define IPADDR_T unsigned long
#define TCPPORT_T unsigned int

/* Macro to turn an IP address into a UDWORD */
#define IP_ADDR(a,b,c,d)        (d<<24 | c<<16 | b<<8 | a )


/* TCP Header */

struct tcp_header {
        tcpport_t    srcport;
        tcpport_t    dstport;
        u32_t        seqnum;
        u32_t        acknum;
        u8_t         offset;
        u8_t         flags;
        u16_t        window;
        u16_t        cksum;
        u16_t        urgptr;
};


/* IP Header */

struct ip_header {
        u8_t     version;
        u8_t     tos;
        u16_t    length;
        u16_t    ident;
        u16_t    frag;
        u8_t     ttl;
        u8_t     protocol;
        u16_t    cksum;
        ipaddr_t source;
        ipaddr_t dest;
};

/* ICMP Header */

struct icmp_header {
        u8_t    type;
        u8_t    code;
        u16_t   cksum;
	u32_t	unused;		/* Used for various things */
	char	data[28];	/* Make up to 64 bytes */
};

/* UDP Header */

struct udp_header {
        tcpport_t       srcport;
        tcpport_t       dstport;
        u16_t           length;
        u16_t           cksum;
};



/* The various IP protocols */

#define prot_ICMP 1
#define prot_IGMP 2
#define prot_TCP  6
#define prot_UDP  17
#define prot_ALL  254
/* This is used to indicate a TCP socket is now under user
 * control (and has been unlinked from sock list 
 * 88 is as random as any number I hope..
 */
#define CONN_CLOSED 88
/* This is to mung it up completely */
#define BADIPTYPE 159


#define MAX_ICMPMSGS	17

/* ICMP Packet types */

/* Message types */
#define ECHO_REPLY      0       /* Echo Reply */
#define DEST_UNREACH    3       /* Destination Unreachable */
#define QUENCH          4       /* Source Quench */
#define REDIRECT        5       /* Redirect */
#define ECHO_REQUEST    8       /* Echo Request */
#define TIME_EXCEED     11      /* Time-to-live Exceeded */
#define PARAM_PROB      12      /* Parameter Problem */
#define TIMESTAMP       13      /* Timestamp */
#define TIME_REPLY      14      /* Timestamp Reply */
#define INFO_RQST       15      /* Information Request */
#define INFO_REPLY      16      /* Information Reply */


/* Destination Unreachable codes */
#define NET_UNREACH     0       /* Net unreachable */
#define HOST_UNREACH    1       /* Host unreachable */
#define PROT_UNREACH    2       /* Protocol unreachable */
#define PORT_UNREACH    3       /* Port unreachable */
#define FRAG_NEEDED     4       /* Fragmentation needed and DF set */
#define ROUTE_FAIL      5       /* Source route failed */

/* Time Exceeded codes */
#define TTL_EXCEED      0       /* Time-to-live exceeded */
#define FRAG_EXCEED     1       /* Fragment reassembly time exceeded */

/* Redirect message codes */
#define REDR_NET        0       /* Redirect for the network */
#define REDR_HOST       1       /* Redirect for the host */
#define REDR_TOS        2       /* Redirect for Type of Service, or-ed with prev */



#endif /* _NET_INET_H */
