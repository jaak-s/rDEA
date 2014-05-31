/* zio.c (simulation of POSIX low-level I/O functions) */

/* Written by Andrew Makhorin <mao@gnu.org>, June 2013
 * For conditions of distribution and use, see copyright notice in
 * zlib.h */

#include <assert.h>
#include <stdio.h>
#include "zio.h"

static FILE *file[FOPEN_MAX];

int open(const char *path, int oflag, ...)
{     FILE *f;
      int fd;
      /* see file gzlib.c, function gz_open */
      if (oflag == O_RDONLY)
         f = fopen(path, "rb");
      else if (oflag == (O_WRONLY | O_CREAT | O_TRUNC))
         f = fopen(path, "wb");
      else if (oflag == (O_WRONLY | O_CREAT | O_APPEND))
         f = fopen(path, "ab");
      else
         assert(oflag != oflag);
      if (f == NULL)
         return -1;
      for (fd = 3; fd < FOPEN_MAX; fd++)
         if (file[fd] == NULL) break;
      assert(fd < FOPEN_MAX);
      file[fd] = f;
      return fd;
}

long read(int fd, void *buf, unsigned long cnt)
{     FILE *f;
      assert(3 <= fd && fd < FOPEN_MAX);
      f = file[fd];
      assert(f != NULL);
      cnt = fread(buf, 1, cnt, f);
      if (ferror(f))
         return -1;
      return cnt;
}

long write(int fd, const void *buf, unsigned long cnt)
{     FILE *f;
      assert(3 <= fd && fd < FOPEN_MAX);
      f = file[fd];
      assert(f != NULL);
      cnt = fwrite(buf, 1, cnt, f);
      if (ferror(f))
         return -1;
      if (fflush(f) != 0)
         return -1;
      return cnt;
}

long lseek(int fd, long offset, int whence)
{     FILE *f;
      assert(3 <= fd && fd < FOPEN_MAX);
      f = file[fd];
      assert(f != NULL);
      if (fseek(f, offset, whence) != 0)
         return -1;
      return ftell(f);
}

int close(int fd)
{     FILE *f;
      assert(3 <= fd && fd < FOPEN_MAX);
      f = file[fd];
      assert(f != NULL);
      file[fd] = NULL;
      return fclose(f);
}

/* eof */
