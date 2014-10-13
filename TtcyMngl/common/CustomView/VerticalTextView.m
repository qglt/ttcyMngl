//
//  VerticalTextView.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-3.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "VerticalTextView.h"
#import <CoreText/CoreText.h>
#import "TypefaceConfig.h"

@interface VerticalTextView ()
{
    
    CGFontRef  _font_ref;
    UIColor  * _fontColor;
    fontTable* _currentTable;
    NSString * _fontPath;
    CGFloat    _fontSize;
    
@private
    NSMutableAttributedString *attributedString;
    
}
@property(nonatomic,assign) CGFloat characterSpacing;
@property(nonatomic,assign) CGFloat paragraphSpacing;
@property(nonatomic,assign) long    linesSpacing;

@end


@implementation VerticalTextView

@synthesize characterSpacing = characterSpacing_;

@synthesize linesSpacing = linesSpacing_;

@synthesize paragraphSpacing = _paragraphSpacing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setbaseCondition];
    }
    return self;
}
- (void)setbaseCondition
{
    self.dataDetectorTypes = UIDataDetectorTypeAll;
    
    self.backgroundColor = [UIColor whiteColor];
    self.characterSpacing = 1.5f;
    self.linesSpacing = 3.f;
    self.paragraphSpacing = 10.0f;
    _fontPath = nil;
    _fontSize = 15;
    self.backgroundColor = [UIColor clearColor];
    self.editable = NO;
}

-(void)font:(NSString *)fontPath size:(CGFloat)size
{
    _fontPath = fontPath;
    _fontSize = size;
    linesSpacing_ = size/4.0f;
}
-(void)loadFont{ // Get the path to our custom font and create a data provider.
    
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([_fontPath UTF8String]);
    
    // Create the font with the data provider, then release the data provider.
    
    _font_ref =CGFontCreateWithDataProvider(fontDataProvider);
    _currentTable=readFontTableFromCGFont(_font_ref);
    CGDataProviderRelease(fontDataProvider);
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

    [self loadFont];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFont(context, _font_ref);
    //    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    CGContextSetTextMatrix(context , CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, 0.0));
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    UIColor * strokeColor = [UIColor redColor];
    CGContextSetFillColorWithColor(context, strokeColor.CGColor);
    
    
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    
    CGContextSetFontSize(context, _fontSize);
    
    NSArray * array =  [_showText componentsSeparatedByString:@"\n"];
    
    CGFloat lineLength = 0.f;
    
    CGFloat x = 20;
    CGFloat y = 20;
    
    for (NSString * str in array) {
        lineLength = .0f;
        x = 20;
        NSArray * array1 = [str componentsSeparatedByString:@" "];
        
        for (NSString * str1 in array1) {
            
            CGSize size = [str1 sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:_fontSize]];
            if ((lineLength + size.width)>self.frame.size.height -20) {
                y += linesSpacing_ * 9;
                x = 20;
                lineLength = 0.f;
            }
            
            CGGlyph glyphs[[str1 length]];
            size_t glyphCount;
            unichar textChars[[str1 length]];
            
            [str1 getCharacters:textChars range:NSMakeRange(0, str1.length)];
            
            mapCharactersToGlyphsInFont(_currentTable, textChars, str1.length, glyphs, &glyphCount);
            
            CGContextShowGlyphsAtPoint(context, x, y, glyphs, [str1 length]);
            
            x += size.width + characterSpacing_ * 5;
            lineLength = x;
        }
        y += linesSpacing_ * 9;
    }
    UIGraphicsPushContext(context);
    
    
}
/*
 *覆写setText方法
 */
- (void) setText:(NSString *)text
{
    [super setText:text];
}
//外部调用设置字间距
-(void)setCharacterSpacing:(CGFloat)characterSpacing
{
    characterSpacing_ = characterSpacing;
    [self setNeedsDisplay];
}

//外部调用设置行间距
-(void)setLinesSpacing:(long)linesSpacing
{
    linesSpacing_ = linesSpacing;
    [self setNeedsDisplay];
}
@end
