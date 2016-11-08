//
//  GPUImageFourInputFilter.h
//  NDSDK
//
//  Created by zhangx on 15/8/4.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "GPUImageThreeInputFilter.h"

@interface GPUImageFourInputFilter : GPUImageThreeInputFilter
{
    GPUImageFramebuffer *fourthInputFramebuffer;
    GLint filterFourthTextureCoordinateAttribute;
    GLint filterInputTextureUniform4;
    GPUImageRotationMode inputRotation4;
    GLuint filterSourceTexture4;
    CMTime fourthFrameTime;
    
    BOOL hasSetThirdTexture, hasReceivedFourthFrame, fourthFrameWasVideo;
    BOOL fourthFrameCheckDisabled;
}

- (void)disableFourthFrameCheck;

@end
