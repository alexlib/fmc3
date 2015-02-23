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

int read_mat_spherical_data(char file_path[], double data_mat[])
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
	
	// Bug out if the file wasn't opened.
	if( NULL == matfp){
		fprintf(stderr, "Error opening MAT file \"%s\"!\n ", file_path);
		return EXIT_FAILURE;
	}
	
	// Read the first variable.
	matvar = Mat_VarReadNextInfo(matfp);
	
	// Determine the dimensions of the data
	int data_rows  = matvar->dims[0];
	int data_cols  = matvar->dims[1];
	
	// This specifies the number of elements to read
	int number_to_read = data_rows * data_cols;

	// Read and transpose the data
	success = Mat_VarReadDataLinear(matfp, matvar, data_mat, start, stride, number_to_read);
	
	// Print status of the data reading operation
	if(success != 0){
		return EXIT_FAILURE;
	}					
	
	// Free the matlab variable.
	Mat_VarFree(matvar);
		
	// Set the matlab variable to NULL
	matvar = NULL;
	
	// Close the matlab file
	Mat_Close(matfp);
	
	// GTFO!
	return EXIT_SUCCESS;
		
}

int main(int argc, char *argv[]){
	
	// Read the file path
	char *file_path = argv[1];
	
	// Read the column number
	int col_num = atoi(argv[2]);
	
	// Declare a pointer to a matlab file
	mat_t *matfp;
	
	// Declare a pointer to a matlab variable
	matvar_t *matvar;
	
	// Declare a success/failure flag
	int success;
	
	// Open a matlab file whose name is passed as a command line argument.
	matfp = Mat_Open(file_path, MAT_ACC_RDONLY);
	
	// Bug out if the file wasn't opened.
	if( NULL == matfp){
		fprintf(stderr, "Error opening MAT file \"%s\"!\n ", file_path);
		return EXIT_FAILURE;
	}
	
	// Read the first variable.
	matvar = Mat_VarReadNextInfo(matfp);
	
	// Determine the dimensions of the data
	int data_rows  = matvar->dims[0];
	int data_cols  = matvar->dims[1];
	
	// Print the variable name.
	printf("\nReading variable \"%s\" ([%d, %d])\n\n", matvar->name, data_rows, data_cols);
		
	// Declare a pointer to double to hold the data matrix
	double data_mat[data_rows * data_cols];
	
	//Declare an array of doubles to hold the column.
	double data_vect[data_rows];
	
	// Run the data-grabbing function.
	success = read_mat_spherical_data(file_path, data_mat);
	
	// Extract the column
	get_column(data_mat, data_vect, col_num, data_rows, data_cols);
	
	// Print the column number
	printf("Column %d:\n", col_num);
	
	// Print the column.
	for(int i = 0; i < data_rows; i ++){
		printf("%f\n", data_vect[i]);
	}
	
	// New line
	printf("\n");
	
	// Fail on failure
	if(success != 0){
		printf("Function failed!\n");
	}
	
	// GTFO!
	return EXIT_SUCCESS;
	
}












