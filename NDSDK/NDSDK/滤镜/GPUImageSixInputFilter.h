//
//  GPUImageSixInputFilter.h
//  NDSDK
//
//  Created by zhangx on 15/8/4.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "GPUImageFiveInputFilter.h"

@interface GPUImageSixInputFilter : GPUImageFiveInputFilter
{
    GPUImageFramebuffer *sixthInputFramebuffer;
    GLint filterSixthTextureCoordinateAttribute;
    GLint filterInputTextureUniform6;
    GPUImageRotationMode inputRotation6;
    GLuint filterSourceTexture6;
    CMTime sixthFrameTime;
    
    BOOL hasSetFifthTexture, hasReceivedSixthFrame, sixthFrameWasVideo;
    BOOL sixthFrameCheckDisabled;
}

- (void)disableSixthFrameCheck;

@end
