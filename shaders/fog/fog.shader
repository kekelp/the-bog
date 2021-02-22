shader_type canvas_item;

 uniform vec4 color : hint_color;
// Author @patriciogv - 2015
// http://patriciogonzalezvivo.com


float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise(in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

const int NUM_OCTAVES = 4;

float fbm ( in vec2 _st) {
    float v = 0.0;
    float a = 0.5;
    vec2 shift = vec2(100.0);
    // Rotate to reduce axial bias
//    mat2 rot = mat2( vec2(cos(0.5), sin(0.5)), vec2(-sin(0.5), cos(0.50)));
    for (int i = 0; i < NUM_OCTAVES; ++i) {
        v += a * noise(_st*2.5);
        _st =  _st * 2.0 + shift;
        a *= 0.55;
    }
    return v;
}

void fragment() {
	float time2 = TIME/25.0;
	vec2 st;
    st.x = UV.x*1.5;
    st.y = UV.y*1.5 + time2/2.2 ;
    // st += st * abs(sin(u_time*0.1)*3.0);

    vec2 q = vec2(0.);
    q.x = fbm( st + 0.5*time2);
    q.y = fbm( st + vec2(1.0*time2));
	
//	q.x = float(int(q.x*100.0)/10)*10.0/100.0;
//	q.y = float(int(q.y*100.0)/10)*10.0/100.0;

    vec2 r = vec2(0.);
    r.x = fbm( st + 1.0*q + vec2(1.7,9.2)+ 0.15*time2 );
    r.y = fbm( st + 1.0*q + vec2(8.3,2.8)+ 0.126*time2);
	
    float f = fbm(st+r);

//
//    color = mix(vec3(0.101961,0.619608,0.666667),
//                vec3(0.666667,0.666667,0.498039),
//                clamp((f*f)*4.0,0.0,1.0));
//
//    color = mix(color,
//                vec3(0,0,0.164706),
//                clamp(length(q),0.0,1.0));
//
//    color = mix(color,
//                vec3(0.666667,1,1),
//                clamp(length(r),0.0,1.0));
	f = (f*f*f+.6*f*f+.5*f);
	f = float(int(f*100.0)/35)*35.0/100.0;
	f = clamp(f, 0, 0.9);
//	f = pow(f, 2.2);

	
	float grad = pow(UV.y, 2);
    COLOR = vec4(color.rgb, grad*f);

}
