/*
 * test.c - test a portable implementation of snprintf
 *
 * AUTHOR
 *   Mark Martinec <mark.martinec@ijs.si>, April 1999.
 *
 *   Copyright 1999, Mark Martinec. All rights reserved.
 *
 * TERMS AND CONDITIONS
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the "Frontier Artistic License" which comes
 *   with this Kit.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty
 *   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *   See the Frontier Artistic License for more details.
 *
 *   You should have received a copy of the Frontier Artistic License
 *   with this Kit in the file named LICENSE.txt .
 *   If not, I'll be glad to provide one.
 *
 * NOTE:  This test program is a QUICK and DIRTY tool
 * =====  used while testing and benchmarking my portable snprintf.
 *        Certain data types are not fully supported, certain test
 *        cases were fabricated during testing by modifying the code
 *        or running it by specifying test parameters in the command line.
 *
 *        You are on your own if you want to use this test program!
 */

/* If no command arguments are specified do the exhaustive test.
 * This takes a long time. You may want to reduce the fw and fp
 * upper limits in the for loops.
 * You may also reduce the number of test elements in the array iargs.
 */

#include <sys/types.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>

#include <assert.h>
#include <time.h>

#if defined(NEED_ASPRINTF) || defined(NEED_ASNPRINTF) || defined(NEED_VASPRINTF) || defined(NEED_VASNPRINTF)
# if defined(NEED_SNPRINTF_ONLY)
# undef NEED_SNPRINTF_ONLY
# endif
# if !defined(PREFER_PORTABLE_SNPRINTF)
# define PREFER_PORTABLE_SNPRINTF
# endif
#endif

#ifdef HAVE_SNPRINTF
extern int portable_snprintf(char *str, size_t str_m, const char *fmt, /*args*/ ...);
#else
extern int snprintf(char *, size_t, const char *, /*args*/ ...);
extern int vsnprintf(char *, size_t, const char *, va_list);
#endif

#ifndef HAVE_SNPRINTF
#define portable_snprintf  snprintf
#define portable_vsnprintf vsnprintf
#endif

#ifndef CLOCKS_PER_SEC
#define CLOCKS_PER_SEC 100
#endif

#define min(a,b) ((a)<(b) ? (a) : (b))
#define max(a,b) ((a)>(b) ? (a) : (b))

extern int asprintf  (char **ptr, const char *fmt, /*args*/ ...);
extern int vasprintf (char **ptr, const char *fmt, va_list ap);
extern int asnprintf (char **ptr, size_t str_m, const char *fmt, /*args*/ ...);
extern int vasnprintf(char **ptr, size_t str_m, const char *fmt, va_list ap);

#ifndef NEED_SNPRINTF_ONLY
int wrap_vsnprintf(char *str, size_t str_m, const char *fmt, /*args*/ ...);
int wrap_vsnprintf(char *str, size_t str_m, const char *fmt, ...) {
  va_list ap;
  int str_l;

  va_start(ap, fmt);
  str_l = vsnprintf(str, str_m, fmt, ap);
  va_end(ap);
  return str_l;
}
#endif

#ifdef NEED_VASPRINTF
int wrap_vasprintf(char **ptr, const char *fmt, /*args*/ ...);
int wrap_vasprintf(char **ptr, const char *fmt, ...) {
  va_list ap;
  int str_l;

  va_start(ap, fmt);
  str_l = vasprintf(ptr, fmt, ap);
  va_end(ap);
  return str_l;
}
#endif

#ifdef NEED_VASNPRINTF
int wrap_vasnprintf(char **ptr, size_t str_m, const char *fmt, /*args*/ ...);
int wrap_vasnprintf(char **ptr, size_t str_m, const char *fmt, ...) {
  va_list ap;
  int str_l;

  va_start(ap, fmt);
  str_l = vasnprintf(ptr, str_m, fmt, ap);
  va_end(ap);
  return str_l;
}
#endif

int main(int argc, char *argv[]) {
  char str1[256], str2[256];
#ifdef HAVE_SNPRINTF
  char str3[256];
#endif
  int len1, len2, len3;
  int bad = 0;
  size_t str_m = 20; /* declared str size */

  if (0) {
 /* benchmarking */
    const int cnt = 100000;
    size_t size;
    char str[40000];
    time_t t0,t;
    int j,len,l1,l2;
    char *p;
    int breakpoint;

    size = 18000;

    printf("\n\nsize = %d\n", (int)size);
    p = malloc(size); assert(p);
    memset(p,'h',size); p[size-1] = '\0';
    t0 = clock();

    printf("\ndetermine breakeven point to see when it is worth\n");
    printf("calling memcpy and when to do inline string copy\n");
    printf("str_l, memcpy, inline\n");
    for (breakpoint=0; breakpoint<=35; breakpoint++) {
      register size_t nnn = (size_t)breakpoint;
      printf("%5ld", nnn);
      for (j=10*cnt; j>0; j--) memcpy(str, p, nnn);
      t = clock(); printf(" %1.3f", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
      for (j=10*cnt; j>0; j--) {
        register size_t nn = (size_t)breakpoint;
        if (nn > 0) {
          register char *dd; register const char *ss;
          for (ss=p, dd=str; nn>0; nn--) *dd++ = *ss++;
        }
      }
      t = clock(); printf(" %1.3f\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    }

    printf("\nmeasuring time to SKIP a long format with no conversions\n");
    p[0] = '%'; p[1] = 's';
    for (j=cnt; j>0; j--) l1=portable_snprintf(NULL,(size_t)0,p,"1234567890");
    t = clock(); printf("t_port_nul = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    for (j=cnt; j>0; j--) l2=portable_snprintf(str,(size_t)8,p,"1234567890");
    t = clock(); printf("t_port     = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    assert(l1==l2);
    p[0] = p[1] = 'h';

    printf("\nmeasuring time to copy a long format with no conversions\n");
    for (j=cnt; j>0; j--) l1=portable_snprintf(NULL,(size_t)0,p);
    t = clock(); printf("t_port_nul = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    for (j=cnt; j>0; j--) l2=portable_snprintf(str,sizeof(str),p);
    t = clock(); printf("t_port     = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    assert(l1==l2);
    for (j=cnt; j>0; j--) sprintf(str,p);
    t = clock(); printf("t_sys      = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;

    printf("\nmeasuring time to copy a long format with one conversion\n");
    p[size-10] = '%';
    for (j=cnt; j>0; j--) l1=portable_snprintf(NULL,(size_t)0,p);
    t = clock(); printf("t_port_nul = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    for (j=cnt; j>0; j--) l2=portable_snprintf(str,sizeof(str),p);
    t = clock(); printf("t_port     = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    assert(l1==l2);
    for (j=cnt; j>0; j--) sprintf(str,p);
    t = clock(); printf("t_sys      = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;

    printf("\nmeasuring string argument copy speed\n");
    for (j=cnt; j>0; j--) l1=portable_snprintf(NULL,(size_t)0,"%.18000s",p);
    t = clock(); printf("t_port_nul = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    for (j=cnt; j>0; j--) l2=portable_snprintf(str,sizeof(str),"%.18000s",p);
    t = clock(); printf("t_port     = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    assert(l1==l2);
    for (j=cnt; j>0; j--) sprintf(str,"%.18000s",p);
    t = clock(); printf("t_sys      = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;

    printf("\nmeasuring left padding speed\n");
    p[0] = '\0';
    for (j=cnt; j>0; j--) l1=portable_snprintf(NULL,(size_t)0,"%-18000s",p);
    t = clock(); printf("t_port_nul = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    for (j=cnt; j>0; j--) l2=portable_snprintf(str,sizeof(str),"%-18000s",p);
    t = clock(); printf("t_port     = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    assert(l1==l2);
    for (j=cnt; j>0; j--) sprintf(str,"%-18000s",p);
    t = clock(); printf("t_sys      = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;

    printf("\nmeasuring right padding speed\n");
    p[0] = '\0';
    for (j=cnt; j>0; j--) l1=portable_snprintf(NULL,(size_t)0,"%18000s",p);
    t = clock(); printf("t_port_nul = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    for (j=cnt; j>0; j--) l2=portable_snprintf(str,sizeof(str),"%18000s",p);
    t = clock(); printf("t_port     = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    assert(l1==l2);
    for (j=cnt; j>0; j--) sprintf(str,"%18000s",p);
    t = clock(); printf("t_sys      = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;

    printf("\nmeasuring zero padding speed\n");
    for (j=cnt; j>0; j--) l1=portable_snprintf(NULL,(size_t)0,"%018000d",1);
    t = clock(); printf("t_port_nul = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    for (j=cnt; j>0; j--) l2=portable_snprintf(str,sizeof(str),"%018000d",1);
    t = clock(); printf("t_port     = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
    assert(l1==l2);
    for (j=cnt; j>0; j--) sprintf(str,"%018000d",1);
    t = clock(); printf("t_sys      = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;

    printf("\nmeasuring system's sprintf to efficiently handle truncated strings\n");
    memset(p,'h',size); p[size-1] = '\0';
    t0 = clock();
    for (j=cnt; j>0; j--) len = strlen(p);
    printf("len = %d\n", len);
    t = clock(); printf("t_strlen = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
/* test if the system sprintf scans the whole string (e.g. by strlen)
 * before recognizing this was a bad idea since the format specified
 * a truncated string precision, e.g. "%.8s" .
 */
    for (j=cnt; j>0; j--) sprintf(str,"%.2s",p);
    t = clock(); printf("t_sys    = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
#ifdef HAVE_SNPRINTF
    for (j=cnt; j>0; j--) snprintf(str,sizeof(str),"%.2s",p);
    t = clock(); printf("t_sys    = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;
#endif
    for (j=cnt; j>0; j--) portable_snprintf(str,sizeof(str),"%.2s",p);
    t = clock(); printf("t_port   = %1.3f s\n", (float)(t-t0)/CLOCKS_PER_SEC); t0 = t;

    free(p);
    return 0;
  }


/* preliminary halfhearted test */
{
    const char fmt[] = "Bla%.4s%05iHE%%%-50sTail";
    char *ptr4=0, *ptr5=0, *ptr6=0, *ptr7=0;
    int len1f;
    char str_full[256];

    printf("\npreliminary test: snprintf\n");
    len1  = snprintf(str1, str_m, fmt, "abcdef",-12,"str");
    len1f = snprintf(str_full, sizeof(str_full), fmt, "abcdef",-12,"str");
    assert(len1f==len1);
    assert(memcmp(str1,str_full,min(len1,str_m-1)) == 0);
    assert(str1[str_m-1] == '\0');
    assert(str_full[sizeof(str_full)-1] == '\0');

#ifndef NEED_SNPRINTF_ONLY
    printf("preliminary test: vsnprintf\n");
    len2 = wrap_vsnprintf(str2, str_m, fmt, "abcdef",-12,"str");
    assert(len2==len1);
    assert(memcmp(str1,str2,min(len1+1,str_m)) == 0);
    assert(str2[str_m-1] == '\0');
#endif

#ifdef NEED_ASPRINTF
    printf("preliminary test: asprintf\n");
    len4 = asprintf(&ptr4, fmt, "abcdef",-12,"str");
    assert(ptr4);
    assert(len4==len1);
    assert(memcmp(str_full,ptr4,min(len4+1,sizeof(str_full))) == 0);
    assert(ptr4[len4] == '\0');
#endif

#ifdef NEED_ASNPRINTF
    printf("preliminary test: asnprintf\n");
    len5 = asnprintf(&ptr5, str_m, fmt, "abcdef",-12,"str");
    assert(ptr5);
    assert(len5==len1);
    assert(memcmp(str1,ptr5,min(len5+1,str_m)) == 0);
    assert(ptr5[len5] == '\0');
#endif

#ifdef NEED_VASPRINTF
    printf("preliminary test: vasprintf\n");
    len6 = wrap_vasprintf(&ptr6, fmt, "abcdef",-12,"str");
    assert(ptr6);
    assert(len6==len1);
    assert(memcmp(str_full,ptr6,min(len6+1,sizeof(str_full))) == 0);
    assert(ptr6[len6] == '\0');
#endif

#ifdef NEED_VASNPRINTF
    printf("preliminary test: vasnprintf\n");
    len7 = wrap_vasnprintf(&ptr7, str_m, fmt, "abcdef",-12,"str");
    assert(ptr7);
    assert(len7==len1);
    assert(memcmp(str1,ptr7,min(len7+1,str_m)) == 0);
    assert(ptr7[len7] == '\0');
#endif

    if (ptr4) free(ptr4);
    if (ptr5) free(ptr5);
    if (ptr6) free(ptr6);
    if (ptr7) free(ptr7);
}

/* second preliminary halfhearted test */
{
    printf("\nsecond preliminary test:\n");

    printf("test 0a\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "");
    len2 = sprintf (str2,               "");
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 0b\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "YK");
    len2 = sprintf (str2,               "YK");
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 1\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%+d",0);
    len2 = sprintf (str2,               "%+d",0);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 2\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%.2147483647s", "13");
    len2 = sprintf (str2,               "%.2147483647s", "13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 3a\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%.2147483648s", "13");
    len2 = sprintf (str2,               "%.2147483648s", "13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 3b\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%.2147483649s", "13");
    len2 = sprintf (str2,               "%.2147483649s", "13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 4\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%-.2147483647s", "13");
    len2 = sprintf (str2,               "%-.2147483647s", "13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 5\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%-.2147483648s", "13");
    len2 = sprintf (str2,               "%-.2147483648s", "13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 6\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%.4294967295s", "13");
    len2 = sprintf (str2,               "%.4294967295s", "13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 7\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%.4294967296s", "13");
    len2 = sprintf (str2,               "%.4294967296s", "13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);


    printf("test 12\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%.*s", 2147483647,"13");
    len2 = sprintf (str2,               "%.*s", 2147483647,"13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 13\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%.*s", 2147483648U,"13");
    len2 = sprintf (str2,               "%.*s", 2147483648U,"13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 14\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%-.*s", 2147483647,"13");
    len2 = sprintf (str2,               "%-.*s", 2147483647,"13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 15\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%-.*s", 2147483648U,"13");
    len2 = sprintf (str2,               "%-.*s", 2147483648U,"13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 16\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%.*s", 4294967295U,"13");
    len2 = sprintf (str2,               "%.*s", 4294967295U,"13");
    printf("len1=%d, len2=%d\n", len1,len2);
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 17\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%.*s", 4294967296U,"13");
/*  len2 = sprintf (str2,               "%.*s", 4294967296U,"13"); */ /* core dumps on HPUX */
/*  assert(len1==len2);
 *  assert(memcmp(str1,str2,(size_t)len1) == 0);
 */


    printf("test 95\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%c",'A');
    len2 = sprintf (str2,               "%c",'A');
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 96\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%10c",'A');
    len2 = sprintf (str2,               "%10c",'A');
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 97\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%-10c",'A');
    len2 = sprintf (str2,               "%-10c",'A');
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 98\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%.10c",'A');
    len2 = sprintf (str2,               "%.10c",'A');
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);

    printf("test 99\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, sizeof(str1), "%-.10c",'A');
    len2 = sprintf (str2,               "%-.10c",'A');
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)len1) == 0);


    printf("test 100\n");
    memset(str1,'x',sizeof(str1));  memset(str2,'x',sizeof(str2));
    len1 = snprintf(str1, (size_t)8, "blaBhb%shehe%cX","ABCD",'1');
    len2 = sprintf (str2,            "blaBhb%shehe%cX","ABCD",'1');
    assert(len1==len2);
    assert(memcmp(str1,str2,(size_t)7) == 0);
    assert(str1[7] == '\0');
    assert(memcmp(str1+14,str2+16,(size_t)(len1-16)) == 0);

}

 /* testing for correctness and compatibility */
  if (argc >= 3) {
    char *c; int alldigits = 1;
    for (c=argv[2]; *c; c++)
      if (! (*c == '-' || (*c >= '0' && *c <= '9'))) alldigits = 0;
    if (alldigits) {
      int j = atoi(argv[2]);
      len1 = portable_snprintf(str1, str_m, argv[1], j, 3);
      len2 = sprintf(str2,                  argv[1], j, 3);
#ifdef HAVE_SNPRINTF
      len3 = snprintf(str3, str_m,          argv[1], j, 3);
#endif
    } else {
      len1 = portable_snprintf(str1, str_m, argv[1], argv[2], 3);
      len2 = sprintf(str2,                  argv[1], argv[2], 3);
#ifdef HAVE_SNPRINTF
      len3 = snprintf(str3, str_m,          argv[1], argv[2], 3);
#endif
    }
    printf("portable:     |%s|  len = %d\n", str1, len1);
    printf("sys sprintf:  |%s|  len = %d\n", str2, len2);
#ifdef HAVE_SNPRINTF
    printf("sys snprintf: |%s|  len = %d\n", str3, len3);
#endif
  } else {  /* exhaustive testing */

    const char flags[] = "+- 0#";     /* set of test flags   (including '\0')*/
    int flags_l = strlen(flags);

    const char fspec[] = "scdpoxXuiy"; /* set of test formats (including '\0') */
    int fspec_l = strlen(fspec);

#ifdef SNPRINTF_LONGLONG_SUPPORT
    const char datatype[] = " hl2"; /* set of datatypes */
#else
    const char datatype[] = " hl";  /* set of datatypes */
#endif
    int datatype_l = strlen(datatype);

    const long int iargs[] =                /* set of numeric test arguments */
      { 0,1,9,10,28,99,100,127,128,129,998,1000,32767,32768,32769,
        -1,-9,-10,-28,-99,-100,-127,-128,-129,
        -998,-1000,-32767,-32768,-32769 };
    int iargs_l = sizeof(iargs)/sizeof(iargs[0]);
    const char *sargs[] =             /* set of string test arguments */
      { "", "a", "0", "-ab", "abcde", "abcdefghijk mnopqrstuv" };
    int sargs_l = sizeof(sargs)/sizeof(sargs[0]);

    char fmt[256];
    int fmt_l;
    int a, fs, fl1, fl2, fl3, fl4, fl5, fw, fp, dt;

    for (fs=0; fs<=fspec_l; fs++) {  /* format specifier */
      int strtype = (fspec[fs] == 's' || fspec[fs] == '%');
      int args_l = (strtype ? sargs_l : iargs_l);

      for (fw= -1; fw<=3; fw++) {  /* minimal field width */

        printf("Trying format  %%");
        if (fw >= 0) printf("%d", fw);
        if (fspec[fs]) putchar(fspec[fs]);
        putchar('\n');

        for (fp= -2; fp<=3; fp++) {   /* format field precision */

          /* data type modifiers */
          for (dt=0; dt < ((strtype||fspec[fs]=='c') ? 1 : datatype_l); dt++) {

            int dataty = datatype[dt];

            if (fspec[fs] == 'D' || fspec[fs] == 'U' || fspec[fs] == 'O')
              dataty = 'l';

            if (fspec[fs] == 'p' && dataty == '2') continue;

            for (fl1=0; fl1<=flags_l; fl1++) {  /* flags */
             for (fl2=0; fl2<=flags_l; fl2++) {
              for (fl3=0; fl3<=flags_l; fl3++) {
               for (fl4=0; fl4<=flags_l; fl4++) {
                for (fl5=0; fl5<=flags_l; fl5++) {

                   for (a=0; a<args_l; a++) {  /* test arguments */

                     fmt_l = 0; fmt[fmt_l++] = '%';
                     if (flags[fl1]) fmt[fmt_l++] = flags[fl1];
                     if (flags[fl2]) fmt[fmt_l++] = flags[fl2];
                     if (flags[fl3]) fmt[fmt_l++] = flags[fl3];
                     if (flags[fl4]) fmt[fmt_l++] = flags[fl4];
                     if (flags[fl5]) fmt[fmt_l++] = flags[fl5];
                     if (fw >= 0) fmt_l += sprintf(fmt+fmt_l, "%d", fw);
                     if (fp >= -1) {
                       fmt[fmt_l++] = '.';
                       if (fp >= 0) fmt_l += sprintf(fmt+fmt_l, "%d", fp);
                     }
                     if (dataty == '2')
                       { fmt[fmt_l++] = 'l'; fmt[fmt_l++] = 'l'; }
                     else if (dataty != ' ')
                       { fmt[fmt_l++] = dataty; }

                     if (fspec[fs]) fmt[fmt_l++] = fspec[fs];
                     fmt[fmt_l++] = '\0';

                     if (a==0 && fl1==flags_l && fl2==flags_l && fl3==flags_l
                         && fl4==flags_l && fl5==flags_l) printf("%s\n", fmt);

#ifdef HAVE_SNPRINTF
                     memset(str1,'G',sizeof(str1));
                     memset(str2,'G',sizeof(str2));
                     memset(str3,'G',sizeof(str3));
#endif
                     len1 = len2 = len3 = 0;
                     if (strtype) {
                       len1 = portable_snprintf(str1, str_m, fmt, sargs[a]);
                       len2 = sprintf(str2,                  fmt, sargs[a]);
#ifdef HAVE_SNPRINTF
                       len3 = snprintf(str3, str_m,          fmt, sargs[a]);
#endif
                     } else if (fspec[fs] == 'p') {
                       len1 = portable_snprintf(str1, str_m, fmt, (void *)iargs[a]);
                       len2 = sprintf(str2,                  fmt, (void *)iargs[a]);
#ifdef HAVE_SNPRINTF
                       len3 = snprintf(str3, str_m,          fmt, (void *)iargs[a]);
#endif
                     } else {
                       switch (dataty) {
                       case '\0':
                         len1 = portable_snprintf(str1, str_m, fmt, (int) iargs[a]);
                         len2 = sprintf(str2,                  fmt, (int) iargs[a]);
#ifdef HAVE_SNPRINTF
                         len3 = snprintf(str3, str_m,          fmt, (int) iargs[a]);
#endif
                         break;
                       case 'h':
                         len1 = portable_snprintf(str1, str_m, fmt, (short int)iargs[a]);
                         len2 = sprintf(str2,                  fmt, (short int)iargs[a]);
#ifdef HAVE_SNPRINTF
                         len3 = snprintf(str3, str_m,          fmt, (short int)iargs[a]);
#endif
                         break;
                       case 'l':
                         len1 = portable_snprintf(str1, str_m, fmt, (long int)iargs[a]);
                         len2 = sprintf(str2,                  fmt, (long int)iargs[a]);
#ifdef HAVE_SNPRINTF
                         len3 = snprintf(str3, str_m,          fmt, (long int)iargs[a]);
#endif
                         break;
#ifdef SNPRINTF_LONGLONG_SUPPORT
                       case '2':
                         len1 = portable_snprintf(str1, str_m, fmt, (long long int)iargs[a]);
                         len2 = sprintf(str2,                  fmt, (long long int)iargs[a]);
#ifdef HAVE_SNPRINTF
                         len3 = snprintf(str3, str_m,          fmt, (long long int)iargs[a]);
#endif
                         break;
#endif
                       }
                     }

                     if (0) {
#ifdef HAVE_SNPRINTF
                     } else if (len1 != len3 ||
                         memcmp(str1,str3,min(len1+20,sizeof(str1))) != 0) {
                       bad = 1;
                       if (strtype) printf("\n2: %s, <%s>\n", fmt, sargs[a]);
                       else         printf("\n2: %s, %ld\n",   fmt, iargs[a]);
                       printf("portable:     |%s|  len = %d\n", str1, len1);
                       printf("sys sprintf:  |%s|  len = %d\n", str2, len2);
                       printf("sys snprintf: |%s|  len = %d\n", str3, len3);
#else
                     } else if (len1 != len2 ||
                         (len1>0 && memcmp(str1,str2,min(len1,str_m)-1) != 0)) {
                       bad = 1;
                       if (strtype) printf("\n1: %s, <%s>\n", fmt, sargs[a]);
                       else         printf("\n1: %s, %ld\n",   fmt, iargs[a]);
                       printf("portable:     |%s|  len = %d\n", str1, len1);
                       printf("sys sprintf:  |%s|  len = %d\n", str2, len2);
#endif
                     }
                     if (bad) return(1);
                   }

                }
               }
              }
             }

            }
          }
        }
      }
    }
  }
  return (bad?1:0);
}
