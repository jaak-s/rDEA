/* env2.h */

/* (reserved for copyright notice) */

#ifndef ENV2_H
#define ENV2_H

#include "env.h"

typedef struct XFILE XFILE;

#define XEOF (-1)

#define lib_err_msg _glp_lib_err_msg
void lib_err_msg(const char *msg);

#define xerrmsg _glp_lib_xerrmsg
const char *xerrmsg(void);

#define xfopen _glp_lib_xfopen
XFILE *xfopen(const char *fname, const char *mode);

#define xferror _glp_lib_xferror
int xferror(XFILE *file);

#define xfeof _glp_lib_xfeof
int xfeof(XFILE *file);

#define xfgetc _glp_lib_xfgetc
int xfgetc(XFILE *file);

#define xfputc _glp_lib_xfputc
int xfputc(int c, XFILE *file);

#define xfflush _glp_lib_xfflush
int xfflush(XFILE *fp);

#define xfclose _glp_lib_xfclose
int xfclose(XFILE *file);

#define xfprintf _glp_lib_xfprintf
int xfprintf(XFILE *file, const char *fmt, ...);

#endif

/* eof */
