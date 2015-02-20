#include <stdlib.h>
#include <stdio.h>
#include "matio.h"

int main(int argc,char **argv)
{
	// Declare a pointer to a matlab file
	mat_t *matfp;
	
	// Declare a pointer to a matlab variable
	matvar_t *matvar;
	
	// Open a matlab file whose name is passed as a command line argument.
	matfp = Mat_Open(argv[1], MAT_ACC_RDONLY);
	
	// Bug out if the file wasn't opened.
	if( NULL == matfp){
		fprintf(stderr, "Error opening MAT file \"%s\"!\n ", argv[1]);
		return EXIT_FAILURE;
	}
	
	/* Loop over the variables in the MAT file. */
	while( (matvar = Mat_VarReadNextInfo(matfp)) != NULL ){
		// Print the name of the next Matlab variable
		printf("%s: ", matvar->name);
		
		// Print the size of the variable
		printf("[%zu, %zu, %zu]\n", matvar->dims[0], matvar->dims[1], matvar->dims[2]);
						
		// Free the matlab variable.
		Mat_VarFree(matvar);
		
		// Set the matlab variable to NULL
		matvar = NULL;
	}
	
	// Close the matlab file
	Mat_Close(matfp);
	
	// GTFO
	return EXIT_SUCCESS;
	
}














