/*
 *	Close a network socket (stdio)
 *
 *	djm 25/4/2000
 *	
 *	$Id: closenet.c,v 1.2 2001-04-13 14:14:00 stefano Exp $
 */

#include <stdio.h>
#include <net/socket.h>
#include <net/misc.h>

int closenet(SOCKET *s)
{
	printf("Entered closenet\n");
	sock_close(s);
	sock_waitclose(s);
	printf("calling shutdoen");
	sock_shutdown(s);
	return 0;
}

