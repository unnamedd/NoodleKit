//
//  NSWindow-Zoom.m
//  NoodleKit
//
//  Created by Paul Kim on 6/18/07.
//  Copyright 2007-2009 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSWindow-NoodleEffects.h"
#import <Carbon/Carbon.h>


@implementation NSWindow (NoodleEffects)

- (void)animateToFrame:(NSRect)frameRect duration:(NSTimeInterval)duration
{
    NSViewAnimation     *animation;

    animation = [[NSViewAnimation alloc] initWithViewAnimations:
        @[@{NSViewAnimationTargetKey: self,
            NSViewAnimationEndFrameKey: [NSValue valueWithRect:frameRect]}]];
    
    animation.duration = duration;
    animation.animationBlockingMode = NSAnimationBlocking;
    animation.animationCurve = NSAnimationLinear;
    [animation startAnimation];
    
}

- (NSWindow *)_createZoomWindowWithRect:(NSRect)rect
{
    NSWindow        *zoomWindow;
    NSImageView     *imageView;
    NSImage         *image;
    NSRect          frame;
    BOOL            isOneShot;
    
    frame = self.frame;

    isOneShot = self.oneShot;
	if (isOneShot)
	{
		self.oneShot = NO;
	}
    
	if (self.windowNumber <= 0)
	{
		CGFloat		alpha;
		
        // Force creation of window device by putting it on-screen. We make it transparent to minimize the chance of
		// visible flicker.
		alpha = self.alphaValue;
		self.alphaValue = 0.0;
        [self orderBack:self];
        [self orderOut:self];
		self.alphaValue = alpha;
	}
    
    image = [[NSImage alloc] initWithSize:frame.size];
    [image lockFocus];
    // Grab the window's pixels
    NSCopyBits([self gState], NSMakeRect(0.0, 0.0, frame.size.width, frame.size.height), NSZeroPoint);
    [image unlockFocus];
	image.cacheMode = NSImageCacheNever;
    
    zoomWindow = [[NSWindow alloc] initWithContentRect:rect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    zoomWindow.backgroundColor = [NSColor colorWithDeviceWhite:0.0 alpha:0.0];
    zoomWindow.hasShadow = self.hasShadow;
	zoomWindow.level = self.level;
    [zoomWindow setOpaque:NO];
    [zoomWindow setReleasedWhenClosed:YES];
    [zoomWindow useOptimizedDrawing:YES];
    
    imageView = [[NSImageView alloc] initWithFrame:[zoomWindow contentRectForFrameRect:frame]];
    imageView.image = image;
    imageView.imageFrameStyle = NSImageFrameNone;
    imageView.imageScaling = NSScaleToFit;
    imageView.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    
    zoomWindow.contentView = imageView;
    
    // Reset one shot flag
    self.oneShot = isOneShot;
    
    return zoomWindow;
}

- (void)zoomOnFromRect:(NSRect)startRect
{
    NSRect              frame;
    NSWindow            *zoomWindow;

    if (self.visible)
    {
        return;
    }
        
    frame = self.frame;
    
    zoomWindow = [self _createZoomWindowWithRect:startRect];
   
	[zoomWindow orderFront:self];

    [zoomWindow animateToFrame:frame duration:[zoomWindow animationResizeTime:frame] * 0.4];
    
	[self makeKeyAndOrderFront:self];	
	[zoomWindow close];
}

- (void)zoomOffToRect:(NSRect)endRect
{
    NSRect              frame;
    NSWindow            *zoomWindow;
    
    frame = self.frame;
    
    if (!self.visible)
    {
        return;
    }
    
    zoomWindow = [self _createZoomWindowWithRect:frame];
    
	[zoomWindow orderFront:self];
    [self orderOut:self];
    
    [zoomWindow animateToFrame:endRect duration:[zoomWindow animationResizeTime:endRect] * 0.4];
    
	[zoomWindow close];    
}

@end
