shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0); // Controls the reveal effect

void fragment() {
    vec2 uv = UV;

    // Only show pixels where UV.y is less than the progress value
    if (uv.y > progress) {
        discard; // Hide pixels above the progress
    }
}