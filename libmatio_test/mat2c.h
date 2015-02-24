#include <stdlib.h>
#include <stdio.h>
#include "matio.h"

// Get a column from an array
void get_column(double matrix[], double vect[], int col_number, int rows, int cols){
	
	// Extract the column.
	for(int i = 0; i < rows; i++){
		vect[i] = matrix[col_number * rows + i];
	}
}

double* read_mat_spherical_data(char file_path[])
{
	// Declare a pointer to a matlab file
	mat_t *matfp;
	
	// Declare a pointer to a matlab variable
	matvar_t *matvar;
	
	// Declare a 'success' flag
	int success;
	
	// Declare start pointer
	int start = 0;
	
	// Declare stride pointer
	int stride = 1;
	
	// Open a matlab file whose name is passed as a command line argument.
	matfp = Mat_Open(file_path, MAT_ACC_RDONLY);
	
	// Read the first variable.
	matvar = Mat_VarReadNextInfo(matfp);
	
	// Determine the dimensions of the data
	int data_rows  = matvar->dims[0];
	int data_cols  = matvar->dims[1];
	
	// This specifies the number of elements to read
	int number_to_read = data_rows * data_cols;
	
	// This sets up a pointer to point to doubles
	double * data_mat;
	
	// This allocates memory to hold the data.
	data_mat = malloc(number_to_read * sizeof(double));

	// Read the data
	success = Mat_VarReadDataLinear(matfp, matvar, data_mat, start, stride, number_to_read);
	
	// Free the matlab variable.
	Mat_VarFree(matvar);
		
	// Set the matlab variable to NULL
	matvar = NULL;
	
	// Close the matlab file
	Mat_Close(matfp);
	
	// GTFO!
	return data_mat;	
}

int* read_mat_size(char file_path[])
{
	// Declare a pointer to a matlab file
	mat_t *matfp;
	
	// Declare a pointer to a matlab variable
	matvar_t *matvar;
	
	// Allocate memory to hold the size vector
	int *shape;
	
	// Set up shape to point to something
	shape = malloc(2 * sizeof(int));
	
	// Open a matlab file whose name is passed as a command line argument.
	matfp = Mat_Open(file_path, MAT_ACC_RDONLY);
	
	// Read the first variable.
	matvar = Mat_VarReadNextInfo(matfp);
	
	// Determine the dimensions of the data
	shape[0]  = matvar->dims[0];
	shape[1]  = matvar->dims[1];
	
	// Close the matlab file
	Mat_Close(matfp);
	
	// GTFO!
	return shape;	
}












