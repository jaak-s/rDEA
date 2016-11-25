/* This is the GLPK C Interface
 */

#include "rDEA.h"
#include <stdio.h>

void set_rhs (glp_prob *lp, int i, int direction, double rhs) {
    switch(direction){
    case 1: 
      glp_set_row_bnds(lp, i+1, GLP_UP, 0.0, rhs);
      break;
    case 2: 
      glp_set_row_bnds(lp, i+1, GLP_UP, 0.0, rhs);
      break;
    case 3: 
      glp_set_row_bnds(lp, i+1, GLP_LO, rhs, 0.0);
      break;
    case 4: 
      glp_set_row_bnds(lp, i+1, GLP_LO, rhs, 0.0);
      break;
    case 5: 
      glp_set_row_bnds(lp, i+1, GLP_FX, rhs, rhs);
      break;
    }
}

// this is the solve function called from R
void multi_glp_solve (int *lp_direction, int *lp_number_of_constraints,
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
          int *lp_verbosity, int *lp_status,
          int *multi_number_of_problems,          // number of problems (0 for standard solve)
          int *multi_number_of_constraint_values, // number of constraints (size of next vector)
          int *multi_constraint_index,     // constraint indices to be changed
          double *multi_constraint_values, // vector of constraint values [constraint_index, problem]
          int *multi_rhs_number_of_values, // number of RHS to be changed (size of next vector)
          int *multi_rhs_index,            // RHS indices to be changed
          double *multi_rhs_values,        // vector of RHS values [rhs_index, problem]
          int *multi_obj_number_of_values, // number of obj to be changed (size of next (index) vector)
          int *multi_obj_index,            // obj indices to be changed
          double *multi_obj_values         // vector of obj values [obj_index, problem]
          ) {

  glp_prob *lp;
  int i, p;
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
    set_rhs(lp, i, lp_direction_of_constraints[i], lp_right_hand_side[i]);
  
  // add columns to the problem object
  glp_add_cols(lp, *lp_number_of_objective_vars);

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
  
  // solving several problems at the same time:
  // lpx_std_basis(lp);

  if (*multi_number_of_problems <= 0) {
    glp_load_matrix(lp, *lp_number_of_values_in_constraint_matrix,
        &lp_constraint_matrix_i[-1],
                    &lp_constraint_matrix_j[-1], &lp_constraint_matrix_values[-1]);

    glp_std_basis(lp);
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
  } else {
    // solving multiple simplex problems with different constraints
    for(p = 0; p < *multi_number_of_problems; p++) {
      // setup rhs
      for(i = 0; i < *multi_rhs_number_of_values; i++) {
        int rhs_var = multi_rhs_index[i];
        double rhs_value = multi_rhs_values[ i + p * (*multi_rhs_number_of_values) ];
        set_rhs(lp, rhs_var, lp_direction_of_constraints[rhs_var], rhs_value);
      }
      
      // setup obj
      for(i = 0; i < *multi_obj_number_of_values; i++) {
        int obj_var = multi_obj_index[i];
        double obj_value = multi_obj_values[ i + p * (*multi_obj_number_of_values) ];
        glp_set_obj_coef(lp, obj_var, obj_value);
      }
      
      // setup variables values to lp_constraint_matrix_value
      for(i = 0; i < *multi_number_of_constraint_values; i++) {
        int c_index = i + p * (*multi_number_of_constraint_values);
        lp_constraint_matrix_values[ multi_constraint_index[i] ] = multi_constraint_values[c_index];
      }
      glp_load_matrix(lp, *lp_number_of_values_in_constraint_matrix,
          &lp_constraint_matrix_i[-1],
          &lp_constraint_matrix_j[-1], &lp_constraint_matrix_values[-1]);

			glp_std_basis(lp);
      // run simplex method to solve linear problem
      glp_simplex(lp, NULL);

      // retrieve status of optimization
      lp_status[p] = glp_get_status(lp);
      // retrieve optimum
      lp_optimum[p] = glp_get_obj_val(lp);
      // retrieve values of objective vars
      int iplus = p * (*lp_number_of_objective_vars);
      for(i = 0; i < *lp_number_of_objective_vars; i++) {
        lp_objective_vars_values[iplus + i] = glp_get_col_prim(lp, i+1);
      }

    }
  }
  /* 
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
  */
  // delete problem object
  glp_delete_prob(lp);
}


