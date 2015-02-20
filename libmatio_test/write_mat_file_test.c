#include <stdlib.h>
#include <stdio.h>
#include "matio.h"

int main(int argc,char **argv)
{
	// Declare the matfile.
	mat_t *matfp;
	
	// Create mat file variable with version Mat5
	matfp = Mat_CreateVer("matfile5.mat", NULL, MAT_FT_MAT5);
	
	// Return failure if file wasn't created.
	if (NULL == matfp) {
		fprintf(stderr, "Error creating MAT file \"matfile5.mat\"!\n");
		return EXIT_FAILURE;
	}
	
	// Close the mat file
	Mat_Close(matfp);
	
	// Create mat file variable with version Mat7.3
	matfp = Mat_CreateVer("matfile73.mat", NULL, MAT_FT_MAT73);
	if(NULL == matfp){
		fprintf(stderr, "Error creating MAT file \"matfile73.mat\"!\n");
	}
	
	// Close the mat file
	Mat_Close(matfp);
	
	// GTFO
	return EXIT_SUCCESS;
	
}
