//
//  TypefaceConfig.h
//  TTCYMnglLibrary
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#ifndef TTCYMnglLibrary_TypefaceConfig_h
#define TTCYMnglLibrary_TypefaceConfig_h

#define kUnicodeHighSurrogateStart 0xD800
#define kUnicodeHighSurrogateEnd 0xDBFF
#define kUnicodeHighSurrogateMask kUnicodeHighSurrogateStart
#define kUnicodeLowSurrogateStart 0xDC00
#define kUnicodeLowSurrogateEnd 0xDFFF
#define kUnicodeLowSurrogateMask kUnicodeLowSurrogateStart
#define kUnicodeSurrogateTypeMask 0xFC00
#define UnicharIsHighSurrogate(c) ((c & kUnicodeSurrogateTypeMask) == kUnicodeHighSurrogateMask)
#define UnicharIsLowSurrogate(c) ((c & kUnicodeSurrogateTypeMask) == kUnicodeLowSurrogateMask)
#define ConvertSurrogatePairToUTF32(high, low) ((UInt32)((high - 0xD800) * 0x400 + (low - 0xDC00) + 0x10000))

typedef enum {
	kFontTableFormat4 = 4,
	kFontTableFormat12 = 12,
} FontTableFormat;

typedef struct fontTable {
	NSUInteger retainCount;
	CFDataRef cmapTable;
	FontTableFormat format;
	union {
		struct {
			UInt16 segCountX2;
			UInt16 *endCodes;
			UInt16 *startCodes;
			UInt16 *idDeltas;
			UInt16 *idRangeOffsets;
		} format4;
		struct {
			UInt32 nGroups;
			struct {
				UInt32 startCharCode;
				UInt32 endCharCode;
				UInt32 startGlyphCode;
			} *groups;
		} format12;
	} cmap;
} fontTable;

static FontTableFormat supportedFormats[] = { kFontTableFormat4, kFontTableFormat12 };
static size_t supportedFormatsCount = sizeof(supportedFormats) / sizeof(FontTableFormat);

static fontTable *newFontTable(CFDataRef cmapTable, FontTableFormat format) {
	fontTable *table = (struct fontTable *)malloc(sizeof(struct fontTable));
	table->retainCount = 1;
	table->cmapTable = CFRetain(cmapTable);
	table->format = format;
	return table;
}

static void releaseFontTable(fontTable *table) {
	if (table != NULL) {
		if (table->retainCount <= 1) {
			CFRelease(table->cmapTable);
			free(table);
		} else {
			table->retainCount--;
		}
	}
}
static fontTable *readFontTableFromCGFont(CGFontRef font) {
	
    CFDataRef cmapTable = CGFontCopyTableForTag(font, 'cmap');
    
	const UInt8 * const bytes = CFDataGetBytePtr(cmapTable);
	UInt16 numberOfSubtables = OSReadBigInt16(bytes, 2);
	const UInt8 *unicodeSubtable = NULL;
	UInt16 unicodeSubtablePlatformSpecificID;
	FontTableFormat unicodeSubtableFormat;
	const UInt8 * const encodingSubtables = &bytes[4];
    
	for (UInt16 i = 0; i < numberOfSubtables; i++) {
		
        const UInt8 * const encodingSubtable = &encodingSubtables[8 * i];
		UInt16 platformID = OSReadBigInt16(encodingSubtable, 0);
		UInt16 platformSpecificID = OSReadBigInt16(encodingSubtable, 2);
		
		if (platformID == 0 || (platformID == 3 && platformSpecificID == 1)) {
			BOOL preferred = NO;
			if (unicodeSubtable == NULL) {
				preferred = YES;
			} else if (platformID == 0 && platformSpecificID > unicodeSubtablePlatformSpecificID) {
				preferred = YES;
			}
			if (preferred) {
				UInt32 offset = OSReadBigInt32(encodingSubtable, 4);
				const UInt8 *subtable = &bytes[offset];
				UInt16 format = OSReadBigInt16(subtable, 0);
				
                for (size_t i = 0; i < supportedFormatsCount; i++) {
					
                    if (format == supportedFormats[i]) {
						if (format >= 8) {
							UInt16 formatFrac = OSReadBigInt16(subtable, 2);
							if (formatFrac != 0) {
								continue;
							}
						}
						unicodeSubtable = subtable;
						unicodeSubtablePlatformSpecificID = platformSpecificID;
						unicodeSubtableFormat = format;
						break;
					}
				}
			}
		}
	}
    
	fontTable *table = NULL;
	
    if (unicodeSubtable != NULL) {
		
        table = newFontTable(cmapTable, unicodeSubtableFormat);
		
        switch (unicodeSubtableFormat) {
			case kFontTableFormat4:
				table->cmap.format4.segCountX2 = OSReadBigInt16(unicodeSubtable, 6);
				table->cmap.format4.endCodes = (UInt16*)&unicodeSubtable[14];
				table->cmap.format4.startCodes = (UInt16*)&((UInt8*)table->cmap.format4.endCodes)[table->cmap.format4.segCountX2+2];
				table->cmap.format4.idDeltas = (UInt16*)&((UInt8*)table->cmap.format4.startCodes)[table->cmap.format4.segCountX2];
				table->cmap.format4.idRangeOffsets = (UInt16*)&((UInt8*)table->cmap.format4.idDeltas)[table->cmap.format4.segCountX2];
				break;
			case kFontTableFormat12:
				table->cmap.format12.nGroups = OSReadBigInt32(unicodeSubtable, 12);
				table->cmap.format12.groups = (void *)&unicodeSubtable[16];
				break;
			default:
				releaseFontTable(table);
				table = NULL;
		}
	}
	CFRelease(cmapTable);
	return table;
}

static void mapCharactersToGlyphsInFont(const fontTable *table, unichar characters[], size_t charLen, CGGlyph outGlyphs[], size_t *outGlyphLen)
{
	if (table != NULL) {
		NSUInteger j = 0;
		switch (table->format) {
			case kFontTableFormat4: {
				for (NSUInteger i = 0; i < charLen; i++, j++) {
					
                    unichar c = characters[i];
					UInt16 segOffset;
					BOOL foundSegment = NO;
					
                    for (segOffset = 0; segOffset < table->cmap.format4.segCountX2; segOffset += 2) {
						UInt16 endCode = OSReadBigInt16(table->cmap.format4.endCodes, segOffset);
						if (endCode >= c) {
							foundSegment = YES;
							break;
						}
					}
					if (!foundSegment) {
						outGlyphs[j] = 0;
					} else {
						UInt16 startCode = OSReadBigInt16(table->cmap.format4.startCodes, segOffset);
						
                        if (!(startCode <= c)) {
							outGlyphs[j] = 0;
						} else {
							UInt16 idRangeOffset = OSReadBigInt16(table->cmap.format4.idRangeOffsets, segOffset);
							if (idRangeOffset == 0) {
								UInt16 idDelta = OSReadBigInt16(table->cmap.format4.idDeltas, segOffset);
								outGlyphs[j] = (c + idDelta) % 65536;
							} else {
								UInt16 glyphOffset = idRangeOffset + 2 * (c - startCode);
								outGlyphs[j] = OSReadBigInt16(&((UInt8*)table->cmap.format4.idRangeOffsets)[segOffset], glyphOffset);
							}
						}
					}
				}
				break;
			}
			case kFontTableFormat12: {
				UInt32 lastSegment = UINT32_MAX;
				
                for (NSUInteger i = 0; i < charLen; i++, j++) {
					unichar c = characters[i];
					UInt32 c32 = c;
					
                    if (UnicharIsHighSurrogate(c)) {
						if (i+1 < charLen) { // do we have another character after this one?
							unichar cc = characters[i+1];
							if (UnicharIsLowSurrogate(cc)) {
								c32 = ConvertSurrogatePairToUTF32(c, cc);
								i++;
							}
						}
					}
        
					__typeof__(table->cmap.format12.groups[0]) *foundGroup = NULL;
					
                    if (c32 <= 0x7F) {
						// ASCII
						for (UInt32 idx = 0; idx < table->cmap.format12.nGroups; idx++) {
							__typeof__(table->cmap.format12.groups[idx]) *group = &table->cmap.format12.groups[idx];
							if (c32 < OSSwapBigToHostInt32(group->startCharCode)) {
								// we've fallen into a hole
								break;
							} else if (c32 <= OSSwapBigToHostInt32(group->endCharCode)) {
								// this is the range
								foundGroup = group;
								break;
							}
						}
					} else {
						
						UInt32 maxJump = (lastSegment == UINT32_MAX ? UINT32_MAX / 2 : 8);
						UInt32 lowIdx = 0, highIdx = table->cmap.format12.nGroups; // highIdx is the first invalid idx
						UInt32 pivot = (lastSegment == UINT32_MAX ? lowIdx + (highIdx - lowIdx) / 2 : lastSegment);
						
                        while (highIdx > lowIdx) {
							__typeof__(table->cmap.format12.groups[pivot]) *group = &table->cmap.format12.groups[pivot];
                            
							if (c32 < OSSwapBigToHostInt32(group->startCharCode)) {
								highIdx = pivot;
							} else if (c32 > OSSwapBigToHostInt32(group->endCharCode)) {
								lowIdx = pivot + 1;
							} else {
								// we've hit the range
								foundGroup = group;
								break;
							}
                            
							if (highIdx - lowIdx > maxJump * 2) {
								if (highIdx == pivot) {
									pivot -= maxJump;
								} else {
									pivot += maxJump;
								}
								maxJump *= 2;
							} else {
								pivot = lowIdx + (highIdx - lowIdx) / 2;
							}
						}//while
                        
						if (foundGroup != NULL) lastSegment = pivot;
					}//else
					if (foundGroup == NULL) {
						outGlyphs[j] = 0;
					} else {
						outGlyphs[j] = (CGGlyph)(OSSwapBigToHostInt32(foundGroup->startGlyphCode) +
												 (c32 - OSSwapBigToHostInt32(foundGroup->startCharCode)));
					}
				}//for
				break;
			}//case
		}//switch
        
		if (outGlyphLen != NULL) *outGlyphLen = j;
        
	} else {
		
		bzero(outGlyphs, charLen*sizeof(CGGlyph));
		if (outGlyphLen != NULL) *outGlyphLen = 0;
	}
}

#endif
