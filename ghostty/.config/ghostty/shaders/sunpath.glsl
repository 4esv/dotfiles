// Based on "Physically Based Sky, Atmosphere and Cloud Rendering in Frostbite" with some modifications

#define EARTH_RADIUS 6360000.0
#define ATMOSPHERE_RADIUS 6420000.0

#define RAYLEIGH_SCATTERING vec3(5.8e-6, 1.35e-5, 3.31e-5)
#define MIE_SCATTERING vec3(1.5e-6)
#define MIE_EXTINCTION (1.3 * MIE_SCATTERING)
#define OZONE_ABSORPTION (vec3(3.426, 8.298, 0.356) * 0.06e-5)

#define RAYLEIGH_SCALE_HEIGHT 8000.0
#define MIE_SCALE_HEIGHT 1200.0
#define OZONE_SCALE_HEIGHT 8000.0

#define MIE_G 0.9
#define SUN_INTENSITY 9.0

vec2 raySphereIntersect(vec3 r0, vec3 rd, float r) {
    float b = dot(r0, rd);
    float c = dot(r0, r0) - r * r;
    float d = b * b - c;
    if (d < 0.0) return vec2(-1.0);
    float sqd = sqrt(d);
    return vec2(-b - sqd, -b + sqd);
}

float rayleighPhase(float cosTheta) {
    return 3.0 / (16.0 * 3.14159) * (1.0 + cosTheta * cosTheta);
}

float cornetteShanksPhase(float cosTheta, float g) {
    float g2 = g * g;
    return (3.0 * (1.0 - g2) * (1.0 + cosTheta * cosTheta)) /
           (8.0 * 3.14159 * (2.0 + g2) * pow(1.0 + g2 - 2.0 * g * cosTheta, 1.5));
}

vec3 getTransmittance(vec3 p, vec3 L) {
    vec2 isectEarth = raySphereIntersect(p, L, EARTH_RADIUS);
    if (isectEarth.x > 0.0) return vec3(0.0);

    vec2 isectAtm = raySphereIntersect(p, L, ATMOSPHERE_RADIUS);
    float tMax = isectAtm.y;

    const int steps = 6;
    float dt = tMax / float(steps);
    float t = 0.0;

    vec3 opticalDepth = vec3(0.0);

    for (int i = 0; i < steps; i++) {
        vec3 samplePos = p + L * (t + 0.5 * dt);
        float h = max(length(samplePos) - EARTH_RADIUS, 0.0);

        float rD = exp(-h / RAYLEIGH_SCALE_HEIGHT);
        float mD = exp(-h / MIE_SCALE_HEIGHT);
        float oD = exp(-h / OZONE_SCALE_HEIGHT);

        opticalDepth += (RAYLEIGH_SCATTERING * rD + MIE_EXTINCTION * mD + OZONE_ABSORPTION * oD) * dt;
        t += dt;
    }

    return exp(-opticalDepth);
}

vec3 integrateScattering(vec3 r0, vec3 rd, vec3 L) {
    vec2 isect = raySphereIntersect(r0, rd, ATMOSPHERE_RADIUS);
    if (isect.y < 0.0) return vec3(0.0);

    float tMin = max(0.0, isect.x);
    float tMax = isect.y;

    vec2 isectEarth = raySphereIntersect(r0, rd, EARTH_RADIUS);
    if (isectEarth.x > 0.0) {
        tMax = isectEarth.x;
    }

    float cosTheta = dot(rd, L);
    float phaseR = rayleighPhase(cosTheta);
    float phaseM = cornetteShanksPhase(cosTheta, MIE_G);

    const int steps = 16;

    vec3 totalScattering = vec3(0.0);
    vec3 opticalDepth = vec3(0.0);

    for (int i = 0; i < steps; i++) {
        float normalizedI = float(i) / float(steps);
        float nextNormalizedI = float(i + 1) / float(steps);

        float t0 = tMin + (tMax - tMin) * (normalizedI * normalizedI);
        float t1 = tMin + (tMax - tMin) * (nextNormalizedI * nextNormalizedI);
        float dt = t1 - t0;

        vec3 samplePos = r0 + rd * (t0 + 0.5 * dt);
        float h = max(length(samplePos) - EARTH_RADIUS, 0.0);

        float rD = exp(-h / RAYLEIGH_SCALE_HEIGHT);
        float mD = exp(-h / MIE_SCALE_HEIGHT);
        float oD = max(0.0, 1.0 - abs(h - 25000.0) / 15000.0);

        vec3 sampleExtinction = RAYLEIGH_SCATTERING * rD + MIE_EXTINCTION * mD + OZONE_ABSORPTION * oD;
        opticalDepth += sampleExtinction * dt;

        vec3 transmittance = exp(-opticalDepth);
        vec3 lightTransmittance = getTransmittance(samplePos, L);

        vec3 S = (RAYLEIGH_SCATTERING * rD * phaseR + MIE_SCATTERING * mD * phaseM) * lightTransmittance;
        vec3 MS = (RAYLEIGH_SCATTERING * rD + MIE_SCATTERING * mD * 0.25 * max(L.y, 0.0)) * lightTransmittance * 0.005;

        totalScattering += (S + MS) * SUN_INTENSITY * transmittance * dt;
    }

    if (isectEarth.x > 0.0) {
        vec3 finalTransmittance = exp(-opticalDepth);
        vec3 earthAlbedo = vec3(0.01, 0.012, 0.01);
        vec3 normal = normalize(r0 + rd * tMax);
        float NdotL = max(dot(normal, L), 0.0);
        vec3 groundPos = r0 + rd * tMax + normal * 2.0;
        vec3 skyAmbient = vec3(0.01, 0.015, 0.02) * max(L.y, 0.0);
        vec3 groundLighting = (getTransmittance(groundPos, L) * NdotL + skyAmbient) * SUN_INTENSITY;
        totalScattering += earthAlbedo * groundLighting * finalTransmittance;
    }

    return totalScattering;
}

vec3 ACESFilm(vec3 x) {
    float a = 2.51;
    float b = 0.03;
    float c = 2.43;
    float d = 0.59;
    float e = 0.14;
    return clamp((x*(a*x+b))/(x*(c*x+d)+e), 0.0, 1.0);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    // Flip Y for correct orientation
    uv.y = -uv.y;

    // Sun path driven by time - completes a full day cycle
    float daySpeed = 0.02;
    float sunTheta = 3.14159 * (0.5 + 0.45 * cos(iTime * daySpeed));
    float sunPhi = sin(iTime * daySpeed * 0.3) * 0.3;
    vec3 sunDir = normalize(vec3(sin(sunTheta) * sin(sunPhi), cos(sunTheta), sin(sunTheta) * cos(sunPhi)));

    vec3 ro = vec3(0.0, EARTH_RADIUS + 3000.0, 0.0);

    vec3 forward = vec3(0.0, 0.0, 1.0);
    vec3 up = vec3(0.0, 1.0, 0.0);
    vec3 right = vec3(1.0, 0.0, 0.0);

    vec3 rd = normalize(forward + uv.x * right + uv.y * up);

    vec3 skyColor = integrateScattering(ro, rd, sunDir);

    float sunAngle = acos(clamp(dot(rd, sunDir), -1.0, 1.0));
    if (sunAngle < 0.015) {
        vec3 sunTransmittance = getTransmittance(ro, sunDir);
        skyColor += vec3(50.0) * sunTransmittance * smoothstep(0.04, 0.03, sunAngle);
    }

    skyColor = ACESFilm(skyColor);
    skyColor = pow(skyColor, vec3(1.0 / 2.2));

    float noise = fract(sin(dot(fragCoord, vec2(12.9898, 78.233))) * 43758.5453);
    skyColor += (noise - 0.5) / 128.0;

    // Terminal integration
    vec2 texCoord = fragCoord.xy / iResolution.xy;
    vec4 terminalColor = texture(iChannel0, texCoord);
    float textPresence = length(terminalColor.rgb);

    // Blend strength varies with sun elevation - stronger at twilight, subtler midday
    float sunElevation = sunDir.y;
    float effectStrength = mix(0.5, 0.25, clamp(sunElevation, 0.0, 1.0));
    float blendFactor = effectStrength * (1.0 - textPresence * 0.9);

    fragColor = vec4(mix(terminalColor.rgb, skyColor, blendFactor), terminalColor.a);
}
