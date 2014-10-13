//
//  SHLUILabel.m
//  MyLabel
//
//  Created by showhillLee on 14-3-16.
//  Copyright (c) 2014年 showhilllee. All rights reserved.
//

#import "SHLUILabel.h"
#import <CoreText/CoreText.h>
#import "TypefaceConfig.h"

@interface SHLUILabel (){
    
    CGFontRef  _font_ref;
    UIColor  * _fontColor;
    fontTable* _currentTable;
    NSString * _fontPath;
    CGFloat    _fontSize;
    
@private
    NSMutableAttributedString *attributedString;

}
- (void) initAttributedString;
@end

@implementation SHLUILabel

@synthesize characterSpacing = characterSpacing_;

@synthesize linesSpacing = linesSpacing_;

@synthesize paragraphSpacing = _paragraphSpacing;


- (id)initWithFrame:(CGRect)frame
{
    //初始化字间距、行间距
    if(self =[super initWithFrame:frame])
        
    {
        self.backgroundColor = [UIColor whiteColor];
        self.characterSpacing = 1.5f;
        self.linesSpacing = 3.f;
        self.paragraphSpacing = 10.0f;
        _fontPath = nil;
        _fontSize = 15;
    }
    
    return self;
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
/*
 *开始绘制
 */
-(void) drawTextInRect:(CGRect)requestedRect
{
//    [self initAttributedString];
    [self loadFont];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextClearRect(context, requestedRect);
    
    CGContextSetFont(context, _font_ref);
    //    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
    CGContextSetTextMatrix(context , CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, 0.0, 0.0));
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    UIColor * strokeColor = self.textColor;
    CGContextSetFillColorWithColor(context, strokeColor.CGColor);
    
    
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    
    CGContextSetFontSize(context, _fontSize);
    
    NSArray * array =  [attributedString.mutableString componentsSeparatedByString:@"\n"];
    
    CGFloat lineLength = 0.f;
    
    CGFloat x = 20;
    CGFloat y = 20;
    CGSize size = [array[0] sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:_fontSize]];
    if (array.count>1 ||size.width>self.frame.size.height -20) {
        y = 10;
    }
    for (NSString * str in array) {
        lineLength = .0f;
        x = 20;
        
        
        NSArray * array1 = [str componentsSeparatedByString:@" "];
        
        for (NSString * str1 in array1) {
            
            CGSize size = [str1 sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:_fontSize]];
            if ((lineLength + size.width)>self.frame.size.height -20) {
                y += linesSpacing_ * 7;
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
        y += linesSpacing_ * 7;
    }
    UIGraphicsPushContext(context);
}

/*
 *绘制前获取label高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width
{
    [self initAttributedString];
    
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);    //string 为要计算高度的NSAttributedString
    
    CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 100000 - line_y + (int) descent +1;//+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
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

/*
 *初始化AttributedString并进行相应设置
 */
- (void) initAttributedString
{
    if(attributedString==nil){
        NSString *labelString = self.text;
        
        //创建AttributeString
        attributedString =[[NSMutableAttributedString alloc]initWithString:labelString];
        
        //设置字体及大小
        CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)self.font.fontName,self.font.pointSize,NULL);
        [attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0,[attributedString length])];
        
        //设置字间距
        long number = self.characterSpacing;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
        CFRelease(num);
        /*
         if(self.characterSpacing)
         {
         long number = self.characterSpacing;
         CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
         [attributedString addAttribute:(id)kCTKernAttributeName value:(id)num range:NSMakeRange(0,[attributedString length])];
         CFRelease(num);
         }
         */
        
        //设置字体颜色
        [attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(self.textColor.CGColor) range:NSMakeRange(0,[attributedString length])];
        
        //创建文本对齐方式
        CTTextAlignment alignment = kCTLeftTextAlignment;
        if(self.textAlignment == NSTextAlignmentCenter)
        {
            alignment = kCTCenterTextAlignment;
        }
        if(self.textAlignment == NSTextAlignmentRight)
        {
            alignment = kCTRightTextAlignment;
        }
        
        CTParagraphStyleSetting alignmentStyle;
        
        alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
        
        alignmentStyle.valueSize = sizeof(alignment);
        
        alignmentStyle.value = &alignment;
        
        //设置文本行间距
        /*
         CGFloat lineSpace = self.linesSpacing;
         */
        CGFloat lineSpace = self.linesSpacing;
        CTParagraphStyleSetting lineSpaceStyle;
        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
        lineSpaceStyle.valueSize = sizeof(lineSpace);
        lineSpaceStyle.value =&lineSpace;
        
        //设置文本段间距
        CGFloat paragraphSpacings = self.paragraphSpacing;
        CTParagraphStyleSetting paragraphSpaceStyle;
        paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
        paragraphSpaceStyle.valueSize = sizeof(CGFloat);
        paragraphSpaceStyle.value = &paragraphSpacings;
        
        //创建设置数组
        CTParagraphStyleSetting settings[ ] ={alignmentStyle,lineSpaceStyle,paragraphSpaceStyle};
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings ,3);
        
        //给文本添加设置
        [attributedString addAttribute:(id)kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0 , [attributedString length])];
        CFRelease(helveticaBold);
    }
}

/*
 *覆写setText方法
 */
- (void) setText:(NSString *)text
{
    [super setText:text];
}
@end
