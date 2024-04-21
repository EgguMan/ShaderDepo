const float GeneralIntensity = 3.;
const float GreenIntensity = 1.;

const bool blending = true;
const int blendingQuality = 3; //this will be done twice, advised to not put it too high

float x = -1.;
float y = -1.;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    vec4 col = texture(iChannel0, uv);
    
    vec2 coordOffsets = vec2(x, y)/100.;
    
    //get the highlight
    float hglh = texture(iChannel0, vec2(uv.x+coordOffsets.x, uv.y+coordOffsets.y)).a;

    //mask the highlight so that its only the border
    if (blending) {
    for (float i = float(-1*blendingQuality); i < float(blendingQuality); i+= 0.25) {
        float cur = (float(i) + float(blendingQuality))/float(blendingQuality);
        hglh -= (texture(iChannel0, vec2(uv.x-mix(coordOffsets.x/2., coordOffsets.x*2., cur),uv.y-mix(coordOffsets.y/2., coordOffsets.y*2., cur))).a)*cur;
    }
    } else {
        hglh -= (texture(iChannel0, vec2(uv.x-coordOffsets.x, uv.y-coordOffsets.y))).a;
    }
    //apply the highlight with mask
    hglh /= GeneralIntensity;
    col.b = max(col.b, col.b + hglh);
    hglh /= GreenIntensity;
    col.g = max(col.g, col.g + hglh);
    
    fragColor = mix(texture(iChannel1, uv), col, col.a);;
}
