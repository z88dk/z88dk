
/*
/* execv: function to chain to another C-generated com file, with text argument passing.
/*
/* Calling sequence:
/*	 execv(prog, args);
/*	 char *prog, char *args[];
/*
/* where
/*	 prog is the name of the program being executed next
/*	 args is a NULL terminated string array, with the 'prog' command on top
/*
/*  This function is based on the simplified implementation of execl()
*/

#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int execv(const char *cpm_prog, const char *cpm_args[])
{
	int cpm_argc;
	char cpm_arglist[110];
	
	if (!cpm_args[0])
		return (-1);
	
	if ((!cpm_args[1]) || (!cpm_args[2]))
		return (execl(cpm_prog,""));

	strcpy(cpm_arglist, cpm_args[1]);
	cpm_argc=2;
	
	while (cpm_args[cpm_argc]) {
		strcat(cpm_arglist, " ");
		strcat(cpm_arglist, cpm_args[cpm_argc++]);
	}
	return (execl(cpm_prog,cpm_arglist));
}

