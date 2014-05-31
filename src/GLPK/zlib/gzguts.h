/* gzguts.h */

/* Modified by Andrew Makhorin <mao@gnu.org>, June 2013. */
/* For original code see <zlib-1.2.7/gzguts.h>. */

/* gzguts.h -- zlib internal header definitions for gz* operations
 * Copyright (C) 2004, 2005, 2010, 2011, 2012 Mark Adler
 * For conditions of distribution and use, see copyright notice in zlib.h
 */

#include <errno.h>
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "zio.h"
#include "zlib.h"

/* get errno and strerror definition */
#define zstrerror() strerror(errno)

gzFile gzopen64(const char *, const char *);
z_off64_t gzseek64(gzFile, z_off64_t, int);
z_off64_t gztell64(gzFile);
z_off64_t gzoffset64(gzFile);

/* default memLevel */
#if MAX_MEM_LEVEL >= 8
#  define DEF_MEM_LEVEL 8
#else
#  define DEF_MEM_LEVEL MAX_MEM_LEVEL
#endif

/* default i/o buffer size -- double this for output when reading */
#define GZBUFSIZE 8192

/* gzip modes, also provide a little integrity check on the passed structure */
#define GZ_NONE 0
#define GZ_READ 7247
#define GZ_WRITE 31153
#define GZ_APPEND 1     /* mode set to GZ_WRITE after the file is opened */

/* values for gz_state how */
#define LOOK 0      /* look for a gzip header */
#define COPY 1      /* copy input directly */
#define GZIP 2      /* decompress a gzip stream */

/* internal gzip file state data structure */
typedef struct {
        /* exposed contents for gzgetc() macro */
    struct gzFile_s x;      /* "x" for exposed */
                            /* x.have: number of bytes available at x.next */
                            /* x.next: next output data to deliver or write */
                            /* x.pos: current position in uncompressed data */
        /* used for both reading and writing */
    int mode;               /* see gzip modes above */
    int fd;                 /* file descriptor */
    char *path;             /* path or fd for error messages */
    unsigned size;          /* buffer size, zero if not allocated yet */
    unsigned want;          /* requested buffer size, default is GZBUFSIZE */
    unsigned char *in;      /* input buffer */
    unsigned char *out;     /* output buffer (double-sized when reading) */
    int direct;             /* 0 if processing gzip, 1 if transparent */
        /* just for reading */
    int how;                /* 0: get header, 1: copy, 2: decompress */
    z_off64_t start;        /* where the gzip data started, for rewinding */
    int eof;                /* true if end of input file reached */
    int past;               /* true if read requested past end */
        /* just for writing */
    int level;              /* compression level */
    int strategy;           /* compression strategy */
        /* seek request */
    z_off64_t skip;         /* amount to skip (already rewound if backwards) */
    int seek;               /* true if seek request pending */
        /* error information */
    int err;                /* error code */
    char *msg;              /* error message */
        /* zlib inflate or deflate stream */
    z_stream strm;          /* stream structure in-place (not a pointer) */
} gz_state;
typedef gz_state *gz_statep;

void gz_error (gz_statep, int, const char *);

/* GT_OFF(x), where x is an unsigned value, is true if x > maximum z_off64_t
   value -- needed when comparing unsigned to z_off64_t, which is signed
   (possible z_off64_t types off_t, off64_t, and long are all signed) */
#define GT_OFF(x) (sizeof(int) == sizeof(z_off64_t) && (x) > INT_MAX)

/* eof */
