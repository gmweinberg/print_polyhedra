// helper functions

function sum(v) = [for(p = v) 1] * v;

//length of a vector
function vlength(v) = sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);


// Get normalized vector pointing from p1 to p2
function get_vector(p1, p2) = 
    let(
        v = [p2[0] - p1[0], p2[1] - p1[1], p2[2] - p1[2]],
        length = vlength(v)
    ) [v[0]/length, v[1]/length, v[2]/length];

// Calculate centroid of any set of points
function get_centroid(points) = 
    let(
        num_points = len(points),
        sums = [
            sum([for(p = points) p[0]]),
            sum([for(p = points) p[1]]),
            sum([for(p = points) p[2]])
        ]
    ) [sums[0]/num_points, sums[1]/num_points, sums[2]/num_points];

// Function to center any list of points at the origin
function zero_centroid(points) = 
    let(
        centroid = get_centroid(points),
        centered = [for(v = points) [v[0] - centroid[0],  v[1] - centroid[1], v[2] - centroid[2]]]
    ) centered;

// cross product of 2 vectors
function cross_product(a, b) = [
    a[1]*b[2] - a[2]*b[1],
    a[2]*b[0] - a[0]*b[2],
    a[0]*b[1] - a[1]*b[0]
];

// zero_z: Translate a list of points so the lowest point has z=0
// points: List of [x,y,z] coordinates
// Returns: New list with all points translated so minimum z=0
function zero_z(points) =
    let(
        min_z = min([for (p = points) p[2]]) // Find minimum z value
    )
    [for (p = points) [p[0], p[1], p[2] - min_z]]; // Subtract min_z from each point's z value


// direction_vector: Calculate normalized direction vector from p1 to p2
// p1: Starting point [x, y, z]
// p2: Ending point [x, y, z]
// Returns: [dx, dy, dz] - normalized direction vector
function direction_vector(p1, p2) =
    let(
        // Calculate direction vector
        dir = [p2[0] - p1[0], p2[1] - p1[1], p2[2] - p1[2]],
        
        // Calculate magnitude of direction vector
        mag = sqrt(dir[0]*dir[0] + dir[1]*dir[1] + dir[2]*dir[2]),
        
        // Normalize the direction vector
        norm_dir = [dir[0]/mag, dir[1]/mag, dir[2]/mag]
    )
    norm_dir;

// line_from_points: Calculate normalized line equation from two points
// Returns: [[x0, y0, z0], [dx, dy, dz]] where:
//   - [x0, y0, z0] is a point on the line
//   - [dx, dy, dz] is the normalized direction vector
function line_from_points(p1, p2) =
    let(
        // Calculate direction vector
        dir = [p2[0] - p1[0], p2[1] - p1[1], p2[2] - p1[2]],
        
        // Calculate magnitude of direction vector
        mag = sqrt(dir[0]*dir[0] + dir[1]*dir[1] + dir[2]*dir[2]),
        
        // Normalize the direction vector
        norm_dir = [dir[0]/mag, dir[1]/mag, dir[2]/mag]
    )
    [p1, norm_dir];

// plane_from_points: Calculate normalized plane equation from three points
// Returns: [A, B, C, D] where Ax + By + Cz + D = 0 and A²+B²+C²=1
function plane_from_points(p1, p2, p3) =
    let(
        // Calculate two vectors in the plane
        v1 = [p2[0] - p1[0], p2[1] - p1[1], p2[2] - p1[2]],
        v2 = [p3[0] - p1[0], p3[1] - p1[1], p3[2] - p1[2]],
        
        // Calculate the normal vector using cross product
        normal = [
            v1[1] * v2[2] - v1[2] * v2[1],
            v1[2] * v2[0] - v1[0] * v2[2],
            v1[0] * v2[1] - v1[1] * v2[0]
        ],
        
        // Calculate magnitude of normal vector
        mag = sqrt(normal[0]*normal[0] + normal[1]*normal[1] + normal[2]*normal[2]),
        
        // Normalize the normal vector
        norm_normal = [normal[0]/mag, normal[1]/mag, normal[2]/mag],
        
        // Calculate D using point p1 and normalized normal
        D = -norm_normal[0] * p1[0] - norm_normal[1] * p1[1] - norm_normal[2] * p1[2]
    )
    [norm_normal[0], norm_normal[1], norm_normal[2], D];

// vector_add: Add two vectors component-wise
// v1, v2: The vectors to add
// Returns: [v1[0]+v2[0], v1[1]+v2[1], v1[2]+v2[2]]
function vector_add(v1, v2) = [for (i = [0:len(v1)-1]) v1[i] + v2[i]];

// vector_times_scalar: Multiply each component of a vector by a scalar
// v: The vector [x, y, z]
// s: The scalar multiplier
// Returns: [x*s, y*s, z*s]
function vector_times_scalar(v, s) = [for (i = [0:len(v)-1]) v[i] * s];

// faces should have verices listed counterclockwise viewed from the outside so a,b, c clockwise 
// a joins to d, b joins to e, c joins to f
triangle_strut_faces =
    [[ 0, 2, 1],
     [3, 4, 5],
     [0, 1, 4, 3],
     [1, 2, 5, 4],
     [2, 0, 3, 5]];


