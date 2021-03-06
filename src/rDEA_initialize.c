#include "rDEA.h"

// rDEA_print: print hook for redirecting GLPKs terminal output
// note: info is not used here
static int rDEA_print(void *info, const char *message){
    Rprintf("%s", message);
    return 1; /* Tell GLPK not to print */
}

// rDEA_initialize is called after loading the dynlib
void rDEA_initialize(void){
  // set print hook for terminal
  glp_term_hook(rDEA_print, NULL);
}

// returns the version of the GLPK callable library
void rDEA_get_engine_version(char **GLPK_version){
  const char *str;
  str = glp_version();
  *GLPK_version = (char *) str;
}
