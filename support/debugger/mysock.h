#ifndef _MYSOCK__H
#define _MYSOCK__H

int mysock_connect_socket(const char* host, unsigned port);
int mysock_create_listener(int portno);
int mysock_create_listener_random(int* portno);
int mysock_get_incoming_connection(int acceptor);

int mysock_read_data(int sock, char *buf, int size, int ms_timeout);
void mysock_write_persist(int sock, const char* str, int sz);

#endif
