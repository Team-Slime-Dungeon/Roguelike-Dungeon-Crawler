shader_type canvas_item;
uniform float blur: hint_range(0.0, 5);
uniform float brightness: hint_range (0.0, 1.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap,repeat_enable;
void fragment() {
	COLOR = textureLod(SCREEN_TEXTURE,SCREEN_UV, blur);
	COLOR.rgb *= brightness;
	// Place fragment code here.
}
