//
//  SongObject.h
//  TifWayMusic
//
//  Created by maple on 13-8-30.
//
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "model.h"

@interface SongObject :Model

@property (strong, nonatomic) NSString *songId;                        //歌曲ID,ipod歌曲没有
@property (strong, nonatomic) NSString *songName;                      //歌曲名称
@property (strong, nonatomic) NSString *artist;                        //歌手
@property (strong, nonatomic) NSString *artistId;                      //歌手Id
@property (strong, nonatomic) NSString *songUrl;                       //歌曲路径
@property (strong, nonatomic) NSString *imageUrl;                      //歌曲图片路径
@property (strong, nonatomic) NSString *avatarImageUrl;                //歌手图片路径
@property (strong, nonatomic) NSString *albumTitle;                    //专辑名称
@property (strong, nonatomic) NSString *songType;                      //歌曲类型(是否为ipod歌曲)
@property (strong, nonatomic) NSNumber *duration;                      //歌曲长度
@property (strong, nonatomic) NSNumber *rateSize;                      //比特率
@property (strong, nonatomic) NSString *songSize;                      //歌曲文件大小
@property (strong, nonatomic) NSNumber *playTime;                      //播放次数
@property (strong, nonatomic) NSNumber *playDate;                      //播放时间
@property (strong, nonatomic) NSString *lrc_url;                       //lrc歌词地址

@property (strong, nonatomic) NSString *imagePath;                     //图片路径
@property (strong, nonatomic) NSString *songLocalPath;                 //歌曲本地存放路径

-(NSDictionary *)dictionary;
- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (SongObject *)songWithResult:(FMResultSet*)result;//获取歌曲信息


@end
