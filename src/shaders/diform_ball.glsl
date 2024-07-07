#version 330

out vec4 frag_color;
in vec2 frag_coords;

uniform vec2 resolution;
uniform float time;
uniform vec3 camera_position;

float distance_from_sphere(in vec3 p, in vec3 c, float r)
{
    return length(p - c) - r;
}

float map_the_world(in vec3 p)
{
    float deform = (cos(time)+2);
    float displacement = sin(deform * p.x) * sin(deform * p.y) * sin(deform * p.z) * sin(time);
    float sphere_0 = distance_from_sphere(p, vec3(0.0), 1.0);

    return sphere_0 + displacement;
}

vec3 calculate_normal(in vec3 p)
{
    const vec3 small_step = vec3(0.001, 0.0, 0.0);

    float gradient_x = map_the_world(p + small_step.xyy) - map_the_world(p - small_step.xyy);
    float gradient_y = map_the_world(p + small_step.yxy) - map_the_world(p - small_step.yxy);
    float gradient_z = map_the_world(p + small_step.yyx) - map_the_world(p - small_step.yyx);

    vec3 normal = vec3(gradient_x, gradient_y, gradient_z);

    return normalize(normal);
}

vec3 ray_march(in vec3 ray_origine, in vec3 ray_direction)
{
    float total_distance_traveled = 0.0;
    const int NUMBER_OF_STEPS = 32;
    const float MINIMUM_HIT_DISTANCE = 0.001;
    const float MAXIMUM_TRACE_DISTANCE = 1000.0;
    const vec3 bg_color = vec3(0.0, 0.0, 0.0);
    const vec3 fg_color = vec3(0.1, 0.9, 0.4);

    for (int i = 0; i < NUMBER_OF_STEPS; ++i)
    {
        vec3 current_position = ray_origine + total_distance_traveled * ray_direction;

        float distance_to_closest = map_the_world(current_position);

        if (distance_to_closest < MINIMUM_HIT_DISTANCE)
        {
            vec3 normal = calculate_normal(current_position);

            // For now, hard-code the light's position in our scene
            vec3 light_position = vec3(2.0, -5.0, 3.0);

            // Calculate the unit direction vector that points from
            // the point of intersection to the light source
            vec3 direction_to_light = normalize(current_position - light_position);

            float diffuse_intensity = max(0.0, dot(normal, direction_to_light));

            return fg_color * diffuse_intensity;
        }

        if (total_distance_traveled > MAXIMUM_TRACE_DISTANCE)
        {
            break;
        }

        // accumulate the distance traveled thus far
        total_distance_traveled += distance_to_closest;
    }

    return bg_color;
}

void main()
{
    vec2 uv = vec2(frag_coords.x * (resolution.x/resolution.y), frag_coords.y);

    vec3 ray_origine = camera_position;
    vec3 ray_direction = vec3(uv, 1.0);

    vec3 shaded_color = ray_march(ray_origine, ray_direction);

    frag_color = vec4(shaded_color, 1.0);
}