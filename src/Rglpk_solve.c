/* This is the GLPK C Interface
 */

#include "Rglpk.h"
#include <stdio.h>

// this is the solve function called from R
void R_glp_solve (int *lp_direction, int *lp_number_of_constraints,
		  int *lp_direction_of_constraints, double *lp_right_hand_side,
		  int *lp_number_of_objective_vars,
		  double *lp_objective_coefficients,
		  int *lp_objective_var_is_integer, 
		  int *lp_objective_var_is_binary,
		  int *lp_is_integer,                     //should be boolean
		  int *lp_number_of_values_in_constraint_matrix,
		  int *lp_constraint_matrix_i, int *lp_constraint_matrix_j,
		  double *lp_constraint_matrix_values,
		  int *lp_bounds_type, double *lp_bounds_lower,
		  double *lp_bounds_upper,
		  double *lp_optimum,
		  double *lp_objective_vars_values,
		  int *lp_verbosity, int *lp_status) {

  glp_prob *lp;
  int i, kl, ku;
  // create problem object 
  lp = glp_create_prob();

  // Turn on/off Terminal Output
  if(*lp_verbosity==1)
    glp_term_out(GLP_ON);
  else
    glp_term_out(GLP_OFF);
  
  // direction of optimization
  if(*lp_direction==1)
    glp_set_obj_dir(lp, GLP_MAX);
  else
    glp_set_obj_dir(lp, GLP_MIN);
  
  // is it a mixed integer problem? -- seems to be an R glpk function
    //if(lp_integer)
      //lpx_set_class(lp, LPX_MIP);
  // add rows to the problem object
  glp_add_rows(lp, *lp_number_of_constraints);
  for(i = 0; i < *lp_number_of_constraints; i++)
    switch(lp_direction_of_constraints[i]){
    case 1: 
      glp_set_row_bnds(lp, i+1, GLP_UP, 0.0, lp_right_hand_side[i]);
      break;
    case 2: 
      glp_set_row_bnds(lp, i+1, GLP_UP, 0.0, lp_right_hand_side[i]);
      break;
    case 3: 
      glp_set_row_bnds(lp, i+1, GLP_LO, lp_right_hand_side[i], 0.0);
      break;
    case 4: 
      glp_set_row_bnds(lp, i+1, GLP_LO, lp_right_hand_side[i], 0.0);
      break;
    case 5: 
      glp_set_row_bnds(lp, i+1, GLP_FX, lp_right_hand_side[i],
		       lp_right_hand_side[i]);
      break;
    }
  
  // add columns to the problem object
  glp_add_cols(lp, *lp_number_of_objective_vars);
  kl = ku = 0;
  for(i = 0; i < *lp_number_of_objective_vars; i++) {
    glp_set_col_bnds(lp, i+1, lp_bounds_type[i], lp_bounds_lower[i], lp_bounds_upper[i]);
    // set objective coefficients and integer if necessary
    glp_set_obj_coef(lp, i+1, lp_objective_coefficients[i]);
    if (lp_objective_var_is_integer[i])
      glp_set_col_kind(lp, i+1, GLP_IV);
    if (lp_objective_var_is_binary[i])
      glp_set_col_kind(lp, i+1, GLP_BV);
  }
  // load the matrix
  // IMPORTANT: as glp_load_matrix requires triplets as vectors of the
  // form: ia[1] ... ia[n], we have to pass the pointer to the adress
  // [-1] of the corresponding vector 

  glp_load_matrix(lp, *lp_number_of_values_in_constraint_matrix,
		  &lp_constraint_matrix_i[-1],
                  &lp_constraint_matrix_j[-1], &lp_constraint_matrix_values[-1]);

  // run simplex method to solve linear problem
  glp_simplex(lp, NULL);
  
  // retrieve status of optimization
  *lp_status = glp_get_status(lp);
  // retrieve optimum
  *lp_optimum = glp_get_obj_val(lp);
  // retrieve values of objective vars
  for(i = 0; i < *lp_number_of_objective_vars; i++) {
    lp_objective_vars_values[i] = glp_get_col_prim(lp, i+1);
  }
  if(*lp_is_integer) {
    glp_intopt(lp, NULL);
    // retrieve status of optimization
    *lp_status = glp_mip_status(lp);
    
    // retrieve MIP optimum
    *lp_optimum = glp_mip_obj_val(lp);
    // retrieve MIP values of objective vars
    for(i = 0; i < *lp_number_of_objective_vars; i++){
      lp_objective_vars_values[i] = glp_mip_col_val(lp, i+1);
    }
  }
  // delete problem object
  glp_delete_prob(lp);
}


