varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform highp float colorLevels;

void main()
{
    highp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    gl_FragColor = clamp(textureColor, vec4(0.15, 0.25, 0.35, 1), vec4(0.9, 0.8, 0.7, 1));
}
