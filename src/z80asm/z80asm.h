/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Gunther Strube, InterLogic 1993-99
*/

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/z80asm.h,v 1.7 2011-07-09 18:25:35 pauloscustodio Exp $ */
/* $Log: z80asm.h,v $
/* Revision 1.7  2011-07-09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.6  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.5  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/* 
/* Revision 1.4  2011/07/09 01:38:02  pauloscustodio
/* *** empty log message ***
/* 
/* Revision 1.3  2011/07/09 01:31:24  pauloscustodio
/* Moved snprintf macro to z80asm.h
/* 
/* Revision 1.2  2009/07/18 23:23:15  dom
/* clean up the code a bit more (Formatting and a fewer magic numbers)
/* 
/* Revision 1.1  2009/06/13 17:36:24  dom
/* Add -I and -L to specify search paths for libraries and includes
/* 
/* */

/* $History: Z80ASM.C $ */
/*  */

#ifndef Z80ASM_H
#define Z80ASM_H

/* snprintf is _snprintf in WIN32 */
#ifdef WIN32
#define snprintf _snprintf
#endif


#define REG16_BC   0
#define REG16_DE   1
#define REG16_HL   2
#define REG16_SP   3
#define REG16_AF   4
#define REG16_IX   5
#define REG16_IY   6

#define FLAGS_NZ 0
#define FLAGS_Z  1
#define FLAGS_NC 2
#define FLAGS_C  3
#define FLAGS_PO 4
#define FLAGS_PE 5
#define FLAGS_P 6
#define FLAGS_M 7


#define CPU_Z80     1
#define CPU_RCM2000 2
#define CPU_RCM3000 4
#define CPU_Z180    8


#define CPU_RABBIT (CPU_RCM2000|CPU_RCM3000)
#define CPU_ZILOG (CPU_Z80|CPU_Z180)
#define CPU_ALL ( CPU_ZILOG |  CPU_RABBIT )


extern int   cpu_type;


extern char *Fetchfilename (FILE *fptr);

extern char *SearchFile(char *base, int is_include);

#endif
