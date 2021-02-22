shader_type particles;

const float alpha_time = 0.5;
const float wind = 6.0;
const float x_sin_ampl = 20.0;
const float x_sin_period = 1000.;
//const wind = 5.;

uniform float tzero = 0.0;
uniform float duration = 4.0;
uniform sampler2D sprite;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233)))*
        43758.5453123);
}

void vertex() {
	float t = (TIME-tzero)/duration;
	
	ivec2 isize = textureSize(sprite, 0);
	vec2 size = vec2(float(isize.x),float(isize.y));
	vec2 tex_pixel_pos = vec2( mod(float(INDEX), size.x), float(INDEX)/(size.y));
	vec2 tex_uv = tex_pixel_pos/size;
	if (RESTART == true) {
		TRANSFORM[3][0] = -size.x/2.0 + tex_pixel_pos.x;
		TRANSFORM[3][1] = -size.y/2.0 + tex_pixel_pos.y;
		TRANSFORM = EMISSION_TRANSFORM*TRANSFORM;
	}
	vec2 current_pixel_pos = vec2( size.x/2.0 + TRANSFORM[3][0], size.y/2.0 + TRANSFORM[3][1]);
	vec2 current_uv = current_pixel_pos/size;
	if (RESTART == true) {
		if (texture(sprite, tex_uv).a != 1.0) {
//			COLOR = vec4(1.0,1.0,1.0,0.0);
			ACTIVE = false;
		}
	}
//	VELOCITY.x = 10.0*sin(TIME/0.1 + random1*25.);

//	float surv_thickness = 0.4;
////	float survived = 1.0 - exp( (uv.y - t)/0.07*surv_thickness );
//	float survived = smoothstep(t, t - surv_thickness, tex_uv.y);
//	float time_alive = survived - random(tex_uv);
//	if (RESTART == true) COLOR = vec4(0.0,0.0,0.0,0.0);
//	if (time_alive < 0.0) {
	float time_delta = 0.4 ;
	float erand = exp(-random(tex_uv));
	float death_time = tex_uv.y + time_delta*erand;
	float time_alive = t - death_time;
	if (t < death_time) {
		// stand still, be invisible
		COLOR = vec4(1.0,0.0,0.0,0.0);
		VELOCITY = vec3(0.0, 0.0, 0.0);
	} else {
		// on every frame after spawn
//		vec2 row0 = vec2(EMISSION_TRANSFORM[0][0],EMISSION_TRANSFORM[1][0]);
//		vec2 row1 = vec2(EMISSION_TRANSFORM[0][1],EMISSION_TRANSFORM[1][1]);
//
//		mat2 rot = mat2(row0,row1);
		VELOCITY = vec3(0.0, -3.0 -20.0*random(current_uv), 0.0);
		VELOCITY.x = wind + x_sin_ampl*sin(TIME/x_sin_period + random(current_uv)*25.);
//		vec2 subvec = vec2(VELOCITY.x,VELOCITY.y);
//		subvec = inverse(rot)*subvec;

		float alpha = clamp(1.0 - time_alive/alpha_time, 0.0, 1.0);
		COLOR = vec4(texture(sprite, tex_uv).rgb, alpha);
	}
}
