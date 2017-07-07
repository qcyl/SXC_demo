//
//  Macros.swift
//  SXC
//
//  Created by qi chao on 2017/7/5.
//  Copyright © 2017年 qi chao. All rights reserved.
//

#if SXC_TJ
    let scheme = "sxc-tj"
#elseif SXC_NX
    let scheme = "sxc-nx"
#elseif SXC_GX
    let scheme = "sxc-gx"
#elseif SXC_HLJ
    let scheme = "sxc-hlj"
#elseif SXC_ZJ
    let scheme = "sxc-zj"
#else
    let scheme = ""
#endif

func R(_ path: String) -> String {
    return scheme + "://" + path
}

