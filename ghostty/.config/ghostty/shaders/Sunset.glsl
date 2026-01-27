/*
    "Sunset" by @XorDev

    Based on my tweet shader:
    https://x.com/XorDev/status/1918764164153049480

    Here's the expanded version:
    https://www.shadertoy.com/view/Wf3SWn
*/
void mainImage(out vec4 fragColor, vec2 fragCoord) {
    vec4 O = vec4(0.0);
    vec2 I = fragCoord;

    // Time for animation (slowed for CPU efficiency)
    float t = iTime * 0.1,
    // Raymarch iterator
    i = 0.0,
    // Raymarch depth
    z = 0.0,
    // Step distance
    d,
    // Signed distance
    s;

    // Raymarch with 100 iterations
    for (; i < 100.0; i++) {
        // Compute raymarch sample point
        vec3 p = z * normalize(vec3(I + I, 0.0) - iResolution.xyy);

        // Turbulence loop
        for (d = 5.0; d < 200.0; d += d)
            p += 0.6 * sin(p.yzx * d - 0.2 * t) / d;

        // Compute distance (smaller steps in clouds when s is negative)
        z += d = 0.005 + max(s = 0.3 - abs(p.y), -s * 0.2) / 4.0;
        // Coloring with sine wave using cloud depth and x-coordinate
        O += (cos(s / 0.07 + p.x + 0.5 * t - vec4(3.0, 4.0, 5.0, 0.0)) + 1.5) * exp(s / 0.1) / d;
    }

    // Tanh tonemapping
    vec4 effect = tanh(O * O / 4e8);

    // Terminal integration
    vec2 texCoord = fragCoord.xy / iResolution.xy;
    vec4 terminalColor = texture(iChannel0, texCoord);
    float textPresence = length(terminalColor.rgb);
    float effectStrength = 0.3;
    float blendFactor = effectStrength * (1.0 - textPresence * 0.9);

    fragColor = vec4(mix(terminalColor.rgb, effect.rgb, blendFactor), terminalColor.a);
}
