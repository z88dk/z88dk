
#include <rex/rex.h>
#include <rex/WHmath.h>

#define p4            16.1536413
#define p3           268.425482
#define p2          1153.02935154
#define p1          1780.40631643
#define p0           896.78597404
#define q4            58.95697051
#define q3           536.26537403
#define q2          1666.78381488
#define q1          2079.33497445
#define q0           896.78597404

/*
	xatan evaluates a series valid in the
	range [-0.414...,+0.414...].
*/

double xatan(double arg)
{
	double argsq;
	double value;

	argsq = arg*arg;
	value = ((((p4*argsq + p3)*argsq + p2)*argsq + p1)*argsq + p0);
	value = value/(((((argsq + q4)*argsq + q3)*argsq + q2)*argsq + q1)*argsq + q0);
	return(value*arg);
}
