varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform float colorLevels;

float max3 (vec3 v) {
  return max (max (v.x, v.y), v.z);
}

float min3 (vec3 v) {
  return min (min (v.x, v.y), v.z);
}

void main()
{
    vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    float smallest = min3(textureColor.rgb);
    vec3 mono = clamp(textureColor.rgb - smallest - 0.1, vec3(smallest), vec3(1));
    gl_FragColor = vec4(mono, 1.0);
}
