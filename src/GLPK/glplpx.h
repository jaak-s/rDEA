/* glplpx.h (obsolete API routines) */

/***********************************************************************
*  This code is part of GLPK (GNU Linear Programming Kit).
*
*  Copyright (C) 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008,
*  2009, 2010, 2011, 2013 Andrew Makhorin, Department for Applied
*  Informatics, Moscow Aviation Institute, Moscow, Russia. All rights
*  reserved. E-mail: <mao@gnu.org>.
*
*  GLPK is free software: you can redistribute it and/or modify it
*  under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  GLPK is distributed in the hope that it will be useful, but WITHOUT
*  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
*  or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
*  License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with GLPK. If not, see <http://www.gnu.org/licenses/>.
***********************************************************************/

#ifndef GLPLPX_H
#define GLPLPX_H

#define LPX glp_prob

/* problem class: */
#define LPX_LP          100   /* linear programming (LP) */
#define LPX_MIP         101   /* mixed integer programming (MIP) */

/* type of auxiliary/structural variable: */
#define LPX_FR          110   /* free variable */
#define LPX_LO          111   /* variable with lower bound */
#define LPX_UP          112   /* variable with upper bound */
#define LPX_DB          113   /* double-bounded variable */
#define LPX_FX          114   /* fixed variable */

/* optimization direction flag: */
#define LPX_MIN         120   /* minimization */
#define LPX_MAX         121   /* maximization */

/* status of primal basic solution: */
#define LPX_P_UNDEF     132   /* primal solution is undefined */
#define LPX_P_FEAS      133   /* solution is primal feasible */
#define LPX_P_INFEAS    134   /* solution is primal infeasible */
#define LPX_P_NOFEAS    135   /* no primal feasible solution exists */

/* status of dual basic solution: */
#define LPX_D_UNDEF     136   /* dual solution is undefined */
#define LPX_D_FEAS      137   /* solution is dual feasible */
#define LPX_D_INFEAS    138   /* solution is dual infeasible */
#define LPX_D_NOFEAS    139   /* no dual feasible solution exists */

/* status of auxiliary/structural variable: */
#define LPX_BS          140   /* basic variable */
#define LPX_NL          141   /* non-basic variable on lower bound */
#define LPX_NU          142   /* non-basic variable on upper bound */
#define LPX_NF          143   /* non-basic free variable */
#define LPX_NS          144   /* non-basic fixed variable */

/* status of interior-point solution: */
#define LPX_T_UNDEF     150   /* interior solution is undefined */
#define LPX_T_OPT       151   /* interior solution is optimal */

/* kind of structural variable: */
#define LPX_CV          160   /* continuous variable */
#define LPX_IV          161   /* integer variable */

/* status of integer solution: */
#define LPX_I_UNDEF     170   /* integer solution is undefined */
#define LPX_I_OPT       171   /* integer solution is optimal */
#define LPX_I_FEAS      172   /* integer solution is feasible */
#define LPX_I_NOFEAS    173   /* no integer solution exists */

/* status codes reported by the routine lpx_get_status: */
#define LPX_OPT         180   /* optimal */
#define LPX_FEAS        181   /* feasible */
#define LPX_INFEAS      182   /* infeasible */
#define LPX_NOFEAS      183   /* no feasible */
#define LPX_UNBND       184   /* unbounded */
#define LPX_UNDEF       185   /* undefined */

/* exit codes returned by solver routines: */
#define LPX_E_OK        200   /* success */
#define LPX_E_EMPTY     201   /* empty problem */
#define LPX_E_BADB      202   /* invalid initial basis */
#define LPX_E_INFEAS    203   /* infeasible initial solution */
#define LPX_E_FAULT     204   /* unable to start the search */
#define LPX_E_OBJLL     205   /* objective lower limit reached */
#define LPX_E_OBJUL     206   /* objective upper limit reached */
#define LPX_E_ITLIM     207   /* iterations limit exhausted */
#define LPX_E_TMLIM     208   /* time limit exhausted */
#define LPX_E_NOFEAS    209   /* no feasible solution */
#define LPX_E_INSTAB    210   /* numerical instability */
#define LPX_E_SING      211   /* problems with basis matrix */
#define LPX_E_NOCONV    212   /* no convergence (interior) */
#define LPX_E_NOPFS     213   /* no primal feas. sol. (LP presolver) */
#define LPX_E_NODFS     214   /* no dual feas. sol. (LP presolver) */
#define LPX_E_MIPGAP    215   /* relative mip gap tolerance reached */

/* control parameter identifiers: */
#define LPX_K_MSGLEV    300   /* lp->msg_lev */
#define LPX_K_SCALE     301   /* lp->scale */
#define LPX_K_DUAL      302   /* lp->dual */
#define LPX_K_PRICE     303   /* lp->price */
#define LPX_K_RELAX     304   /* lp->relax */
#define LPX_K_TOLBND    305   /* lp->tol_bnd */
#define LPX_K_TOLDJ     306   /* lp->tol_dj */
#define LPX_K_TOLPIV    307   /* lp->tol_piv */
#define LPX_K_ROUND     308   /* lp->round */
#define LPX_K_OBJLL     309   /* lp->obj_ll */
#define LPX_K_OBJUL     310   /* lp->obj_ul */
#define LPX_K_ITLIM     311   /* lp->it_lim */
#define LPX_K_ITCNT     312   /* lp->it_cnt */
#define LPX_K_TMLIM     313   /* lp->tm_lim */
#define LPX_K_OUTFRQ    314   /* lp->out_frq */
#define LPX_K_OUTDLY    315   /* lp->out_dly */
#define LPX_K_BRANCH    316   /* lp->branch */
#define LPX_K_BTRACK    317   /* lp->btrack */
#define LPX_K_TOLINT    318   /* lp->tol_int */
#define LPX_K_TOLOBJ    319   /* lp->tol_obj */
#define LPX_K_MPSINFO   320   /* lp->mps_info */
#define LPX_K_MPSOBJ    321   /* lp->mps_obj */
#define LPX_K_MPSORIG   322   /* lp->mps_orig */
#define LPX_K_MPSWIDE   323   /* lp->mps_wide */
#define LPX_K_MPSFREE   324   /* lp->mps_free */
#define LPX_K_MPSSKIP   325   /* lp->mps_skip */
#define LPX_K_LPTORIG   326   /* lp->lpt_orig */
#define LPX_K_PRESOL    327   /* lp->presol */
#define LPX_K_BINARIZE  328   /* lp->binarize */
#define LPX_K_USECUTS   329   /* lp->use_cuts */
#define LPX_K_BFTYPE    330   /* lp->bfcp->type */
#define LPX_K_MIPGAP    331   /* lp->mip_gap */

#define LPX_C_COVER     0x01  /* mixed cover cuts */
#define LPX_C_CLIQUE    0x02  /* clique cuts */
#define LPX_C_GOMORY    0x04  /* Gomory's mixed integer cuts */
#define LPX_C_MIR       0x08  /* mixed integer rounding cuts */
#define LPX_C_ALL       0xFF  /* all cuts */

typedef struct
{     /* this structure contains results reported by the routines which
         checks Karush-Kuhn-Tucker conditions (for details see comments
         to those routines) */
      /*--------------------------------------------------------------*/
      /* xR - A * xS = 0 (KKT.PE) */
      double pe_ae_max;
      /* largest absolute error */
      int    pe_ae_row;
      /* number of row with largest absolute error */
      double pe_re_max;
      /* largest relative error */
      int    pe_re_row;
      /* number of row with largest relative error */
      int    pe_quality;
      /* quality of primal solution:
         'H' - high
         'M' - medium
         'L' - low
         '?' - primal solution is wrong */
      /*--------------------------------------------------------------*/
      /* l[k] <= x[k] <= u[k] (KKT.PB) */
      double pb_ae_max;
      /* largest absolute error */
      int    pb_ae_ind;
      /* number of variable with largest absolute error */
      double pb_re_max;
      /* largest relative error */
      int    pb_re_ind;
      /* number of variable with largest relative error */
      int    pb_quality;
      /* quality of primal feasibility:
         'H' - high
         'M' - medium
         'L' - low
         '?' - primal solution is infeasible */
      /*--------------------------------------------------------------*/
      /* A' * (dR - cR) + (dS - cS) = 0 (KKT.DE) */
      double de_ae_max;
      /* largest absolute error */
      int    de_ae_col;
      /* number of column with largest absolute error */
      double de_re_max;
      /* largest relative error */
      int    de_re_col;
      /* number of column with largest relative error */
      int    de_quality;
      /* quality of dual solution:
         'H' - high
         'M' - medium
         'L' - low
         '?' - dual solution is wrong */
      /*--------------------------------------------------------------*/
      /* d[k] >= 0 or d[k] <= 0 (KKT.DB) */
      double db_ae_max;
      /* largest absolute error */
      int    db_ae_ind;
      /* number of variable with largest absolute error */
      double db_re_max;
      /* largest relative error */
      int    db_re_ind;
      /* number of variable with largest relative error */
      int    db_quality;
      /* quality of dual feasibility:
         'H' - high
         'M' - medium
         'L' - low
         '?' - dual solution is infeasible */
      /*--------------------------------------------------------------*/
      /* (x[k] - bound of x[k]) * d[k] = 0 (KKT.CS) */
      double cs_ae_max;
      /* largest absolute error */
      int    cs_ae_ind;
      /* number of variable with largest absolute error */
      double cs_re_max;
      /* largest relative error */
      int    cs_re_ind;
      /* number of variable with largest relative error */
      int    cs_quality;
      /* quality of complementary slackness:
         'H' - high
         'M' - medium
         'L' - low
         '?' - primal and dual solutions are not complementary */
} LPXKKT;

#define lpx_create_prob _glp_lpx_create_prob
LPX *lpx_create_prob(void);
/* create problem object */

#define lpx_set_prob_name _glp_lpx_set_prob_name
void lpx_set_prob_name(LPX *lp, const char *name);
/* assign (change) problem name */

#define lpx_set_obj_name _glp_lpx_set_obj_name
void lpx_set_obj_name(LPX *lp, const char *name);
/* assign (change) objective function name */

#define lpx_set_obj_dir _glp_lpx_set_obj_dir
void lpx_set_obj_dir(LPX *lp, int dir);
/* set (change) optimization direction flag */

#define lpx_add_rows _glp_lpx_add_rows
int lpx_add_rows(LPX *lp, int nrs);
/* add new rows to problem object */

#define lpx_add_cols _glp_lpx_add_cols
int lpx_add_cols(LPX *lp, int ncs);
/* add new columns to problem object */

#define lpx_set_row_name _glp_lpx_set_row_name
void lpx_set_row_name(LPX *lp, int i, const char *name);
/* assign (change) row name */

#define lpx_set_col_name _glp_lpx_set_col_name
void lpx_set_col_name(LPX *lp, int j, const char *name);
/* assign (change) column name */

#define lpx_set_row_bnds _glp_lpx_set_row_bnds
void lpx_set_row_bnds(LPX *lp, int i, int type, double lb, double ub);
/* set (change) row bounds */

#define lpx_set_col_bnds _glp_lpx_set_col_bnds
void lpx_set_col_bnds(LPX *lp, int j, int type, double lb, double ub);
/* set (change) column bounds */

#define lpx_set_obj_coef _glp_lpx_set_obj_coef
void lpx_set_obj_coef(glp_prob *lp, int j, double coef);
/* set (change) obj. coefficient or constant term */

#define lpx_set_mat_row _glp_lpx_set_mat_row
void lpx_set_mat_row(LPX *lp, int i, int len, const int ind[],
      const double val[]);
/* set (replace) row of the constraint matrix */

#define lpx_set_mat_col _glp_lpx_set_mat_col
void lpx_set_mat_col(LPX *lp, int j, int len, const int ind[],
      const double val[]);
/* set (replace) column of the constraint matrix */

#define lpx_load_matrix _glp_lpx_load_matrix
void lpx_load_matrix(LPX *lp, int ne, const int ia[], const int ja[],
      const double ar[]);
/* load (replace) the whole constraint matrix */

#define lpx_del_rows _glp_lpx_del_rows
void lpx_del_rows(LPX *lp, int nrs, const int num[]);
/* delete specified rows from problem object */

#define lpx_del_cols _glp_lpx_del_cols
void lpx_del_cols(LPX *lp, int ncs, const int num[]);
/* delete specified columns from problem object */

#define lpx_delete_prob _glp_lpx_delete_prob
void lpx_delete_prob(LPX *lp);
/* delete problem object */

#define lpx_get_prob_name _glp_lpx_get_prob_name
const char *lpx_get_prob_name(LPX *lp);
/* retrieve problem name */

#define lpx_get_obj_name _glp_lpx_get_obj_name
const char *lpx_get_obj_name(LPX *lp);
/* retrieve objective function name */

#define lpx_get_obj_dir _glp_lpx_get_obj_dir
int lpx_get_obj_dir(LPX *lp);
/* retrieve optimization direction flag */

#define lpx_get_num_rows _glp_lpx_get_num_rows
int lpx_get_num_rows(LPX *lp);
/* retrieve number of rows */

#define lpx_get_num_cols _glp_lpx_get_num_cols
int lpx_get_num_cols(LPX *lp);
/* retrieve number of columns */

#define lpx_get_row_name _glp_lpx_get_row_name
const char *lpx_get_row_name(LPX *lp, int i);
/* retrieve row name */

#define lpx_get_col_name _glp_lpx_get_col_name
const char *lpx_get_col_name(LPX *lp, int j);
/* retrieve column name */

#define lpx_get_row_type _glp_lpx_get_row_type
int lpx_get_row_type(LPX *lp, int i);
/* retrieve row type */

#define lpx_get_row_lb _glp_lpx_get_row_lb
double lpx_get_row_lb(LPX *lp, int i);
/* retrieve row lower bound */

#define lpx_get_row_ub _glp_lpx_get_row_ub
double lpx_get_row_ub(LPX *lp, int i);
/* retrieve row upper bound */

#define lpx_get_row_bnds _glp_lpx_get_row_bnds
void lpx_get_row_bnds(LPX *lp, int i, int *typx, double *lb,
      double *ub);
/* retrieve row bounds */

#define lpx_get_col_type _glp_lpx_get_col_type
int lpx_get_col_type(LPX *lp, int j);
/* retrieve column type */

#define lpx_get_col_lb _glp_lpx_get_col_lb
double lpx_get_col_lb(LPX *lp, int j);
/* retrieve column lower bound */

#define lpx_get_col_ub _glp_lpx_get_col_ub
double lpx_get_col_ub(LPX *lp, int j);
/* retrieve column upper bound */

#define lpx_get_col_bnds _glp_lpx_get_col_bnds
void lpx_get_col_bnds(LPX *lp, int j, int *typx, double *lb,
      double *ub);
/* retrieve column bounds */

#define lpx_get_obj_coef _glp_lpx_get_obj_coef
double lpx_get_obj_coef(LPX *lp, int j);
/* retrieve obj. coefficient or constant term */

#define lpx_get_num_nz _glp_lpx_get_num_nz
int lpx_get_num_nz(LPX *lp);
/* retrieve number of constraint coefficients */

#define lpx_get_mat_row _glp_lpx_get_mat_row
int lpx_get_mat_row(LPX *lp, int i, int ind[], double val[]);
/* retrieve row of the constraint matrix */

#define lpx_get_mat_col _glp_lpx_get_mat_col
int lpx_get_mat_col(LPX *lp, int j, int ind[], double val[]);
/* retrieve column of the constraint matrix */

#define lpx_create_index _glp_lpx_create_index
void lpx_create_index(LPX *lp);
/* create the name index */

#define lpx_find_row _glp_lpx_find_row
int lpx_find_row(LPX *lp, const char *name);
/* find row by its name */

#define lpx_find_col _glp_lpx_find_col
int lpx_find_col(LPX *lp, const char *name);
/* find column by its name */

#define lpx_delete_index _glp_lpx_delete_index
void lpx_delete_index(LPX *lp);
/* delete the name index */

#define lpx_scale_prob _glp_lpx_scale_prob
void lpx_scale_prob(LPX *lp);
/* scale problem data */

#define lpx_unscale_prob _glp_lpx_unscale_prob
void lpx_unscale_prob(LPX *lp);
/* unscale problem data */

#define lpx_set_row_stat _glp_lpx_set_row_stat
void lpx_set_row_stat(LPX *lp, int i, int stat);
/* set (change) row status */

#define lpx_set_col_stat _glp_lpx_set_col_stat
void lpx_set_col_stat(LPX *lp, int j, int stat);
/* set (change) column status */

#define lpx_std_basis _glp_lpx_std_basis
void lpx_std_basis(LPX *lp);
/* construct standard initial LP basis */

#define lpx_adv_basis _glp_lpx_adv_basis
void lpx_adv_basis(LPX *lp);
/* construct advanced initial LP basis */

#define lpx_cpx_basis _glp_lpx_cpx_basis
void lpx_cpx_basis(LPX *lp);
/* construct Bixby's initial LP basis */

#define lpx_simplex _glp_lpx_simplex
int lpx_simplex(LPX *lp);
/* easy-to-use driver to the simplex method */

#define lpx_exact _glp_lpx_exact
int lpx_exact(LPX *lp);
/* easy-to-use driver to the exact simplex method */

#define lpx_get_status _glp_lpx_get_status
int lpx_get_status(LPX *lp);
/* retrieve generic status of basic solution */

#define lpx_get_prim_stat _glp_lpx_get_prim_stat
int lpx_get_prim_stat(LPX *lp);
/* retrieve primal status of basic solution */

#define lpx_get_dual_stat _glp_lpx_get_dual_stat
int lpx_get_dual_stat(LPX *lp);
/* retrieve dual status of basic solution */

#define lpx_get_obj_val _glp_lpx_get_obj_val
double lpx_get_obj_val(LPX *lp);
/* retrieve objective value (basic solution) */

#define lpx_get_row_stat _glp_lpx_get_row_stat
int lpx_get_row_stat(LPX *lp, int i);
/* retrieve row status (basic solution) */

#define lpx_get_row_prim _glp_lpx_get_row_prim
double lpx_get_row_prim(LPX *lp, int i);
/* retrieve row primal value (basic solution) */

#define lpx_get_row_dual _glp_lpx_get_row_dual
double lpx_get_row_dual(LPX *lp, int i);
/* retrieve row dual value (basic solution) */

#define lpx_get_row_info _glp_lpx_get_row_info
void lpx_get_row_info(LPX *lp, int i, int *tagx, double *vx,
      double *dx);
/* obtain row solution information */

#define lpx_get_col_stat _glp_lpx_get_col_stat
int lpx_get_col_stat(LPX *lp, int j);
/* retrieve column status (basic solution) */

#define lpx_get_col_prim _glp_lpx_get_col_prim
double lpx_get_col_prim(LPX *lp, int j);
/* retrieve column primal value (basic solution) */

#define lpx_get_col_dual _glp_lpx_get_col_dual
double lpx_get_col_dual(glp_prob *lp, int j);
/* retrieve column dual value (basic solution) */

#define lpx_get_col_info _glp_lpx_get_col_info
void lpx_get_col_info(LPX *lp, int j, int *tagx, double *vx,
      double *dx);
/* obtain column solution information (obsolete) */

#define lpx_get_ray_info _glp_lpx_get_ray_info
int lpx_get_ray_info(LPX *lp);
/* determine what causes primal unboundness */

#define lpx_check_kkt _glp_lpx_check_kkt
void lpx_check_kkt(LPX *lp, int scaled, LPXKKT *kkt);
/* check Karush-Kuhn-Tucker conditions */

#define lpx_warm_up _glp_lpx_warm_up
int lpx_warm_up(LPX *lp);
/* "warm up" LP basis */

#define lpx_eval_tab_row _glp_lpx_eval_tab_row
int lpx_eval_tab_row(LPX *lp, int k, int ind[], double val[]);
/* compute row of the simplex table */

#define lpx_eval_tab_col _glp_lpx_eval_tab_col
int lpx_eval_tab_col(LPX *lp, int k, int ind[], double val[]);
/* compute column of the simplex table */

#define lpx_transform_row _glp_lpx_transform_row
int lpx_transform_row(LPX *lp, int len, int ind[], double val[]);
/* transform explicitly specified row */

#define lpx_transform_col _glp_lpx_transform_col
int lpx_transform_col(LPX *lp, int len, int ind[], double val[]);
/* transform explicitly specified column */

#define lpx_prim_ratio_test _glp_lpx_prim_ratio_test
int lpx_prim_ratio_test(LPX *lp, int len, const int ind[],
      const double val[], int how, double tol);
/* perform primal ratio test */

#define lpx_dual_ratio_test _glp_lpx_dual_ratio_test
int lpx_dual_ratio_test(LPX *lp, int len, const int ind[],
      const double val[], int how, double tol);
/* perform dual ratio test */

#define lpx_interior _glp_lpx_interior
int lpx_interior(LPX *lp);
/* easy-to-use driver to the interior point method */

#define lpx_ipt_status _glp_lpx_ipt_status
int lpx_ipt_status(LPX *lp);
/* retrieve status of interior-point solution */

#define lpx_ipt_obj_val _glp_lpx_ipt_obj_val
double lpx_ipt_obj_val(LPX *lp);
/* retrieve objective value (interior point) */

#define lpx_ipt_row_prim _glp_lpx_ipt_row_prim
double lpx_ipt_row_prim(LPX *lp, int i);
/* retrieve row primal value (interior point) */

#define lpx_ipt_row_dual _glp_lpx_ipt_row_dual
double lpx_ipt_row_dual(LPX *lp, int i);
/* retrieve row dual value (interior point) */

#define lpx_ipt_col_prim _glp_lpx_ipt_col_prim
double lpx_ipt_col_prim(LPX *lp, int j);
/* retrieve column primal value (interior point) */

#define lpx_ipt_col_dual _glp_lpx_ipt_col_dual
double lpx_ipt_col_dual(LPX *lp, int j);
/* retrieve column dual value (interior point) */

#define lpx_set_class _glp_lpx_set_class
void lpx_set_class(LPX *lp, int klass);
/* set problem class */

#define lpx_get_class _glp_lpx_get_class
int lpx_get_class(LPX *lp);
/* determine problem klass */

#define lpx_set_col_kind _glp_lpx_set_col_kind
void lpx_set_col_kind(LPX *lp, int j, int kind);
/* set (change) column kind */

#define lpx_get_col_kind _glp_lpx_get_col_kind
int lpx_get_col_kind(LPX *lp, int j);
/* retrieve column kind */

#define lpx_get_num_int _glp_lpx_get_num_int
int lpx_get_num_int(LPX *lp);
/* retrieve number of integer columns */

#define lpx_get_num_bin _glp_lpx_get_num_bin
int lpx_get_num_bin(LPX *lp);
/* retrieve number of binary columns */

#define lpx_integer _glp_lpx_integer
int lpx_integer(LPX *lp);
/* easy-to-use driver to the branch-and-bound method */

#define lpx_intopt _glp_lpx_intopt
int lpx_intopt(LPX *lp);
/* easy-to-use driver to the branch-and-bound method */

#define lpx_mip_status _glp_lpx_mip_status
int lpx_mip_status(LPX *lp);
/* retrieve status of MIP solution */

#define lpx_mip_obj_val _glp_lpx_mip_obj_val
double lpx_mip_obj_val(LPX *lp);
/* retrieve objective value (MIP solution) */

#define lpx_mip_row_val _glp_lpx_mip_row_val
double lpx_mip_row_val(LPX *lp, int i);
/* retrieve row value (MIP solution) */

#define lpx_mip_col_val _glp_lpx_mip_col_val
double lpx_mip_col_val(LPX *lp, int j);
/* retrieve column value (MIP solution) */

#define lpx_check_int _glp_lpx_check_int
void lpx_check_int(LPX *lp, LPXKKT *kkt);
/* check integer feasibility conditions */

#define lpx_reset_parms _glp_lpx_reset_parms
void lpx_reset_parms(LPX *lp);
/* reset control parameters to default values */

#define lpx_set_int_parm _glp_lpx_set_int_parm
void lpx_set_int_parm(LPX *lp, int parm, int val);
/* set (change) integer control parameter */

#define lpx_get_int_parm _glp_lpx_get_int_parm
int lpx_get_int_parm(LPX *lp, int parm);
/* query integer control parameter */

#define lpx_set_real_parm _glp_lpx_set_real_parm
void lpx_set_real_parm(LPX *lp, int parm, double val);
/* set (change) real control parameter */

#define lpx_get_real_parm _glp_lpx_get_real_parm
double lpx_get_real_parm(LPX *lp, int parm);
/* query real control parameter */

#define lpx_read_mps _glp_lpx_read_mps
LPX *lpx_read_mps(const char *fname);
/* read problem data in fixed MPS format */

#define lpx_write_mps _glp_lpx_write_mps
int lpx_write_mps(LPX *lp, const char *fname);
/* write problem data in fixed MPS format */

#define lpx_read_bas _glp_lpx_read_bas
int lpx_read_bas(LPX *lp, const char *fname);
/* read LP basis in fixed MPS format */

#define lpx_write_bas _glp_lpx_write_bas
int lpx_write_bas(LPX *lp, const char *fname);
/* write LP basis in fixed MPS format */

#define lpx_read_freemps _glp_lpx_read_freemps
LPX *lpx_read_freemps(const char *fname);
/* read problem data in free MPS format */

#define lpx_write_freemps _glp_lpx_write_freemps
int lpx_write_freemps(LPX *lp, const char *fname);
/* write problem data in free MPS format */

#define lpx_read_cpxlp _glp_lpx_read_cpxlp
LPX *lpx_read_cpxlp(const char *fname);
/* read problem data in CPLEX LP format */

#define lpx_write_cpxlp _glp_lpx_write_cpxlp
int lpx_write_cpxlp(LPX *lp, const char *fname);
/* write problem data in CPLEX LP format */

#define lpx_read_model _glp_lpx_read_model
LPX *lpx_read_model(const char *model, const char *data,
      const char *output);
/* read LP/MIP model written in GNU MathProg language */

#define lpx_print_prob _glp_lpx_print_prob
int lpx_print_prob(LPX *lp, const char *fname);
/* write problem data in plain text format */

#define lpx_print_sol _glp_lpx_print_sol
int lpx_print_sol(LPX *lp, const char *fname);
/* write LP problem solution in printable format */

#define lpx_print_sens_bnds _glp_lpx_print_sens_bnds
int lpx_print_sens_bnds(LPX *lp, const char *fname);
/* write bounds sensitivity information */

#define lpx_print_ips _glp_lpx_print_ips
int lpx_print_ips(LPX *lp, const char *fname);
/* write interior point solution in printable format */

#define lpx_print_mip _glp_lpx_print_mip
int lpx_print_mip(LPX *lp, const char *fname);
/* write MIP problem solution in printable format */

#define lpx_is_b_avail _glp_lpx_is_b_avail
int lpx_is_b_avail(LPX *lp);
/* check if LP basis is available */

#define lpx_write_pb _glp_lpx_write_pb
int lpx_write_pb(LPX *lp, const char *fname, int normalized,
      int binarize);
/* write problem data in (normalized) OPB format */

#define lpx_main _glp_lpx_main
int lpx_main(int argc, const char *argv[]);
/* stand-alone LP/MIP solver */

#endif

/* eof */
