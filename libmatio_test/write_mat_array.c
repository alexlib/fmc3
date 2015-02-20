#include <stdlib.h>
#include <stdio.h>
#include "matio.h"

int main(int argc,char **argv)
{
	// Declare a pointer to a mat file.
	mat_t *matfp;
	
	// Declare a pointer to a matlab variable
	matvar_t *matvar;
	
	// Declare a 2-element array called "dims" 
	size_t dims[2] = {10, 1};
	
	// Declare some data
	double x[10] = { 1,  2,  3,  4,  5,  6,  7,  8,  9, 10};
	double y[10] = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20};
	
	// Declare a structure for a matlab complex variable
	struct mat_complex_split_t z = {x, y};
	
	// Create the mat file called "test.mat"
	matfp = Mat_CreateVer(argv[1], NULL, MAT_FT_DEFAULT);
	
	// Bug out if the file wasn't created.
	if( NULL == matfp ){
		fprintf(stderr, "Error creating MAT file \"test.mat\" \n ");
		return EXIT_FAILURE;
	}
	
	// Create a matlab variable named x of type double
	matvar = Mat_VarCreate("x", MAT_C_DOUBLE, MAT_T_DOUBLE, 2, dims, x, 0);
	
	// Bug out if the variable wasn't created.
	if( NULL == matvar ){
		fprintf(stderr, "Error creating variable for 'x'\n");
	}
	else{
		Mat_VarWrite(matfp, matvar, MAT_COMPRESSION_NONE);
		Mat_VarFree(matvar);
	}
	
	// Create a matlab variable named y of type double
	matvar = Mat_VarCreate("y", MAT_C_DOUBLE, MAT_T_DOUBLE, 2, dims, y, 0);
	
	// Bug out if the variable wasn't created.
	if (NULL == matvar ) {
		fprintf(stderr, "Error creating variable for 'y' \n");
	}
	else{
		Mat_VarWrite(matfp, matvar, MAT_COMPRESSION_NONE);
		Mat_VarFree(matvar);
	}
	
	// Create a matlab variable named z of type complex double
	matvar = Mat_VarCreate("z", MAT_C_DOUBLE, MAT_T_DOUBLE, 2, dims, &z, MAT_F_COMPLEX);
	if( NULL == matvar ){
		fprintf(stderr, "Error creating variable for 'z'\n");
	}
	else{
		Mat_VarWrite(matfp, matvar, MAT_COMPRESSION_NONE);
		Mat_VarFree(matvar);
	}
	
	// Close the mat file
	Mat_Close(matfp);
	
	// GTFO
	return EXIT_SUCCESS;
	
}














