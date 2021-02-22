shader_type canvas_item;

uniform float vertical_percent = 0.0;
const float ground = 0.7;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void fragment() {

	if (UV.y > vertical_percent) {
		COLOR = texture(TEXTURE, UV);
	} else {
		float dist_from_vperc = vertical_percent - UV.y;
		float surv_thickness = 0.4 ;
		float survived = smoothstep(vertical_percent, vertical_percent - surv_thickness, UV.y);
		if (random(UV) > survived) {
			COLOR = texture(TEXTURE, UV); 
//			COLOR = vec4(1.0 -survived, 0.0, 0.0, 1.0);
		} else {
			COLOR = vec4(0.0, 0.0, 0.0, 0.0);
		}
	}
	
//	COLOR = vec4(0.0, vx, 0.0, 1.0);


}