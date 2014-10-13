//
//  SongObject.m
//  TifWayMusic
//
//  Created by maple on 13-8-30.
//
//

#import "SongObject.h"

@implementation SongObject


//DAO是数据访问对象
- (id)init
{
    if ((self = [super init])) {
        
    }
    return self;
}

-(NSDictionary *)dictionary {
    if (_artist == nil) {
        _artist = @"";
    }
    if (_songName == nil) {
        _songName = @"";
    }
    if (_songUrl == nil) {
        _songUrl = @"";
    }
    if (_avatarImageUrl == nil) {
        _avatarImageUrl = @"";
    }
    if (_albumTitle == nil) {
        _albumTitle = @"";
    }
    if (_songType == nil) {
        _songType = @"";
    }
    if (_duration == nil) {
        _duration = [NSNumber numberWithInt:0];
    }
    if (_imageUrl == nil) {
        _imageUrl = @"";
    }
    if (_rateSize == nil) {
        _rateSize = [NSNumber numberWithInt:0];
    }
    if (_songSize == nil) {
        _songSize = @"";
    }
    if (_playTime == nil) {
        _playTime = [NSNumber numberWithInt:0];
    }
    if (_songId == nil) {
        _songId = @"";
    }
    if (_artistId == nil) {
        _artistId = @"";
    }
    if (_playDate == nil) {
        _playDate = [NSNumber numberWithInt:0];
    }
    if (_lrc_url == nil) {
        _lrc_url = @"";
    }
    if (_imagePath == nil) {
        _imagePath = @"";
    }
    if (_songLocalPath == nil) {
        _songLocalPath = @"";
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            _artist,@"artist",
            _songName,@"songName",
            _songUrl,@"songUrl",
            _avatarImageUrl,@"avatarImageUrl",
            _albumTitle,@"albumTitle",
            _songType,@"songType",
            _duration,@"duration",
            _imageUrl,@"imageUrl",
            _rateSize,@"rateSize",
            _songSize,@"songSize",
            _playTime,@"playTime",
            _songId,@"songId",
            _artistId,@"artistId",
            _playDate,@"playDate",
            _lrc_url,@"lrc_url",
            _imagePath,@"imagePath",
            _songLocalPath,@"songLocalPath",
            nil];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init])) {
        if (dictionary) {
            
            self.artist = [dictionary objectForKey:@"artist"];
            self.songName = [dictionary objectForKey:@"songName"];
            self.songUrl = [dictionary objectForKey:@"songUrl"];
            self.avatarImageUrl = [dictionary objectForKey:@"avatarImageUrl"];
            self.albumTitle = [dictionary objectForKey:@"albumTitle"];
            self.songType = [dictionary objectForKey:@"songType"];
            self.duration = [dictionary objectForKey:@"duration"];
            self.imageUrl = [dictionary objectForKey:@"imageUrl"];
            self.rateSize = [dictionary objectForKey:@"rateSize"];
            self.songSize = [dictionary objectForKey:@"songSize"];
            self.playTime = [dictionary objectForKey:@"playTime"];
            self.songId = [dictionary objectForKey:@"songID"];
            self.artistId = [dictionary objectForKey:@"artistId"];
            self.playDate = [dictionary objectForKey:@"playDate"];
            self.lrc_url  = [dictionary objectForKey:@"lrc_url"];
            self.imagePath = [dictionary objectForKey:@"imagePath"];
            self.songLocalPath = [dictionary objectForKey:@"songLocalPath"];
        }
    }
    return self;
}

//获取歌曲信息,把歌曲封装成 SongObject
+ (SongObject *)songWithResult:(FMResultSet *)result
{
    SongObject *song = [[SongObject alloc] init];
    song.songId = [result stringForColumn:@"songId"];
    song.songName = [result stringForColumn:@"songName"];
    song.artist = [result stringForColumn:@"artist"];
    song.artistId = [result stringForColumn:@"artistId"];
    song.songUrl = [result stringForColumn:@"songUrl"];
    song.imageUrl = [result stringForColumn:@"imageUrl"];
    song.avatarImageUrl = [result stringForColumn:@"avatarImageUrl"];
    song.albumTitle = [result stringForColumn:@"albumTitle"];
    song.songType = [result stringForColumn:@"songType"];
    song.duration = [NSNumber numberWithInt:[result intForColumn:@"duration"]];
    song.rateSize = [NSNumber numberWithInt:[result intForColumn:@"rateSize"]];
    song.songSize = [result stringForColumn:@"songSize"];
    song.playTime = [NSNumber numberWithInt:[result intForColumn:@"playTime"]];
    song.playDate = [NSNumber numberWithInt:[result intForColumn:@"playDate"]];
    song.lrc_url = [result stringForColumn:@"lrc_url"];
    song.imagePath = [result stringForColumn:@"imagePath"];
    song.songLocalPath = [result stringForColumn:@"songLocalPath"];
    return song;
}

+(id)initWithDict:(NSDictionary*)dict{
 
    return [[SongObject alloc]initWithDictionary:dict];

}

-(NSString *)description
{
    return self.songUrl;
}
@end
