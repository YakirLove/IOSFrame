//
//  GPUImageFiveInputFilter.h
//  NDSDK
//
//  Created by zhangx on 15/8/4.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "GPUImageFourInputFilter.h"

@interface GPUImageFiveInputFilter : GPUImageFourInputFilter
{
    GPUImageFramebuffer *fifthInputFramebuffer;
    GLint filterFifthTextureCoordinateAttribute;
    GLint filterInputTextureUniform5;
    GPUImageRotationMode inputRotation5;
    GLuint filterSourceTexture5;
    CMTime fifthFrameTime;
    
    BOOL hasSetFourthTexture, hasReceivedFifthFrame, fifthFrameWasVideo;
    BOOL fifthFrameCheckDisabled;
}

- (void)disableFifthFrameCheck;

@end
