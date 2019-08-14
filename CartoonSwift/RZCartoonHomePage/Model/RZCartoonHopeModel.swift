//
//  CartoonCartoonHopeModel.swift
//  CartoonSwift
//
//  Created by Mac on 2019/7/23.
//  Copyright © 2019 Cartoon. All rights reserved.
//

import Foundation
import HandyJSON

class CartoonHopeBaseModel: HandyJSON {
    var comicLists : [CartoonHopeModel]?
    var editTime : Int = 0
    var galleryItems : [CartoonGalleryItemsModel]?
    var textItems : [CartoonTextItemsModel]?
    var newVipList : [CartoonHopeModel]?
    var newSubscribeList : [CartoonHopeModel]?
    var rankinglist : [CartoonHopeModel]?
    var rankingList : [CartoonHopeModel]? // 分类列表
    
    var chapter_list : [CartoonChapterStaticModel]? // 详情里面的 章节列表
    var comic : CartoonComicStaticModel?
    var otherWorks : [CartoonDetailStaticModel]?

    required init(){}
}
/**分类列表 -- 子列表*/
class CartoonCommicsModel : HandyJSON {
    var comics : [CartoonCateDetailItemModel]?
    var defaultParameters : CartoonCommentDefaultModel?
    var hasMore : Int = 0
    var page : Int = 0
    var spinnerList : [CartoonSpinnerListModel]?
    required init(){}
}

class CartoonGuessLikeBaseModel : HandyJSON {
    var comics : [CartoonGuessLikeModel]? // 猜你喜欢列表
    var last_modified : Int = 0
    var normal : Int = 0
    
    required init(){}
}

/// 详情界面realTime的base model
class CartoonDetailRealtimeModel: HandyJSON {
    var comic: CartoonComicRealtimeModel?
    var chapter_list: [CartoonChapterRealtimeModel]?
    required init(){}
}

/// 评论的列表model
class CartoonCommentBaseModel : HandyJSON {
    var commentCount: Int = 0
    var commentList: [CartoonCommentModel]?
    var defaultParameters : CartoonCommentDefaultModel?
    var hasMore: Bool = false
    var objectId: Int = 0
    var objectType: String?
    var page: Int = 0
    var pageCount: Int = 0
    var serverNextPage: Int = 0
    var spinnerList : [CartoonSpinnerListModel]?
    required init(){}
}

class CartoonHotSearchModel: HandyJSON {
    var defaultSearch : String?
    var hotItems : [CartoonSearchHotItemModel]?
    required init() {}
}

class CartoonSearchRelativeModel: HandyJSON {
    var message : String?
    var stateCode : Int = 0
    var returnData : [CartoonSearchRelativeItemModel]?
    required init() {}
}

class CartoonSearchRelativeItemModel: HandyJSON {
    var comic_id : Int = 0
    var name : String?
    required init() {}
}


class CartoonChapterModel: HandyJSON {
    var status: Int = 0
    var chapter_id: Int = 0
    var type: Int = 0
    var image_list: [CartoonChapterImageModel]?
    required init() {}
}


enum CartoonHopeModelType : Int , HandyJSONEnum {
    case none = 0
    case update = 3
    case thematic = 5
    case animation = 9
    case billboard = 11
}

class CartoonHopeModel: HandyJSON {
    var itemSize : CGSize = CGSize(width: 0.0, height: 0.0)
    var itemHeight : CGFloat = 0.0
    var argName : String?
    var argType : Int = 0
    var argValue : Int = 0
    var argCon : Int = 0
    var comicType: CartoonHopeModelType = .none
    var canedit: Bool = false
    var sortId: Int = 0
    var titleIconUrl: String?
    var newTitleIconUrl: String?
    var description: String?
    var itemTitle : String?
    var comics : [CartoonItemModel]?
    
    var rankingType : String?
    var subTitle : String?
    var title : String?
    var cover : String?
    
    var sortName : String?
    var isLike : Int = 0
    required init() {}
}

class CartoonItemModel: HandyJSON {
    var author_name : String?
    var author : String?
    var flag : Int = 0
    var updateType : Int = 0
    var comicId : Int = 0
    var cornerInfo : Int = 0
    var cover : String?
    var description : String?
    var is_vip : Int = 0
    var name : String?
    var short_description : String?
    var subTitle : String?
    var tags : [CartoonItemTagsModel]?
    
    var content : String?
    var ext : [CartoonItemTagsModel]?
    var id : Int = 0
    var linkType : Int = 0
    var title : String?
    
    required init() {}
    
}

class CartoonCateDetailItemModel: HandyJSON {
    var author : String?
    var comicId : Int = 0
    var cover : String?
    var description : String?
    var is_vip : Int = 0
    var name : String?
    var short_description : String?
    var tags : [String]?
    var flag : Int = 0
   
    var canToolBarShare : Bool = false
    var deadLine : Int = 0
    var isComment: Bool = false
    var isExpired: Bool = false
    var specialId: Int = 0
    var specialType: Int = 0
    var subTitle : String?
    var tag : Int = 0
    var title : String?
    var url : String?
    var conTag : Int = 0
    
    required init() {}
    
    }


class CartoonItemTagsModel: HandyJSON {
    var key : String?
    var val : String?
    
    required init() {}
}

class CartoonGalleryItemsModel: HandyJSON {
    var content : String?
    var cover : String?
    var ext : [CartoonItemTagsModel]?
    var id : Int = 0
    var linkType : Int = 0
    var title : String?
    
    required init() {}
}

class CartoonTextItemsModel: HandyJSON {
    required init() {}
}


class CartoonComicStaticModel: HandyJSON {
    var name: String?
    var comic_id: Int = 0
    var short_description: String?
    var accredit: Int = 0
    var cover: String?
    var is_vip: Int = 0
    var type: Int = 0
    var ori: String?
    var theme_ids: [String]?
    var series_status: Int = 0
    var last_update_time: TimeInterval = 0
    var description: String?
    var cate_id: String?
    var status: Int = 0
    var thread_id: Int = 0
    var last_update_week: String?
    var wideCover: String?
    var classifyTags: [CartoonClassifyTagModel]?
    var is_week: Bool = false
    var comic_color: String?
    var author: CartoonAuthorModel?
    var is_dub: Bool = false
    
    required init(){}
}

class CartoonAuthorModel: HandyJSON {
    var avatar : String?
    var id : Int = 0
    var name : String?
    
    required init(){}
}

class CartoonClassifyTagModel: HandyJSON {
    var argName : String?
    var argVal : Int = 0
    var name : String?
    required init(){}
}
class CartoonChapterStaticModel: HandyJSON {
    var chapter_id: Int = 0
    var name: String?
    var image_total: Int = 0
    var type: Int = 0
    var price:String?
    var size: Int32 = 0
    var pass_time: TimeInterval = 0
    var release_time: TimeInterval = 0
    var zip_high_webp: Int = 0
    var is_new: Bool = false
    var has_locked_image: Bool = false
    var imHightArr: [[CartoonImHightModel]]?
    var countImHightArr: Int = 0
    required init(){}
}

class CartoonImHightModel: HandyJSON {
    
    var height: Int = 0
    var width: Int = 0
    required init(){}
}

class CartoonDetailStaticModel: HandyJSON {
    var comicId: Int = 0
    var coverUrl: String?
    var name: String?
    var passChapterNum: Int = 0
    required init(){}
}

class CartoonGuessLikeModel : HandyJSON {
    var comic_id : String?
    var cover : String?
    var name : String?
    var new_comic : Int = 0
    var ori_cover : String?
    var short_description : String?
    required init(){}
}

/// realTimeModel
class CartoonComicRealtimeModel : HandyJSON {
    var comic_id: Int = 0
    var user_id: Int = 0
    var status: Int = 0
    var click_total: String?
    var total_ticket: String?
    var comment_total: String?
    var total_tucao: String?
    var favorite_total: String?
    var gift_total: String?
    var monthly_ticket: String?
    var vip_discount: Double = 0
    var is_vip_free: Bool = false
    var is_free: Bool = false
    var is_vip_buy: Bool = false
    var is_auto_buy: Bool = false
    required init(){}
}

class CartoonChapterRealtimeModel : HandyJSON {
    
    var vip_images: Int = 0
    var is_view: Bool = false
    var chapter_id: Int = 0
    var buyed: Bool = false
    var buy_price: String?
    var read_state: Int = 0
    var is_free: Bool = false
    var free_image_num : String?
    required init(){}
}

class CartoonCommentDefaultModel : HandyJSON {
    var defaultArgCon : Int = 0
    var defaultConTagType : String?
    var defaultSelection : Int = 0
    required init(){}
}

class CartoonSpinnerListModel : HandyJSON {
    var argCon : Int = 0
    var conTag : String?
    var name : String?
    required init() {}
}

class CartoonCommentModel : HandyJSON {
    var cate: Int = 0
    var color: String?
    var comic_author: Int = 0
    var comment_from: String?
    var comment_id: Int = 0
    var content: String?
    var content_filter: String?
    var create_time: TimeInterval = 0
    var create_time_str: String?
    var exp: Float = 0
    var face: String?
    var face_type: Int = 0
    var floor: Int = 0
    var gift_img: String?
    var gift_num: Int = 0
    var group_admin: Bool = false
    var group_author: Bool = false
    var group_custom: Bool = false
    var group_user: Bool = false
    var id: Int = 0
    var imageList: [Any]?
    var ip: String?
    var is_choice: Bool = false
    var is_delete: Bool = false
    var is_lock: Bool = false
    var is_up: Bool = false
    var level: CartoonLevelModel?
    var likeCount: Int = 0
    var likeState: Int = 0
    var nickname: String?
    var online_time: TimeInterval = 0
    var sex: String?
    var ticketNum: Int = 0
    var title: String?
    var total_reply: Int = 0
    var user_id: Int = 0
    var vip_exp: Int = 0
    
    required init() {}
}

class CartoonLevelModel : HandyJSON {
    var album_size: CGFloat = 0
    var exp_speed: Float = 0
    var favorite_num: Int = 0
    var level: Int = 0
    var max: Int = 0
    var min_exp: Int = 0
    var ticket: Int = 0
    var wage: Int = 0
    required init() {}
}


class CartoonChapterImageModel : HandyJSON {
    var location: String?
    var image_id: Int = 0
    var width: Int = 0
    var height: Int = 0
    var total_tucao: Int = 0
    var webp: Int = 0
    var type: Int = 0
    var img05: String?
    var img50: String?
    
    required init() {}
}


class CartoonSearchHotItemModel: HandyJSON {
    var bgColor : String?
    var comic_id : Int = 0
    var name : String?
    
    required init() {
        
    }
}
