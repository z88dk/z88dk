
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
extern void setstage(char **before, char **start);
#define clearstage(b,s) clearstage_info(__FILE__,__LINE__,b,s)
extern void clearstage_info(const char *file, int line, char *before, char *start);
extern void fabort(void);
extern void toconsole(void);
extern void tofile(void);
extern int outbyte(char c);
extern int outstage(char c);
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

typedef struct t_buffer_s t_buffer;

struct t_buffer_s {
	t_buffer *before;
	size_t size;
	char *start;
	char *end;
	char *next;
};

extern t_buffer * startbuffer(size_t blocks);
extern void clearbuffer(t_buffer *buf);
extern void suspendbuffer(void);
extern int outbuffer(char c);
extern int bufferlen(t_buffer *buf);
extern t_buffer *currentbuffer;

