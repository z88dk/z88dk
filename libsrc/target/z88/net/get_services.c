
/*
 *	ZSock C Library
 *
 *	Part of the getxxbyXX series of functions
 *
 *	(C) 6/10/2001 Dominic Morris
 */

#include <net/resolv.h>

static struct data_entry ip_services[] = {
        { "echo",        7 ,prot_TCP },
        { "qotd",       17 ,prot_TCP },
        { "chargen",    19 ,prot_TCP },
        { "ftp",        21 ,prot_TCP },
        { "ftp-data",   20 ,prot_TCP },
        { "telnet",     23 ,prot_TCP },
        { "smtp",       25 ,prot_TCP },
        { "tftp",       69 ,prot_UDP },
        { "finger",     79 ,prot_TCP },
        { "www",        80 ,prot_TCP },
        { "pop-2",      109 ,prot_TCP },
        { "pop-3",      110 ,prot_TCP },
        { 0,           0,0 }
};

struct data_entry *get_services()
{
	return ip_services;
}
