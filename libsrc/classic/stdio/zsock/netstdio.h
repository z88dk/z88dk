#ifndef NETSTDIO_H
#define NETSTDIO_H

extern int __LIB__ fgetc_net(void *s);
extern int __LIB__ fputc_net(void *s, int c);
extern int __LIB__ closenet(void *s);
extern int __LIB__ opennet(FILE *fp, char *name);
extern int __LIB__ fflush_net(void *s);


#endif
