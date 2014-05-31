/* These are the interface functions to GLPK's MPS reader/writer Since
 * 2012-01-11: Rglpk now supports MATHPROG files and retrieves
 * variables names and constraints names. Thanks to Michael Kapler!  
 * 2012-09-06: A fix to random segfaults introduced with the patch by
 * Michael has been contributed by Christian Buchta.
 */

#include "Rglpk.h"
#include <stdio.h>

// pointer to problem object.
static glp_prob *lp = NULL;

// call destructor from the R level to guarantee that data has been
// copied to R data structures.
void Rglpk_delete_prob() {
  extern glp_prob *lp;
  // delete problem object (if any)
  if (lp){
    glp_delete_prob(lp);
    lp = NULL;
  }
  
}

// read in all necessary elements for retrieving the LP/MILP
void Rglpk_read_file (char **file, int *type, 
		      int *lp_direction_of_optimization,
		      int *lp_n_constraints, int *lp_n_objective_vars,
		      int *lp_n_values_in_constraint_matrix,
		      int *lp_n_integer_vars, int *lp_n_binary_vars, 
		      char **lp_prob_name,
		      char **lp_obj_name,
		      int *lp_verbosity) {

  int status;
  extern glp_prob *lp;
  glp_tran *tran;
  const char *str; 
  
  // Turn on/off Terminal Output
  if (*lp_verbosity==1)
    glp_term_out(GLP_ON);
  else
    glp_term_out(GLP_OFF);

  // create problem object 
  if (lp)
    glp_delete_prob(lp);
  lp = glp_create_prob();

  // read file -> gets stored as an GLPK problem object 'lp'
  // which file type do we have?
  switch (*type){
  case 1: 
    // Fixed (ancient) MPS Format, param argument currently NULL
    status = glp_read_mps(lp, GLP_MPS_DECK, NULL, *file);
    break;
  case 2:
    // Free (modern) MPS format, param argument currently NULL
    status = glp_read_mps(lp, GLP_MPS_FILE, NULL, *file);
    break;
  case 3:
    // CPLEX LP Format
    status = glp_read_lp(lp, NULL, *file);
    break;
  case 4:
    // MATHPROG Format (based on lpx_read_model function)
    tran = glp_mpl_alloc_wksp();

    status = glp_mpl_read_model(tran, *file, 0);

    if (!status) {
        status = glp_mpl_generate(tran, NULL);
        if (!status) {
            glp_mpl_build_prob(tran, lp);
        }
    }
    glp_mpl_free_wksp(tran);
    break;    
  } 

  // if file read successfully glp_read_* returns zero
  if ( status != 0 ) {
    glp_delete_prob(lp);
    lp = NULL;
    error("Reading file %s failed", *file);
  }

  // retrieve problem name
  str = glp_get_prob_name(lp);
  if (str){
    *lp_prob_name = (char *) str;
  }

  // retrieve name of objective function
  str = glp_get_obj_name(lp);
  if (str){
    *lp_obj_name = (char *) str;
  }
  
  // retrieve optimization direction flag
  *lp_direction_of_optimization = glp_get_obj_dir(lp);  

  // retrieve number of constraints
  *lp_n_constraints = glp_get_num_rows(lp);  

  // retrieve number of objective variables
  *lp_n_objective_vars = glp_get_num_cols(lp);

  // retrieve number of non-zero elements in constraint matrix
  *lp_n_values_in_constraint_matrix = glp_get_num_nz(lp);

  // retrieve number of integer variables
  *lp_n_integer_vars = glp_get_num_int(lp);
  
  // retrieve number of binary variables
  *lp_n_binary_vars = glp_get_num_bin(lp);
}

// retrieve all missing values of LP/MILP
void Rglpk_retrieve_MP_from_file (char **file, int *type,
				  int *lp_n_constraints,
				  int *lp_n_objective_vars,
				  double *lp_objective_coefficients,
				  int *lp_constraint_matrix_i,
				  int *lp_constraint_matrix_j,
				  double *lp_constraint_matrix_values,
				  int *lp_direction_of_constraints,
				  double *lp_right_hand_side,
				  double *lp_left_hand_side,
				  int *lp_objective_var_is_integer,
				  int *lp_objective_var_is_binary,
				  int *lp_bounds_type,
				  double *lp_bounds_lower,
				  double *lp_bounds_upper,
				  int *lp_ignore_first_row,
				  int *lp_verbosity,
				  char **lp_constraint_names,
				  char **lp_objective_vars_names
				  ) {
  extern glp_prob *lp;
  glp_tran *tran;
  const char *str; 
  
  int i, j, lp_column_kind, tmp;
  int ind_offset, status;

  // Turn on/off Terminal Output
  if (*lp_verbosity==1)
    glp_term_out(GLP_ON);
  else
    glp_term_out(GLP_OFF);

  // create problem object
  if (lp)
    glp_delete_prob(lp);
  lp = glp_create_prob();

  // read file -> gets stored as an GLPK problem object 'lp'
  // which file type do we have?
  switch (*type){
  case 1: 
    // Fixed (ancient) MPS Format, param argument currently NULL
    status = glp_read_mps(lp, GLP_MPS_DECK, NULL, *file);
    break;
  case 2:
    // Free (modern) MPS format, param argument currently NULL
    status = glp_read_mps(lp, GLP_MPS_FILE, NULL, *file);
    break;
  case 3:
    // CPLEX LP Format
    status = glp_read_lp(lp, NULL, *file);
    break;
  case 4:
    // MATHPROG Format (based on lpx_read_model function)
    tran = glp_mpl_alloc_wksp();

    status = glp_mpl_read_model(tran, *file, 0);

    if (!status) {
        status = glp_mpl_generate(tran, NULL);
        if (!status) {
            glp_mpl_build_prob(tran, lp);
        }
    }
    glp_mpl_free_wksp(tran);
    break;    
  } 

  // if file read successfully glp_read_* returns zero
  if ( status != 0 ) {
    glp_delete_prob(lp);
    lp = NULL;
    error("Reading file %c failed.", *file);
  }
  
  if(*lp_verbosity==1)
    Rprintf("Retrieve column specific data ...\n");

  if(glp_get_num_cols(lp) != *lp_n_objective_vars) {
    glp_delete_prob(lp);
    lp = NULL;
    error("The number of columns is not as specified");
  }

  // retrieve column specific data (values, bounds and type)
  for (i = 0; i < *lp_n_objective_vars; i++) {
    lp_objective_coefficients[i] = glp_get_obj_coef(lp, i+1);
    
    // Note that str must not be freed befor we have returned
    // from the .C call in R! 
    str = glp_get_col_name(lp, i+1);    
    if (str){
      lp_objective_vars_names[i] = (char *) str;
    }
    
    lp_bounds_type[i]            = glp_get_col_type(lp, i+1);
    lp_bounds_lower[i]           = glp_get_col_lb  (lp, i+1);
    lp_bounds_upper[i]           = glp_get_col_ub  (lp, i+1);
    lp_column_kind               = glp_get_col_kind(lp, i+1);
    // set to TRUE if objective variable is integer or binary  
    switch (lp_column_kind){
    case GLP_IV: 
      lp_objective_var_is_integer[i] = 1;
      break;
    case GLP_BV:
      lp_objective_var_is_binary[i] = 1;
      break;
    }
  }
  
  ind_offset = 0;

  if(*lp_verbosity==1)
    Rprintf("Retrieve row specific data ...\n");

  if(glp_get_num_rows(lp) != *lp_n_constraints) {
    glp_delete_prob(lp);
    lp = NULL;
    error("The number of rows is not as specified");
  }

  // retrieve row specific data (right hand side, direction of constraints)
  for (i = *lp_ignore_first_row; i < *lp_n_constraints; i++) {
    lp_direction_of_constraints[i] = glp_get_row_type(lp, i+1);
    
    str = glp_get_row_name(lp, i + 1);
    if (str) { 
      lp_constraint_names[i] = (char *) str;
    }
    
    // the right hand side. Note we don't allow for double bounded or
    // free auxiliary variables 
    if( lp_direction_of_constraints[i] == GLP_LO )
      lp_right_hand_side[i] = glp_get_row_lb(lp, i+1);
    if( lp_direction_of_constraints[i] == GLP_UP )
      lp_right_hand_side[i] = glp_get_row_ub(lp, i+1);
    if( lp_direction_of_constraints[i] == GLP_FX )
      lp_right_hand_side[i] = glp_get_row_lb(lp, i+1);
    if( lp_direction_of_constraints[i] == GLP_DB  ){
      lp_right_hand_side[i] = glp_get_row_ub(lp, i+1);
      lp_left_hand_side[i] =  glp_get_row_lb(lp, i+1);
    }

    tmp = glp_get_mat_row(lp, i+1, &lp_constraint_matrix_j[ind_offset-1],
			           &lp_constraint_matrix_values[ind_offset-1]);
    if (tmp > 0)
      for (j = 0; j < tmp; j++)
	lp_constraint_matrix_i[ind_offset+j] = i+1;
	ind_offset += tmp; 
  }
  
  if(*lp_verbosity==1)
    Rprintf("Done.\n");

}

