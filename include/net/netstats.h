#ifndef _NET_NETSTATS_H
#define _NET_NETSTATS_H

#include <sys/types.h>
#include <net/inet.h>

/*
 *	This file contains definitions for the stats
 *	for TCP stack - packets received etc
 *
 *	djm 28/1/2000
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
	"IP:   %u packets received",
	"lIP:   %lu bytes received",
	"IP:   %u bad checksums",
	"IP:   %u bad lengths",
	"IP:   %u packets sent",

	"UDP:  %u packets received",
	"lUDP:  %lu bytes received",
	"UDP:  %u bad checksums",
	"UDP:  %u packets sent",
	"lUDP:  %lu bytes sent",

	"TCP:  %u packets received",
	"lTCP:  %lu bytes received",
	"TCP:  %u bad checksums",
	"TCP:  %u rsts received",
	"TCP:  %u packets sent",
	"lTCP:  %lu bytes sent",  
	"TCP:  %u rsts sent",
	"TCP:  %u connections requests",
	"TCP:  %u connection accepts",
	"TCP:  %u connections established",
	"TCP:  %u connections closed",

	"ICMP: %u packets received",
	"ICMP: %u checksum errors",
	"ICMP: %u ICMP messages sent",
	"ICMP: %u messages not send cos old message was icmp"};
#endif
	


#endif
