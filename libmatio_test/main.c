#include <stdlib.h>
#include <stdio.h>
#include "matio.h"

int main(int argc,char **argv)
{
	mat_t *matfp;
	matfp = Mat_Open(argv[1],MAT_ACC_RDONLY);
	if ( NULL == matfp ) {
		fprintf(stderr,"Error opening MAT file \"%s\"!\n",argv[1]);
		return EXIT_FAILURE;
	}

	printf("Successfully opened file %s\n", argv[1]);
	Mat_Close(matfp);
	return EXIT_SUCCESS;
}
