#include <stdlib.h>
#include <stdio.h>
#include "matio.h"

int main(int argc,char **argv)
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
	matfp = Mat_Open(argv[1], MAT_ACC_RDONLY);
	
	// Bug out if the file wasn't opened.
	if( NULL == matfp){
		fprintf(stderr, "Error opening MAT file \"%s\"!\n ", argv[1]);
		return EXIT_FAILURE;
	}
	
	// Read the first variable.
	matvar = Mat_VarReadNextInfo(matfp);
	
	// Print the variable name.
	printf("Reading %s(", matvar->name);
	
	// Determine the length of the data
	int data_rows = matvar->dims[0];
	int data_cols = matvar->dims[1];
	
	// Print the size of the variable
	printf("[%d, %d]): ", data_rows, data_cols);
	
	// Declare edge pointer
	int edge = data_rows * data_cols;
	
	// Declare the data pointer.
	double data_vect[data_rows * data_cols];
	double data_mat[data_rows][data_cols];
	
	// Read the data
	success = Mat_VarReadDataLinear(matfp, matvar, data_vect, start, stride, edge);
	
	// Print status of the data reading operation
	if(success == 0){
		printf("Success!\n");
	}					
	else{
		printf("Failed!\n");
	}
	
	// Populate the data matrix
	for(int j = 0; j < data_cols; j++){
		for(int i = 0; i < data_rows; i++){
			data_mat[i][j] = data_vect[j * data_rows + i];
		}
	}
	
	// Print out the data.
	for(int i = 0; i < data_rows; i++){
		for(int j = 0; j < data_cols; j++){
			printf("%0.2f\t", data_mat[i][j]);
		}
		printf("\n");
	}
								
	// Free the matlab variable.
	Mat_VarFree(matvar);
		
	// Set the matlab variable to NULL
	matvar = NULL;
	
	// Close the matlab file
	Mat_Close(matfp);
	
	// GTFO
	return EXIT_SUCCESS;
	
}














