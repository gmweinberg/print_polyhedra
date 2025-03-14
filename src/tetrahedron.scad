// tetrahedron with side length 1 with vertex at origin
raw_tetrahedron_vertices = [
    [0, 0, 0],
    [1, 0, 0],
    [0.5, sqrt(3)/2, 0],
    [0.5, sqrt(3)/6, sqrt(6)/3]
];

tetrahedron_vertices = zero_centroid(raw_tetrahedron_vertices);

tetrahedron_faces =  [
    [0, 1, 2],
    [0, 3, 1],
    [1, 3, 2],
    [2, 3, 0]
];

// Creates a triangular strut between two vertices of a tetrahedron
module tetra_strut(p1, p2, v3, v4, width) {
    // Get directions to the other vertices
    dir_to_v3 = direction_vector(p1, v3);
    dir_to_v4 = direction_vector(p1, v4);
    dir_from_p2_to_v3 = direction_vector(p2, v3);
    dir_from_p2_to_v4 = direction_vector(p2, v4);
    
    // Calculate the vertices of the triangular faces
    a = p1;
    b = vector_add(p1, vector_times_scalar(dir_to_v3, width));
    c = vector_add(p1, vector_times_scalar(dir_to_v4, width));
    
    d = p2;
    e = vector_add(p2, vector_times_scalar(dir_from_p2_to_v3, width));
    f = vector_add(p2, vector_times_scalar(dir_from_p2_to_v4, width));
    
    // Create the strut using polyhedron
    points = [a, b, c, d, e, f];
    polyhedron(points = points, faces = triangle_strut_faces);
}

// Creates a complete tetrahedron frame
// vertices: Array of 4 points defining the tetrahedron vertices
// width: Width of the struts
module tetrahedron_frame(vertices, width) {
    // Extract vertices
    v1 = vertices[0];
    v2 = vertices[1];
    v3 = vertices[2];
    v4 = vertices[3];
    
    // Create struts for each edge (6 total)
    // Edge v1-v2
    tetra_strut(v1, v2, v3, v4, width);// Creates a triangular strut between two vertices of a tetrahedron
module tetra_strut(p1, p2, v3, v4, width) {
    // Get directions to the other vertices
    dir_to_v3 = direction_vector(p1, v3);
    dir_to_v4 = direction_vector(p1, v4);
    dir_from_p2_to_v3 = direction_vector(p2, v3);
    dir_from_p2_to_v4 = direction_vector(p2, v4);
    
    // Calculate the vertices of the triangular faces
    a = p1;
    b = vector_add(p1, vector_times_scalar(dir_to_v3, width));
    c = vector_add(p1, vector_times_scalar(dir_to_v4, width));
    
    d = p2;
    e = vector_add(p2, vector_times_scalar(dir_from_p2_to_v3, width));
    f = vector_add(p2, vector_times_scalar(dir_from_p2_to_v4, width));
    
    // Create the strut using polyhedron
    points = [a, b, c, d, e, f];
    polyhedron(points = points, faces = triangle_strut_faces);
}
    // Edge v1-v3
    tetra_strut(v1, v3, v2, v4, width);
    // Edge v1-v4
    tetra_strut(v1, v4, v2, v3, width);
    // Edge v2-v3
    tetra_strut(v2, v3, v1, v4, width);
    // Edge v2-v4
    tetra_strut(v2, v4, v1, v3, width);
    // Edge v3-v4
    tetra_strut(v3, v4, v1, v2, width);
}

// Module to create a tetrahedron of any size centered at the origin
module tetrahedron(scale_factor=1) {
    // Scale the centered vertices
    scaled_vertices = [for(v = tetrahedron_vertices) [v[0]*scale_factor, v[1]*scale_factor, v[2]*scale_factor]];
    offset_vertices = zero_z(scaled_vertices);
    
    // Create the tetrahedron
    polyhedron(points=offset_vertices, faces=tetrahedron_faces, convexity=4);
}
