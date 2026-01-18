shader_type canvas_item;

uniform int segment_count : hint_range(1, 20) = 5;
uniform float segment_gap : hint_range(0.0, 0.1) = 0.02;
uniform vec4 gap_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = UV;
    float segment_width = 1.0 / float(segment_count);
    
    // Calculate position within current segment
    float segment_index = floor(uv.x / segment_width);
    float local_x = mod(uv.x, segment_width) / segment_width;
    
    // Create gaps between segments
    if (local_x > (1.0 - segment_gap) && segment_index < float(segment_count - 1)) {
        COLOR = gap_color;
    } else {
        // Keep the original texture color
        COLOR = texture(TEXTURE, UV);
    }
}