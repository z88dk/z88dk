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

/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/hist.h,v 1.6 2011-07-09 18:25:35 pauloscustodio Exp $ */
/* $Log: hist.h,v $
/* Revision 1.6  2011-07-09 18:25:35  pauloscustodio
/* Log keyword in checkin comment was expanded inside Log expansion... recursive
/* Added Z80asm banner to all source files
/*
/* Revision 1.5  2011/07/09 17:36:09  pauloscustodio
/* Copied cvs log into Log history
/*
/* Revision 1.4  2011/07/09 01:46:00  pauloscustodio
/* Added Log keyword
/*
/* Revision 1.3  2011/07/09 01:40:15  pauloscustodio
/* *** empty log message ***
/* 
/* Revision 1.2  2011/07/09 01:38:02  pauloscustodio
/* *** empty log message ***
/* 
/* Revision 1.1  2011/07/09 01:07:56  pauloscustodio
/* Moved version strings to hist.c, created hist.h, for easy maintenance.
/* 
/* */

#ifndef HIST_H
#define HIST_H

#ifdef QDOS
extern char _prog_name[], _version[], _copyright[];
#endif

extern char copyrightmsg[];

#endif /* ndef HIST_H */
