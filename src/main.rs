use glium::{glutin, Surface, uniform};
use std::fs::read_to_string;
use std::path::Path;
use std::time::Instant;

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
    let fragment_shader_src = read_to_string(Path::new("src/shaders/fragment.glsl")).expect("Failed to read fragment shader");

    let program = glium::Program::from_source(&display, &vertex_shader_src, &fragment_shader_src, None).unwrap();

    let vertex_buffer = glium::VertexBuffer::new(&display, &[
        Vertex { position: [-1.0, -1.0] },
        Vertex { position: [ 1.0, -1.0] },
        Vertex { position: [-1.0,  1.0] },
        Vertex { position: [ 1.0,  1.0] },
    ]).unwrap();

    let index_buffer = glium::IndexBuffer::new(&display, glium::index::PrimitiveType::TriangleStrip, &[0u16, 1, 2, 3]).unwrap();

    let start_time = Instant::now();

    event_loop.run(move |event, _, control_flow| {

        let elapsed = start_time.elapsed();
        let elapsed_seconds = elapsed.as_secs_f32();

        let (width, height) = display.get_framebuffer_dimensions();

        let mut target = display.draw();
        target.clear_color(0.0, 0.0, 0.0, 1.0);
        target.draw(&vertex_buffer, &index_buffer, &program, &uniform! {
            time: elapsed_seconds,
            resolution: [width as f32, height as f32],
            camera_position: [ 0.0f32 , 0.0f32, -2.0f32]
        }, &Default::default()).unwrap();
        target.finish().unwrap();

        match event {
            glutin::event::Event::WindowEvent { event, .. } => match event {
                glutin::event::WindowEvent::CloseRequested => *control_flow = glutin::event_loop::ControlFlow::Exit,
                _ => (),
            },
            _ => (),
        }
    });
}
