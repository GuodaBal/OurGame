shader_type canvas_item;
uniform vec4 base_color : source_color;
//global uniform float location_fade;

void fragment()
	{
		// Each uv coordinate is moved at different speeds overtime
		vec2 uv1 = UV + vec2(TIME * 0.05, -TIME * 0.05);
		vec2 uv2 = UV * 0.5 + vec2(0.5, 0.5) * TIME * 0.02;
		vec2 uv3 = UV * vec2(0.75, 1.0) - vec2(0.25, TIME * 0.02);

		//Get separate noise textures
		vec3 fog_color1 = texture(TEXTURE, uv1).rgb;
		vec3 fog_color2 = texture(TEXTURE, uv2).rgb;
		vec3 fog_color3 = texture(TEXTURE, uv3).rgb;

		// Blend everything
		vec3 fog_color = mix(mix(fog_color1, fog_color2, 0.5), fog_color3, 0.5);

		// Mix fog with base color
		float fog_alpha = (fog_color.r + fog_color.g + fog_color.b) / 3.0 * 1.5;
		COLOR.a = base_color.a * fog_alpha;
		COLOR.rgb = fog_color * base_color.rgb;
		
	}
