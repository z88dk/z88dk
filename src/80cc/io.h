
/* io.c */
extern int getint(unsigned char *addr, int len);
extern void putint(int i, unsigned char *addr, int len);
extern int symname(char *sname);
extern int getlabel(void);
extern void printlabel(int label);
extern void postlabel(int label);
extern int alpha(char c);
extern int numeric(char c);
extern int an(char c);
extern void fabort(void);
extern void toconsole(void);
extern void tofile(void);
extern int outbyte(char c);
extern void outstr(const char *ptr);
extern void outfmt(const char *fmt,...);
extern void nl(void);
extern void tab(void);
extern void col(void);
extern void ol(char *ptr);
extern void ot(char *ptr);
extern void blanks(void);
extern void outdec(long number);
extern void outd2(long n);
extern void queuelabel(int);

