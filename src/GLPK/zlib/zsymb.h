/* zsymb.h */

/* Written by Andrew Makhorin <mao@gnu.org>, June 2013
 * For conditions of distribution and use, see copyright notice in
 * zlib.h */

#ifndef ZSYMB_H
#define ZSYMB_H

/* (adler32.c) */
#define adler32               zlib_adler32
#define adler32_combine       zlib_adler32_combine
#define adler32_combine64     zlib_adler32_combine64

/* (compress.c) */
#define compress2             zlib_compress2
#define compress              zlib_compress
#define compressBound         zlib_compressBound

/* (crc32.c) */
#define get_crc_table         zlib_get_crc_table
#define crc32                 zlib_crc32
#define crc32_combine         zlib_crc32_combine
#define crc32_combine64       zlib_crc32_combine64

/* (deflate.c) */
#define deflate_copyright     zlib_deflate_copyright
#define deflateInit_          zlib_deflateInit_
#define deflateInit2_         zlib_deflateInit2_
#define deflateSetDictionary  zlib_deflateSetDictionary
#define deflateResetKeep      zlib_deflateResetKeep
#define deflateReset          zlib_deflateReset
#define deflateSetHeader      zlib_deflateSetHeader
#define deflatePending        zlib_deflatePending
#define deflatePrime          zlib_deflatePrime
#define deflateParams         zlib_deflateParams
#define deflateTune           zlib_deflateTune
#define deflateBound          zlib_deflateBound
#define deflate               zlib_deflate
#define deflateEnd            zlib_deflateEnd
#define deflateCopy           zlib_deflateCopy

/* (gzclose.c) */
#define gzclose               zlib_gzclose

/* (gzlib.c) */
#define gzopen                zlib_gzopen
#define gzopen64              zlib_gzopen64
#define gzdopen               zlib_gzdopen
#define gzbuffer              zlib_gzbuffer
#define gzrewind              zlib_gzrewind
#define gzseek64              zlib_gzseek64
#define gzseek                zlib_gzseek
#define gztell64              zlib_gztell64
#define gztell                zlib_gztell
#define gzoffset64            zlib_gzoffset64
#define gzoffset              zlib_gzoffset
#define gzeof                 zlib_gzeof
#define gzerror               zlib_gzerror
#define gzclearerr            zlib_gzclearerr
#define gz_error              zlib_gz_error

/* (gzread.c) */
#define gzread                zlib_gzread
#define gzgetc                zlib_gzgetc
#define gzungetc              zlib_gzungetc
#define gzgets                zlib_gzgets
#define gzdirect              zlib_gzdirect
#define gzclose_r             zlib_gzclose_r

/* (gzwrite.c) */
#define gzwrite               zlib_gzwrite
#define gzputc                zlib_gzputc
#define gzputs                zlib_gzputs
#define gzprintf              zlib_gzprintf
#define gzflush               zlib_gzflush
#define gzsetparams           zlib_gzsetparams
#define gzclose_w             zlib_gzclose_w

/* (inffast.c) */
#define inflate_fast          zlib_inflate_fast

/* (inflate.c) */
#define inflate_copyright     zlib_inflate_copyright
#define inflateResetKeep      zlib_inflateResetKeep
#define inflateReset          zlib_inflateReset
#define inflateReset2         zlib_inflateReset2
#define inflateInit2_         zlib_inflateInit2_
#define inflateInit_          zlib_inflateInit_
#define inflatePrime          zlib_inflatePrime
#define inflate               zlib_inflate
#define inflateEnd            zlib_inflateEnd
#define inflateSetDictionary  zlib_inflateSetDictionary
#define inflateGetHeader      zlib_inflateGetHeader
#define inflateSync           zlib_inflateSync
#define inflateSyncPoint      zlib_inflateSyncPoint
#define inflateCopy           zlib_inflateCopy
#define inflateUndermine      zlib_inflateUndermine
#define inflateMark           zlib_inflateMark

/* (inftrees.c) */
#define inflate_table         zlib_inflate_table

/* (trees.c) */
#define _dist_code            zlib_dist_code
#define _length_code          zlib_length_code
#define _tr_init              zlib_tr_init
#define _tr_stored_block      zlib_tr_stored_block
#define _tr_flush_bits        zlib_tr_flush_bits
#define _tr_align             zlib_tr_align
#define _tr_flush_block       zlib_tr_flush_block
#define _tr_tally             zlib_tr_tally

/* (uncompr.c) */
#define uncompress            zlib_uncompress

/* (zio.c) */
#define open                  zlib_open
#define read                  zlib_read
#define write                 zlib_write
#define lseek                 zlib_lseek
#define close                 zlib_close

/* (zutil.c) */
#define z_errmsg              zlib_z_errmsg
#define zlibVersion           zlib_zlibVersion
#define zlibCompileFlags      zlib_zlibCompileFlags
#define z_error               zlib_z_error
#define zError                zlib_zError
#define zcalloc               zlib_zcalloc
#define zcfree                zlib_zcfree

#endif

/* eof */
