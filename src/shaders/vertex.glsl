#version 330

in vec2 position;
out vec2 fragCoords;

void main() {
    gl_Position = vec4(position, 0.0, 1.0);
    fragCoords = position;
}