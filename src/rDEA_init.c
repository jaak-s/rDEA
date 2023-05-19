#include <R_ext/Rdynload.h>
#include <stdlib.h> // for NULL

/* FIXME:
   Check these declarations against the C/Fortran source code.
*/

/* .C calls */
extern void multi_glp_solve(void *, void *, void *, void *, void *, void *,
                            void *, void *, void *, void *, void *, void *,
                            void *, void *, void *, void *, void *, void *,
                            void *, void *, void *, void *, void *, void *,
                            void *, void *, void *, void *, void *, void *);
extern void rDEA_get_engine_version(void *);
extern void rDEA_initialize(void);

static const R_CMethodDef CEntries[] = {
    {"multi_glp_solve", (DL_FUNC)&multi_glp_solve, 30},
    {"rDEA_get_engine_version", (DL_FUNC)&rDEA_get_engine_version, 1},
    {"rDEA_initialize", (DL_FUNC)&rDEA_initialize, 0},
    {NULL, NULL, 0}};

void R_init_rDEA(DllInfo *dll) {
  R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
