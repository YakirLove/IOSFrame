//
//  IFBrannanFilter.m
//  InstaFilters
//
//  Created by Di Wu on 2/28/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#import "NDJinseFilter.h"

NSString *const kNDJinseShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 uniform sampler2D inputImageTexture4;
 uniform sampler2D inputImageTexture5;
 uniform sampler2D inputImageTexture6;  
 
 mat3 saturateMatrix = mat3(
                            1.105150,
                            -0.044850,
                            -0.046000,
                            -0.088050,
                            1.061950,
                            -0.089200,
                            -0.017100,
                            -0.017100,
                            1.132900);
 
 vec3 luma = vec3(.3, .59, .11);
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     vec2 lookup;
     lookup.y = 0.5;
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture2, lookup).r;
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture2, lookup).g;
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture2, lookup).b;
     
     texel = saturateMatrix * texel;
     
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec3 sampled;
     lookup.y = 0.5;
     lookup.x = texel.r;
     sampled.r = texture2D(inputImageTexture3, lookup).r;
     lookup.x = texel.g;
     sampled.g = texture2D(inputImageTexture3, lookup).g;
     lookup.x = texel.b;
     sampled.b = texture2D(inputImageTexture3, lookup).b;
     float value = smoothstep(0.0, 1.0, d);
     texel = mix(sampled, texel, value);
     
     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture4, lookup).r;
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture4, lookup).g;
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture4, lookup).b;
     
     
     lookup.x = dot(texel, luma);
     texel = mix(texture2D(inputImageTexture5, lookup).rgb, texel, .5);

     lookup.x = texel.r;
     texel.r = texture2D(inputImageTexture6, lookup).r;
     lookup.x = texel.g;
     texel.g = texture2D(inputImageTexture6, lookup).g;
     lookup.x = texel.b;
     texel.b = texture2D(inputImageTexture6, lookup).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
);

@implementation NDJinseFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kNDJinseShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
