#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "mat2c.h"
#include "wrap_fftw.h"

int main(int argc, char * argv[]){
	
	printf("Hello!\n");
		
	// Allocate the angles
	double alpha, beta, gamma;
	
	// Allocate the "is real" flag
	int isReal = 1;	
		
	// Allocate a pointer that can point to doubles.
	// This will hold the whole data matrix.
	double* data_mat;
	
	// This will hold a single column of the data matrix.
	double* data_sig;
	double* data_pattern;
	
	// Allocate a pointer for the data shape.
	int* data_shape;
	
	// Measure the shape of the data
	data_shape = read_mat_size(argv[1]);
	
	// Reassign some numbers for readability
	int num_rows = data_shape[0];
	int num_cols = data_shape[1];
	
	// Calculate the band width
	int band_width = sqrt(num_rows) / 2;
	
	// Allocate memory for the data vectors.
	data_sig 	 = malloc(num_rows * sizeof(double));
	data_pattern = malloc(num_rows * sizeof(double));
	
	// Print out the shape
	printf("Data size: [%d, %d]\n", num_rows, num_cols);
	
	// Read the data.
	data_mat = read_mat_spherical_data(argv[1]);
	
	// Read a column out of the data
	get_column(data_mat, data_sig, 0, num_rows, num_cols);
	
	// Loop over all the samples
	for(int k = 1; k < num_cols; k++){
		get_column(data_mat, data_pattern, k, num_rows, num_cols);
		
		// Do the correlation once.
		softFFTWCor2(band_width, data_sig, data_pattern, &alpha, &beta, &gamma, isReal);
	
	    /* print results */
	    printf("alpha = %f\nbeta = %f\ngamma = %f\n", alpha, beta, gamma);
	}
	
	// Free the memory
	free(data_mat);
	free(data_shape);
	free(data_sig);
	free(data_pattern);
	
	//GTFO
	return(0);
	
}
