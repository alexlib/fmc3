function DATA_SPHERICAL_2D = spherical_projection(DATA_SPHERICAL_3D)

% This determines the size of the data
DATA_SPHERICAL_2D = sum(DATA_SPHERICAL_3D, 3);

end