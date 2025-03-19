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
// Vertices of a cube with side length 2 centered at origin
raw_cube_vertices = [
    [-1, -1, -1], // Vertex 0: bottom-left-back
    [1, -1, -1],  // Vertex 1: bottom-right-back
    [1, 1, -1],   // Vertex 2: bottom-right-front
    [-1, 1, -1],  // Vertex 3: bottom-left-front
    [-1, -1, 1],  // Vertex 4: top-left-back
    [1, -1, 1],   // Vertex 5: top-right-back
    [1, 1, 1],    // Vertex 6: top-right-front
    [-1, 1, 1]    // Vertex 7: top-left-front
];

// Faces of the cube (corrected counter-clockwise order)
cube_faces = [
    [0, 3, 2, 1], // Bottom face (-z) - viewed from below
    [4, 5, 6, 7], // Top face (+z) - viewed from above
    [0, 1, 5, 4], // Back face (-y) - viewed from back
    [3, 7, 6, 2], // Front face (+y) - viewed from front
    [0, 4, 7, 3], // Left face (-x) - viewed from left
    [1, 2, 6, 5]  // Right face (+x) - viewed from right
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
// temporary copy
module strut(p1, p2, v3, v4, width) {
    // Get directions to the other vertices
    echo("Starting strut generation...", p1, p2, v3, v4);
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
    echo("strut points", points);
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
    //offset_vertices = zero_z(scaled_vertices);
    
    // Create the tetrahedron
    polyhedron(points=scaled_vertices, faces=tetrahedron_faces, convexity=4);
}


raw_octohedron_vertices = [[0, 0, 1],
                          [0, 0, -1],
                          [1, 0, 0],
                          [-1, 0, 0],
                          [0, 1, 0],
                          [0, -1, 0]];

octohedron_faces = [[0, 4, 2],
                    [0, 2, 5],
                    [0, 5, 3],
                    [0, 3, 4],
                    [1, 2, 4],
                    [1, 5, 2],
                    [1, 3, 5],
                    [1, 4, 3]];


module octohedron(scale_factor = 1) {
    octo_vertices = vector_times_scalar(raw_octohedron_vertices, scale_factor);
    polyhedron(points=octo_vertices, faces=octohedron_faces, convexity=4);
}
// This module processes edges in a polyhedron and generates struts
module generic_polyhedron_struts(vertices, faces, width) {
    // Process each face and its edges
    for (face1_idx = [0:len(faces)-1]) {
        face1 = faces[face1_idx];
        
        // For each edge in face1
        for (i = [0:len(face1)-1]) {
            v1_idx = face1[i];
            v2_idx = face1[(i+1) % len(face1)];
            
            // Ensure consistent edge orientation
            ordered_edge = v1_idx < v2_idx ? [v1_idx, v2_idx] : [v2_idx, v1_idx];
            
            // Find a face that shares this edge (in opposite direction)
            for (face2_idx = [0:len(faces)-1]) {
                if (face1_idx != face2_idx) {
                    face2 = faces[face2_idx];
                    
                    // Look for the edge in face2
                    for (j = [0:len(face2)-1]) {
                        f2_v1 = face2[j];
                        f2_v2 = face2[(j+1) % len(face2)];
                        
                        // Check if this is the same edge (in opposite direction)
                        if ((v1_idx == f2_v2 && v2_idx == f2_v1) || 
                            (v1_idx == f2_v1 && v2_idx == f2_v2)) {
                            
                            // Only process each edge once (avoid duplicates)
                            if (face1_idx < face2_idx || 
                                (face1_idx == face2_idx && i < j)) {
                                
                                // Find orientation vertices
                                v3_idx = face1[(len(face1) + i - 1) % len(face1)];
                                v4_idx = face2[(j+2) % len(face2)];
                                
                                // Create the strut
                                strut(vertices[v1_idx], vertices[v2_idx], 
                                      vertices[v3_idx], vertices[v4_idx], width);
                            }
                        }
                    }
                }
            }
        }
    }
}
