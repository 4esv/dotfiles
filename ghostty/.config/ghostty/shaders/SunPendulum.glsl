void mainImage(out vec4 fragColor, vec2 fragCoord) {
    vec4 o = vec4(0.0);
    float d = 0.0, a, e, i = 0.0, s = 0.0, t = iTime * 0.125;
    vec3 p = iResolution;
    vec2 uv = fragCoord;

    // Flip Y for correct orientation
    uv.y = p.y - uv.y;

    // scale coords
    uv = (uv + uv - p.xy) / p.y;

    // Remove cinema bars for terminal use
    vec2 v = uv.yx * 0.7 + vec2(1.2, 0.1);
    float l1 = 2.0 / length(uv + v),
          l2 = 2.0 / length(uv - v);

    // camera movement
    uv += cos(t * vec2(0.4, 0.8)) * vec2(0.3, 0.1);

    for(; i < 100.0; i++) {
        // noise loop start, march
        p = vec3(uv * d, d + t);

        // plane
        s = 5.0 + p.y + cos(p.x * 0.1) * 4.0;

        // noise
        for (a = 0.01; a < 3.0; a += a)
            s -= abs(dot(sin(0.2 * p.z + 0.6 * t + p / a), 0.4 + p - p)) * a;

        // entity (orb)
        e = length(p - vec3(
            sin(sin(t * 0.2) + t * 0.4) * 2.0,
            1.0 + sin(sin(t * 1.3) + t * 0.2) * 1.23,
            12.0 + t + cos(t * 0.5) * 8.0)) - 0.1;

        // accumulate distance
        s = min(0.01 + 0.4 * abs(s), e = max(0.8 * e, 0.01));
        d += s;

        // grayscale color
        o += 100.0 / (s + e * 4.0) + l1 + l2;
    }

    // tanh tonemap, brightness
    vec4 effect = tanh(vec4(5.0, 2.0, 1.0, 0.0) * o * o * o / 1e9);

    // Terminal integration
    vec2 texCoord = fragCoord.xy / iResolution.xy;
    vec4 terminalColor = texture(iChannel0, texCoord);
    float textPresence = length(terminalColor.rgb);
    float effectStrength = 0.3;
    float blendFactor = effectStrength * (1.0 - textPresence * 0.9);

    fragColor = vec4(mix(terminalColor.rgb, effect.rgb, blendFactor), terminalColor.a);
}
