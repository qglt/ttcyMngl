//
//  AppsAPIConstants.h
//  AppsTemplate
//
//  Created by Rayco on 13-2-7.
//  Copyright (c) 2013年 Apps123. All rights reserved.
//

////活动网后台接口地址【歌手大赛】192.168.0.155:8002 http://star.ttcy.com/api/GetActiveInfo.ashx
#define ID_API_SERVER1 @"http://star.ttcy.com/api/GetActiveInfo.ashx"
////音乐网后台接口地址【在线音乐和本地音乐】http://192.168.0.155/API/help.aspx http://ios.ttcy.com/API/GetMusicInfo.ashx
#define ID_API_SERVER2 @"http://ios.ttcy.com/API/GetMusicInfo.ashx"

#define ID_API_SERVER3 @"http://www.ttcy.com/api/GetInfoTest.ashx"

#define ID_API_SERVER4 @"http://api.ttcy.com/main.ashx"

////歌词
#define LRC_API_URL @"http://www.ttcy.com/ttcy/music/lrc"

#define SIGN_CODE @"12345678"
//link api

//在线音乐
#define GET_SINGER_KIND   @"get_singer_kind"             //获取歌手分类
#define GET_SINGER_LIST   @"get_singer_list"             //获取歌手列表
#define GET_SINGER_DETAIL @"get_singer_detail"           //获取歌手详细信息
#define GET_SONG_LIST     @"get_songs_list"              //歌手的歌曲列表
#define VOTE_SINGER       @"vote_singer"                 //关注.推荐歌手（1.推荐，2.关注）
#define GET_ALBUM_KIND    @"get_album_kind"              //专辑分类
#define GET_ALBUM_LIST    @"get_album_list"              //专辑列表
#define GET_ALBUMN_DETAIL @"get_album_detail"            //专辑内容详情
#define OPERATE_SONG      @"operate_song"                //专辑歌曲功能、推荐歌曲功能、排行歌曲功能、搜索歌曲功能
#define GET_REC_SONGS     @"get_rec_songs"               //推荐歌曲列表
#define OPERATE_COLLECT   @"operate_collect"             //歌手、专辑收藏（1.歌手，2.专辑）
#define DELETE_COLLECT    @"del_collect"                 //收藏删除
#define KEYWORDS_SEARCH   @"keywords_search"             //关键字搜索列表
#define GET_SINGER_ALBUM  @"get_singer_album"            //歌手专辑列表
#define USER_COLLECT      @"user_collect"                //我的收藏
#define GET_RANK_LIST     @"get_rank_list"               //排行歌曲列表
#define REC_ALBUM         @"rec_album"                   //推荐专辑
#define GET_LYRIC         @"get_lyric"                   //歌词
#define ONLINE_AD         @"online_ad"                   //在线音乐广告
#define ONLINE_COLLECT    @"Online_Collect"              //收藏音乐

//本地音乐
#define CREATE_LIST      @"create_list"                  //创建列表
#define UPDATE_LIST_NAME @"update_list_name"             //重命名
#define DEL_LIST         @"del_list"                     //删除列表
#define ADD_SONG         @"add_song"                     //添加歌曲
#define LIST_INFO        @"list_info"                    //自建列表

//歌手大赛
#define GET_PLAYER_LIST        @"get_player_list"           //参赛选手
#define GET_PLAYER_DETAIL      @"get_player_detail"         //选手具体信息
#define GET_PLAYER_INFO        @"get_player_info"           //选手参赛视频、音乐、图片
#define VOTE_PLAYER            @"vote_player"               //投票
#define PLAYER_SEARCH          @"search"                    //搜索
#define ACTIVE_INTRODUCE       @"active_introduce"          //活动介绍、参赛方式
#define GET_ACTIVE_CONSULATION @"get_active_consultation"   //活动列表
#define GET_ACTIVE_DETAIL      @"get_active_detail"         //活动咨询详情

//设置
#define USER_REGISTER          @"Active_UserEntry_new"             //用户注册
#define USER_LOGIN             @"Active_Entry_new"                //登录
#define UPDATE_USER_INFO       @"update_user_info"          //编辑信息
#define UPDATE_USER_IMG        @"update_user_img"           //修改头像
#define FEEDBACK               @"feedback"                  //反馈
#define CHECK_APP              @"check_app"                 //检测更新
#define GET_MORE               @"get_more"                  //关于、使用帮助
