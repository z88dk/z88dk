/*
 *	Flush a network connection
 *
 *	djm 27/4/2000
 */

#include <stdio.h>
#include <net/socket.h>

int fflush_net(SOCKET *s)
{
	sock_flush(s);
	iferror return EOF;
	return 0;
}


