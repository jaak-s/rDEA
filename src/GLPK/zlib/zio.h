/* zio.h (simulation of POSIX low-level I/O functions) */

/* Written by Andrew Makhorin <mao@gnu.org>, June 2013
 * For conditions of distribution and use, see copyright notice in
 * zlib.h */

#ifndef ZIO_H
#define ZIO_H

#include "zsymb.h"

#define O_RDONLY 0x00
#define O_WRONLY 0x01
#define O_CREAT  0x10
#define O_TRUNC  0x20
#define O_APPEND 0x40

int open(const char *path, int oflag, ...);
long read(int fd, void *buf, unsigned long cnt);
long write(int fd, const void *buf, unsigned long cnt);
long lseek(int fd, long offset, int whence);
int close(int fd);

#endif

/* eof */
