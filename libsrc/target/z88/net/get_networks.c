
/*
 *	ZSock C Library
 *
 *	Part of the getxxbyXX series of functions
 *
 *	(C) 6/10/2001 Dominic Morris
 */

#include <net/resolv.h>

static struct data_entry ip_networks[] = {
        { "arpa",       10 ,0 },
        { "arpanet",    10 ,0 },
        { "loop",       127 , 0 },
        { "loopback",   127 ,0 },
        { 0,            0,0 }
};

struct data_entry *get_networks()
{
	return ip_networks;
}

