#version 330

out vec4 frag_color;
in vec2 frag_coords;

uniform vec2 resolution;
uniform float time;
uniform vec3 camera_position;

float mandelbrot(vec2 uv)
{
    vec2 c = 4.0 * uv -vec2(0.7, 0.0);
    c = c / pow(time, 4.0) - vec2(0.65, 0.45);
    vec2 z = vec2(0.0);
    for (float i; i < 100; i++)
    {
        z = vec2(z.x * z.x - z.y * z.y,
                2.0 * z.x * z.y) + c;
        if(dot(z, z) > 4.0) return i / 100;
    }
    return 0.0;
}

void main() {
    vec2 uv = vec2(frag_coords.x * (resolution.x/resolution.y), frag_coords.y);
    vec3 col = vec3(0.0);

    float m = mandelbrot(uv);
    col += m;
    col = pow(col, vec3(0.45));
    frag_color = vec4(col, 0.0);
}