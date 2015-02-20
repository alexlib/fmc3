#include <stdlib.h>
#include <stdio.h>
#include "matio.h"

int main(int argc,char **argv)
{
	
	// Declare a mat file pointer
	mat_t *matfp;
	
	// Declare a matlab variable
	matvar_t *matvar;
	
	// Open the mat file
	matfp = Mat_Open(argv[1], MAT_ACC_RDONLY);
	
	// Bug out if the mat file wasn't opened successfully.
	if (NULL == matfp){
		fprintf(stderr, "Error opening MAT file \"%s\"!\n", argv[1]);
		return EXIT_FAILURE;
	}
	
	// Read info from the mat file?
	matvar = Mat_VarReadInfo(matfp, argv[2]);
	
	// Bug out if the variable of name "x" wasn't found
	if(NULL == matvar){
		fprintf(stderr, "Variable '%s' not found, or error reading MAT file\n", argv[2]);
	}
	else{
		// Check if the variable is complex.
		if (!matvar -> isComplex)
			fprintf(stderr, "Variable '%s' is not complex!\n", argv[2]);
		// Check if the variable is a vector
		if(matvar -> rank != 2 || 
			(matvar -> dims[0] > 1 && matvar -> dims[1] > 1))
				fprintf(stderr, "Variable '%s' is not a vector!\n", argv[2]);
		Mat_VarFree(matvar);
	}
	
	// Close the mat file
	Mat_Close(matfp);
	
	// GTFO
	return EXIT_SUCCESS;
}
