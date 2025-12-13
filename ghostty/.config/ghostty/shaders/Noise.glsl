// Noise functions by Nikita Miropolskiy
vec3 random3(vec3 c) {
    float j = 4096.0*sin(dot(c,vec3(17.0, 59.4, 15.0)));
    return fract(j*vec3(64,8,512)) -.5;
}

const float F3 =  0.3333333;
const float G3 =  0.1666667;
float snoise(vec3 p) {
    vec3 s = floor(p + dot(p, vec3(F3)));
    vec3 x = p - s + dot(s, vec3(G3));
     
    vec3 e = step(vec3(0.0), x - x.yzx);
    vec3 i1 = e*(1.0 - e.zxy);
    vec3 i2 = 1.0 - e.zxy*(1.0 - e);
        
    vec3 x1 = x - i1 + G3;
    vec3 x2 = x - i2 + 2.0*G3;
    vec3 x3 = x - 1.0 + 3.0*G3;
     
    vec4 w, d;
     
    w.x = dot(x, x);
    w.y = dot(x1, x1);
    w.z = dot(x2, x2);
    w.w = dot(x3, x3);
     
    w = max(0.6 - w, 0.0);
     
    d.x = dot(random3(s), x);
    d.y = dot(random3(s + i1), x1);
    d.z = dot(random3(s + i2), x2);
    d.w = dot(random3(s + 1.0), x3);
     
    w *= w;
    w *= w;
    d *= w;
     
    return dot(d, vec4(52.0));
}

float snoiseFractal(vec3 m) {
    return   0.5333333* snoise(m)
            +0.2666667* snoise(2.0*m)
            +0.1333333* snoise(4.0*m)
            +0.0666667* snoise(8.0*m);
}

#define fast true // Using fast mode for better terminal performance
const int compareDistance = 4;

const int r2 = compareDistance * compareDistance;
const int steps = 6;
const vec3 colors[steps] = vec3[](
    vec3(0.133, 0.223, 0.345),
    vec3(0.270, 0.458, 0.690),
    vec3(0.458, 0.725, 0.745),
    vec3(0.815, 0.839, 0.709),
    vec3(0.976, 0.709, 0.674),
    vec3(0.933, 0.462, 0.454)
);

int getPixelStepi(vec2 pixel, vec2 dimensions, float t) {
    return min(max(int(((snoiseFractal(vec3(pixel / dimensions.y, t * 0.05)) + 0.5)) * float(steps)), 0), steps - 1);
}

float getPixelStepf(vec2 pixel, vec2 dimensions, float t) {
    return ((snoiseFractal(vec3(pixel / dimensions.y, t * 0.05)) + 0.5)) * float(steps);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord/iResolution.xy;
    vec4 terminalColor = texture(iChannel0, uv);
    vec3 noiseColor;
    
    if(fast) {
        float step = getPixelStepf(fragCoord, iResolution.xy, iTime);
        noiseColor = colors[int(step)] * smoothstep(2.,4., abs(fract(step+.5)-.5) / fwidth(step));
    } else {
        int step = getPixelStepi(fragCoord.xy, iResolution.xy, iTime);

        for (int y = -compareDistance; y <= compareDistance; y++) {
            for (int x = -compareDistance; x <= compareDistance; x++) {
                if (x * x + y * y > r2) continue;
                if (getPixelStepi(fragCoord.xy + vec2(x, y), iResolution.xy, iTime) != step) {
                    noiseColor = vec3(0.0);
                    break;
                }
            }
        }
        
        if (noiseColor == vec3(0.0)) {
            noiseColor = colors[step];
        }
    }
    
    // Smart blending for terminal text
    float textPresence = length(terminalColor.rgb);
    float blendFactor = 0.6 * (1.0 - textPresence * 0.7);
    
    // Final output with terminal integration
    fragColor = vec4(mix(terminalColor.rgb, noiseColor, blendFactor), terminalColor.a);
}
