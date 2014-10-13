//
//  MnglSongCell.m
//  TTCYMnglLibrary
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "MnglSongCell.h"

@interface MnglSongCell()

@property (nonatomic,strong)UILabel * titleLabel;

@end

@implementation MnglSongCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self initCondition];
        [self createTitleLabel];
//        [self createSpereateLine];
    }
    return self;
}
-(void)initCondition{
    [self.textLabel removeFromSuperview];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI);
    [self setTransform:rotate];
}
-(void)createTitleLabel
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.bounds.size.height/6.0f, self.bounds.size.width-20, self.bounds.size.height*2/3.0f)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:20.0];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_titleLabel];
}
-(void)createSpereateLine
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
    view.backgroundColor = [UIColor colorWithWhite:.7 alpha:1];
    [self addSubview:view];
}
-(void)setUpCellWithText:(NSString *)text
{
    _titleLabel.frame = CGRectMake(5, 20, self.bounds.size.width-10, self.bounds.size.height - 10);
    _titleLabel.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    _titleLabel.text = text;
    _titleLabel.textColor = self.fontColor;
}
//-(void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextClearRect(context, rect);
//    
//    CGContextSetFont(context, font_ref);
//    
//    CGContextSetTextDrawingMode(context, kCGTextFillStroke);
//    
//    CGContextSetFillColorWithColor(context, _fontColor.CGColor);
//    UIColor * strokeColor = [UIColor colorWithWhite:1 alpha:.7f];
//    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
//    
//    CGContextSetFontSize(context, 30.0f);
//    
//    CGGlyph glyphs[[self.text length]];
//    size_t glyphCount;
//    unichar textChars[[_text length]];
//    [_text getCharacters:textChars range:NSMakeRange(0, _text.length)];
//    
//    mapCharactersToGlyphsInFont(currentTable, textChars, _text.length, glyphs, &glyphCount);
//    
//    CGAffineTransform textTransform = CGAffineTransformMake(1.0, .0, .0, -.8, .0, .0);
//    CGContextSetTextMatrix(context, textTransform);
//    CGContextShowGlyphsAtPoint(context,20, 25, glyphs, [self.text length]);
//}

@end
