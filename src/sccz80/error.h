/* error.c */
extern int endst(void);
extern void illname(char *sname);
extern void multidef(const char *sname);
extern void needtoken(char *str);
extern void needchar(char c);
extern void needlval(void);
extern void warningfmt(const char *fmt, ...);
extern void debug(int num,char *str,...);
extern void errorfmt(const char *fmt, int fatal, ...);

