#version 330

out vec4 frag_color;
in vec2 frag_coords;

uniform vec2 resolution;
uniform float time;
uniform vec3 camera_position;

void main()
{
    vec2 uv = vec2(frag_coords.x * (resolution.x/resolution.y), frag_coords.y);
    frag_color = vec4(4.0);
}