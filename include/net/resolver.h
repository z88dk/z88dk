#ifndef __NET_RESOLVER_H__
#define __NET_RESOLVER_H__

/*
 *	This file is included by the ZSock kernel
 *	**DO NOT USE IN USER PROGRAMS!!
 *
 *	$Id: resolver.h,v 1.5 2002-05-14 22:31:15 dom Exp $
 */

/* Max domain name size to play with */
#define	DOMSIZE	128

/*
 *  Header for the DOMAIN queries
 *  ALL OF THESE ARE u8_t SWAPPED QUANTITIES!
 */
struct dhead {
    u16_t        ident;          /* unique identifier */
    u16_t        flags;
    u16_t        qdcount;        /* question section, # of entries */
    u16_t        ancount;        /* answers, how many */
    u16_t        nscount;        /* count of name server RRs */
    u16_t        arcount;        /* number of "additional" records */
};

/*
 *  flag masks for the flags field of the DOMAIN header
 */
#define DQR             0x8000  /* query = 0, response = 1 */
#define DOPCODE         0x7100  /* opcode, see below */
#define DAA             0x0400  /* Authoritative answer */
#define DTC             0x0200  /* Truncation, response was cut off at 512 */
#define DRD             0x0100  /* Recursion desired */
#define DRA             0x0080  /* Recursion available */
#define DRCODE          0x000F  /* response code, see below */

/* opcode possible values: */
#define DOPQUERY        0       /* a standard query */
#define DOPIQ           1       /* an inverse query */
#define DOPCQM          2       /* a completion query, multiple reply */
#define DOPCQU          3       /* a completion query, single reply */
/* the rest reserved for future */

/* legal response codes: */
#define DROK    0               /* okay response */
#define DRFORM  1               /* format error */
#define DRFAIL  2               /* their problem, server failed */
#define DRNAME  3               /* name error, we know name doesn't exist */
#define DRNOPE  4               /* no can do request */
#define DRNOWAY 5               /* name server refusing to do request */

#define DTYPEA          1       /* host address resource record (RR) */
#define DTYPEPTR        12      /* a domain name ptr */

#define DIN             1       /* ARPA internet class */
#define DWILD           255     /* wildcard for several of the classifications */

/*
 * a resource record is made up of a compressed domain name followed by
 * this structure.  All of these ints need to be byteswapped before use.
 */
struct rrpart {
    u16_t        rtype;          /* resource record type = DTYPEA */
    u16_t        rclass;         /* RR class = DIN */
    u32_t        ttl;            /* time-to-live, changed to 32 bits */
    u16_t        rdlength;       /* length of next field */
    u8_t         rdata[DOMSIZE]; /* data field */
};

/*
 *  data for domain name lookup
 */
struct useek {
    struct dhead h;
    u8_t         x[DOMSIZE];
};

#endif /* _NET_RESOLVER_H */
