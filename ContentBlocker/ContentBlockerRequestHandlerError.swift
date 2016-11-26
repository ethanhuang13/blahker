//
//  ContentBlockerRequestHandlerError.swift
//  Blahker
//
//  Created by Ethanhuang on 2016/11/25.
//  Copyright © 2016年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

enum ContentBlockerRequestHandlerError: Error {
    case createBlockerListUrlFailed
    case loadBlockerListFileFailed
}
