/* lex.c */
extern int streq(char str1[], char str2[]);
extern int astreq(char *str1, char *str2);
extern int match(char *lit);
extern int cmatch(char lit);
extern int acmatch(char lit);
extern int rmatch(char *lit);
extern int rcmatch(char lit);
extern int amatch(char *lit);
extern int swallow(char *lit);
extern int CheckTypDef(void);
