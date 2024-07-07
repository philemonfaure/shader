#version 330

in vec2 position;
out vec2 frag_coords;

void main() {
    gl_Position = vec4(position, 0.0, 1.0);
    frag_coords = position;
}