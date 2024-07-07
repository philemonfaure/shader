use glium::{glutin, Surface, uniform};
use std::fs::read_to_string;
use std::path::Path;
use std::time::{Duration, Instant};

#[derive(Copy, Clone)]
struct Vertex {
    position: [f32; 2],
}

glium::implement_vertex!(Vertex, position);

fn main() {
    let event_loop = glutin::event_loop::EventLoop::new();

    let wb = glutin::window::WindowBuilder::new().with_title("Shader Art");
    let cb = glutin::ContextBuilder::new();
    let display = glium::Display::new(wb, cb, &event_loop).unwrap();

    let vertex_shader_src = read_to_string(Path::new("src/shaders/vertex.glsl")).expect("Failed to read vertex shader");
    let fragment_shader_src = read_to_string(Path::new("src/shaders/diform_ball.glsl")).expect("Failed to read fragment shader");

    let program = glium::Program::from_source(&display, &vertex_shader_src, &fragment_shader_src, None).unwrap();

    let vertex_buffer = glium::VertexBuffer::new(&display, &[
        Vertex { position: [-1.0, -1.0] },
        Vertex { position: [ 1.0, -1.0] },
        Vertex { position: [-1.0,  1.0] },
        Vertex { position: [ 1.0,  1.0] },
    ]).unwrap();

    let index_buffer = glium::IndexBuffer::new(&display, glium::index::PrimitiveType::TriangleStrip, &[0u16, 1, 2, 3]).unwrap();

    let camera_position: [f32; 3] = [0.0, 0.0, -3.0];

    let target_fps: u32 = 60;
    let frame_duration = Duration::from_secs_f32(1.0 / target_fps as f32);

    let start_time = Instant::now();
    let mut last_frame_time = Instant::now();

    event_loop.run(move |event, _, control_flow| {

        let now = Instant::now();
        let elapsed = now - last_frame_time;

        if elapsed >= frame_duration {
            last_frame_time = now;

            let (width, height) = display.get_framebuffer_dimensions();

            let mut target = display.draw();
            target.clear_color(0.0, 0.0, 0.0, 1.0);
            target.draw(&vertex_buffer, &index_buffer, &program, &uniform! {
            time: start_time.elapsed().as_secs_f32(),
            resolution: [width as f32, height as f32],
            camera_position: camera_position
        }, &Default::default()).unwrap();
            target.finish().unwrap();
        }

        *control_flow = glutin::event_loop::ControlFlow::WaitUntil(last_frame_time + frame_duration);

        match event {
            glutin::event::Event::WindowEvent { event, .. } => match event {
                glutin::event::WindowEvent::CloseRequested => *control_flow = glutin::event_loop::ControlFlow::Exit,
                _ => (),
            },
            _ => (),
        }
    });
}
