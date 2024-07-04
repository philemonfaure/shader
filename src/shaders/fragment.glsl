#version 330

in vec2 texCoords;
out vec4 color;

uniform vec2 u_resolution;
uniform float u_time;

float hash(vec3 uv)
{
    return fract(sin(7.289 * uv.x + 11.23 * uv.y + 13.09 * uv.z) * 23758.5453);
}

float noise(vec3 x)
{
    vec3 p = floor(x), f = fract(x);
    f = f*f*(3.-2.*f);
    return mix( mix(mix( hash(p+vec3(0,0,0)), hash(p+vec3(1,0,0)),f.x),
        mix( hash(p+vec3(0,1,0)), hash(p+vec3(1,1,0)),f.x),f.y),
        mix(mix( hash(p+vec3(0,0,1)), hash(p+vec3(1,0,1)),f.x),
        mix( hash(p+vec3(0,1,1)), hash(p+vec3(1,1,1)),f.x),f.y), f.z);
}

void main()
{
    vec2 R = u_resolution.xy;
    color = vec4(noise(vec3(R*8./u_time, .1*R)));
}
