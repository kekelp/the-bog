shader_type canvas_item;

uniform float duration = 4.0;
uniform bool active = false;
uniform float tzero = 0.0;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void fragment() {
		if (active == true) {
			float t = (TIME - tzero)/duration;
			float dist_from_vperc = t - UV.y;
			float surv_thickness = 0.4 ;
	//		float survived = 1.0 - exp( (UV.y - t)/0.07*surv_thickness );
	//		float survived = smoothstep(t, t - surv_thickness, UV.y);
	//		if (random(UV) > survived) {
			float time_delta = 0.4 ;
			float erand = exp(-random(UV));
			float death_time = UV.y  + time_delta*erand;
			if (t < death_time) {
				
				COLOR = texture(TEXTURE, UV); 
	//			COLOR = vec4(1.0 -survived, 0.0, 0.0, 1.0);
			} else {
				COLOR = vec4(0.0, 0.0, 0.0, 0.0);
			}
//	COLOR = vec4(death_time*0.7, 0.0, 0.0, 1.0);
	
//	COLOR = vec4(0.0, vx, 0.0, 1.0);
	} else {
		COLOR = texture(TEXTURE, UV); 
	}

}