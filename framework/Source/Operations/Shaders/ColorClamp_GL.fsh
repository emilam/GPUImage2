varying vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform float colorLevels;

void main()
{
    vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    gl_FragColor = clamp(textureColor, vec4(0.15, 0.25, 0.35, 1), vec4(0.9, 0.8, 0.7, 1));
}
