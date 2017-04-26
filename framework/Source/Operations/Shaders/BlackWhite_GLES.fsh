varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform highp float colorLevels;

highp float max3 (highp vec3 v) {
  return max (max (v.x, v.y), v.z);
}

highp float min3 (highp vec3 v) {
  return min (min (v.x, v.y), v.z);
}

void main()
{
    highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    highp float smallest = min3(textureColor.rgb);
    highp vec3 mono = clamp(textureColor.rgb - smallest, vec3(smallest), vec3(1));
    gl_FragColor = vec4(mono, 1.0);
}
