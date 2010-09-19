#ifndef __NET_NETSTATS_H__
#define __NET_NETSTATS_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <net/inet.h>

/*
 *	This file contains definitions for the stats
 *	for TCP stack - pkts recvd etc
 *
 *	djm 28/1/2000
 *
 *	$Id: netstats.h,v 1.5 2010-09-19 00:24:08 dom Exp $
 */

typedef unsigned int nstat_t;
typedef unsigned long nlen_t;

struct sysstat_s {
/* IP layer */
	nstat_t	ip_recvd;
	nlen_t	ip_recvlen;
	nstat_t	ip_badck;
	nstat_t ip_badlen;
	nstat_t ip_sent;
/* UDP layer */
	nstat_t	udp_recvd;
	nlen_t	udp_recvlen;
	nstat_t	udp_badck;
	nstat_t	udp_sent;
	nlen_t	udp_sentlen;
/* TCP layer */
	nstat_t	tcp_recvd;
	nlen_t	tcp_recvdlen;
	nstat_t	tcp_badck;
	nstat_t tcp_rstrecvd;
	nstat_t	tcp_sent;
	nlen_t	tcp_sentlen;
	nstat_t	tcp_rstsent;
	nstat_t	tcp_connreqs;
	nstat_t	tcp_connaccs;
	nstat_t	tcp_estab;
	nstat_t	tcp_closed;
/* ICMP layer */
	nstat_t	icmp_recvd;
	nstat_t	icmp_badck;
	nstat_t	icmp_sent;
	nstat_t	icmp_icmp;
	nstat_t	icmp_inp[MAX_ICMPMSGS];
	nstat_t	icmp_out[MAX_ICMPMSGS];
};

/* Length of the netstat structure */
#define NETSTAT_SIZE 128
/* Number of values (excluding icmp_inp/_out */
#define NETSTAT_NUM   25

/*
 *	Text for netstats, if there's an 'l' in the first column it
 *	means the value we print is long
 */

#ifdef NETSTAT_TXT
static char *netstat_txt[]= {
	"IP:   %u pkts recvd",
	"lIP:   %lu bytes recvd",
	"IP:   %u bad cksums",
	"IP:   %u bad lengths",
	"IP:   %u pkts sent",

	"UDP:  %u pkts recvd",
	"lUDP:  %lu bytes recvd",
	"UDP:  %u bad cksums",
	"UDP:  %u pkts sent",
	"lUDP:  %lu bytes sent",

	"TCP:  %u pkts recvd",
	"lTCP:  %lu bytes recvd",
	"TCP:  %u bad cksums",
	"TCP:  %u rsts recvd",
	"TCP:  %u pkts sent",
	"lTCP:  %lu bytes sent",  
	"TCP:  %u rsts sent",
	"TCP:  %u conns requests",
	"TCP:  %u conn accepts",
	"TCP:  %u conns established",
	"TCP:  %u conns closed",

	"ICMP: %u pkts recvd",
	"ICMP: %u cksum errors",
	"ICMP: %u ICMP msgs sent",
	"ICMP: %u msgs not sent cos old msg was icmp"};
#endif
	


#endif
