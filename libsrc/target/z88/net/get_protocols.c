
/*
 *	ZSock C Library
 *
 *	Part of the getxxbyXX series of functions
 *
 *	(C) 6/10/2001 Dominic Morris
 */

#include <net/resolv.h>

static struct data_entry ip_protocols[] = {
        { "ip",         0, 0 },
        { "icmp",       1, 0 },
//      { "igmp",       2, 0 },
        { "tcp",        6, 0 },
        { "udp",        17,0 },
        { 0,            0,0}
};

struct data_entry *get_protocols()
{
	return ip_protocols;
}

