/*
 *	Flush a network connection
 *
 *	djm 27/4/2000
 *	
 *	$Id: fflush_net.c,v 1.2 2001-04-13 14:14:00 stefano Exp $
 */

#include <stdio.h>
#include <net/socket.h>

int fflush_net(SOCKET *s)
{
	sock_flush(s);
	iferror return EOF;
	return 0;
}


