/* preproc.c */
extern void junk(void);
extern char ch(void);
extern char nch(void);
extern char gch(void);
extern void clear(void);
extern char inbyte(void);
extern void vinline(void);
extern void ifline(void);
extern void noiferr(void);
extern void keepch(char c);
extern void preprocess(void);
extern void addmac(void);
extern void delmac(void);
extern char putmac(char c);
extern int findmac(char *sname);
extern void defmac(char *text);
