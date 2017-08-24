include(__link__.m4)

#ifndef __ARPA_INET_H__
#define __ARPA_INET_H__

#include <intrinsic.h>
#include <netinet/in.h>

__OPROTO(`b,c',`b,c',unsigned long,,htonl,unsigned long)
__OPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,htons,unsigned int)
__OPROTO(`b,c',`b,c',unsigned long,,ntohl,unsigned long)
__OPROTO(`b,c,d,e',`b,c,d,e',unsigned int,,ntohs,unsigned int)

#define htonl(a) intrinsic_swap_endian_32(a)
#define htons(a) intrinsic_swap_endian_16(a)
#define ntohl(a) intrinsic_swap_endian_32(a)
#define ntohs(a) intrinsic_swap_endian_16(a)

#endif
