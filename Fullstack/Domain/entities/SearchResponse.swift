//
//  SearchResponse.swift
//  Fullstack
//
//  Created by 김범준 on 2021/01/27.
//

import Foundation

struct SearchResponse: VO {
    let lastPageId: Int
    let totalCount: Int
    let images: [ImageEntity]
}
