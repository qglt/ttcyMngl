//
//  DBManger_Define.h
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#ifndef TtcyMngl_DBManger_Define_h
#define TtcyMngl_DBManger_Define_h

//创建表
#define CREATE_TABLE @"CREATE TABLE IF NOT EXISTS %@(songId TEXT(100) , songName TEXT(100) , artist TEXT(100) , artistId TEXT(100) , songUrl TEXT(100) , imageUrl TEXT(100) , avatarImageUrl TEXT(100) , albumTitle TEXT(100) , songType TEXT(100) , duration INTEGER , rateSize INTEGER , songSize TEXT(100) , playTime INTEGER ,  playDate INTEGER , lrc_url TEXT(100) , imagePath Text(100) , songLocalPath Text(100))"

#define CREATE_USERINFO_TABLE @"CREATE TABLE IF NOT EXISTS %@(phone TEXT(100) , pass TEXT(100) , userIcon TEXT(100) , savePasswd TEXT(100))"

#define CREATE_COLLECTSONG_TABLE @"CREATE TABLE IF NOT EXISTS %@(songId TEXT(100) , songName TEXT(100) , artist TEXT(100) , artistId TEXT(100) , songUrl TEXT(100) , imageUrl TEXT(100) , avatarImageUrl TEXT(100) , albumTitle TEXT(100) , songType TEXT(100) , duration INTEGER , rateSize INTEGER , songSize TEXT(100) , playTime INTEGER ,  playDate INTEGER , lrc_url TEXT(100) , imagePath Text(100) , songLocalPath Text(100) , phone TEXT(100))"

#define TABLE_LocalSong @"localSong"
#define TABLE_CollectSong @"collectSong"
#define TABLE_DownloadSong @"downLoadSong"
#define TABLE_HistoryPlay @"historyPlay"
#define TABLE_USERINFO @"userInfo"

//在表中插入数据（17个参数）
#define INSERT_TABLE @"INSERT INTO %@(songId, songName, artist, artistId, songUrl, imageUrl, avatarImageUrl, albumTitle, songType, duration, rateSize, songSize, playTime, playDate, lrc_url, imagePath, songLocalPath) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
#define INSERT_USERINFO_TABLE @"INSERT INTO %@(phone, pass, userIcon, savePasswd) VALUES(?,?,?,?)"

#define INSERT_COLLECTSONG_TABLE @"INSERT INTO %@(songId, songName, artist, artistId, songUrl, imageUrl, avatarImageUrl, albumTitle, songType, duration, rateSize, songSize, playTime, playDate, lrc_url, imagePath, songLocalPath, phone) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

// 添加的17个参数
#define SONG_PARAMETER songObj.songId, songObj.songName, songObj.artist, songObj.artistId, songObj.songUrl, songObj.imageUrl, songObj.avatarImageUrl, songObj.albumTitle, songObj.songType, songObj.duration, songObj.rateSize, songObj.songSize, songObj.playTime, songObj.playDate, songObj.lrc_url, songObj.imagePath, songObj.songLocalPath

#define USER_PARAMETER userObj.phone, userObj.pass, userObj.userIcon, [NSString stringWithFormat:@"%d",userObj.savePasswd]

#define COLLECTSONG_PARAMETER songObj.songId, songObj.songName, songObj.artist, songObj.artistId, songObj.songUrl, songObj.imageUrl, songObj.avatarImageUrl, songObj.albumTitle, songObj.songType, songObj.duration, songObj.rateSize, songObj.songSize, songObj.playTime, songObj.playDate, songObj.lrc_url, songObj.imagePath, songObj.songLocalPath, phone

#endif
