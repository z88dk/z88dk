#ifndef PACKETS_H
#define PACKETS_H

#include <stdint.h>
#include <sys/types.h>


#ifdef _MSC_VER
#include <WinSock2.h>
typedef SOCKET sock_t;
typedef SSIZE_T ssize_t;
#else
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
typedef int sock_t;
#endif


#define PACKET_BUF_SIZE 0x4000

static const char INTERRUPT_CHAR = '\x03';

uint8_t *inbuf_get();
int inbuf_end();
void inbuf_reset();
void inbuf_erase_head(ssize_t end);
void write_flush(sock_t sockfd);
void write_packet(const char *data);
void write_packet_bytes(const uint8_t *data, size_t num_bytes);
void write_data_raw(const uint8_t *data, ssize_t len);
void write_binary_packet(const char *pfx, const uint8_t *data, ssize_t num_bytes);
int read_packet(sock_t sockfd);

#endif /* PACKETS_H */
