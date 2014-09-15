# version 120 


// Mine is an old machine.  For version 130 or higher, do 
// out vec4 color ;  
// out vec3 mynormal ; 
// out vec4 myvertex ;
// That is certainly more modern

varying vec4 color ; 
varying vec3 mynormal ; 
varying vec4 myvertex ; 

void main() {
	gl_TexCoord[0] = gl_MultiTexCoord0 ; 
	gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex ; 
	color = gl_Color ; 
	mynormal = gl_Normal ; 
	myvertex = gl_Vertex ; 

	/*  ----------------------------------------------------------------------
			Current practice is to put shading in the fragment shader, not vertex. 
			If you want to move it back to vertex, also move DirectionalLight etc.
			This shader is now almost the same as tex.vert 
			----------------------------------------------------------------------

	// OpenGL semantics: Lights transform by modelview, but not projection.
	// Simpler for normal: vec3 normal = normalize(gl_NormalMatrix*gl_Normal);

	vec3 direction2 = (gl_ModelViewMatrix * vec4(lightdirn,0.0)).xyz ; 
	vec3 normal2 = (gl_ModelViewMatrixInverseTranspose * vec4(gl_Normal,0.0)).xyz ; 
	vec3 normal = normalize(normal2) ; 
	vec3 direction = normalize(direction2) ; 

	color = DirectionalLight(direction, lightcolor, normal, gl_Color) ;

	-----------------------------------------------------------------------
	 */ 
}

