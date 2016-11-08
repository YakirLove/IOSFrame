//
//  UIImage+Utils.m
//  NDUIToolKit
//
//  Created by zhangx on 15/8/3.
//  Copyright © 2015年 nd. All rights reserved.
//

#import "UIImage+Utils.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Utils)

#pragma mark 图片压缩
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark 修改饱和度、亮度、对比度
- (UIImage *)imageWithSaturation:(CGFloat)saturation brightness:(CGFloat)brightness contrast:(CGFloat)contrast
{

    CIFilter * filter = [CIFilter filterWithName:@"CIColorControls"];
    //  饱和度      0---2
    [filter setValue:[NSNumber numberWithFloat:saturation] forKey:@"inputSaturation"];
    //  亮度  10   -1---1
    [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputBrightness"];
    //  对比度 -11  0---4
    [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputContrast"];
    
    return [self imageWithFilter:filter];
    
}

- (UIImage *)imageWithFilter:(CIFilter *)filter
{
    CIImage *beginImage = [CIImage imageWithCGImage:self.CGImage];
    
    [filter setValue:beginImage forKey:kCIInputImageKey];
    // 得到过滤后的图片
    CIImage *outputImage = [filter outputImage];
    // 转换图片, 创建基于GPU的CIContext对象
    CIContext *context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    // 显示图片
    
    // 释放C对象
    CGImageRelease(cgimg);
    
    return newImg;
}


#pragma mark 修改饱和度
- (UIImage *)imageWithSaturation:(CGFloat)saturation
{
    CIFilter * filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:[NSNumber numberWithFloat:saturation] forKey:@"inputSaturation"];
    return [self imageWithFilter:filter];
}


#pragma mark 修改亮度
- (UIImage *)imageWithBrightness:(CGFloat)brightness
{
    CIFilter * filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputBrightness"];
    return [self imageWithFilter:filter];
}

#pragma mark 修改对比度
- (UIImage *)imageWithContrast:(CGFloat)contrast
{
    CIFilter * filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputContrast"];
    return [self imageWithFilter:filter];
}


- (UIColor*) getPixelColorAtLocation:(CGPoint)point{
    UIColor* color = nil;
    CGImageRef inImage = self.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:
                          inImage];
    if (cgctx == NULL) {
        return nil; /* error */
    }
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    
    CGFloat newY = point.y;
    if (point.y >= h) {
        newY = h - 1;
    }
    if (point.y < 0) {
        newY = 0;
    }
    
    CGFloat newX = point.x;
    if (point.x >= w) {
        newX = w - 1;
    }
    if (point.x < 0) {
        newX = 0;
    }
    point = CGPointMake(newX, newY);
    
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        NSLog(@"%d %d  %d %d %lf  %lf",red,green,blue,alpha,point.x,point.y);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:
                 (blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) {
        free(data);
    }
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    NSInteger bitmapByteCount;
    NSInteger bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,pixelsWide,pixelsHigh,8,bitmapBytesPerRow,colorSpace,kCGImageAlphaPremultipliedFirst);
    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}

#pragma mark 用颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


-(UIImage *)boxblurImageWithBlur:(CGFloat)blur {
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage* destImage = [UIImage imageWithData:imageData];
    
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
