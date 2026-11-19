// 本文件由 tools/gen_swift_data.js 从 fitlog/index.html 自动生成，请勿手改。
// 数据源：网页版动作库 DB / EXDEMO / EXCUES / EXMISTAKE / PART_CN / GRIP_TXT / FAMILY
// 动作总数：59（力量 50，有氧 9）

import Foundation

enum ExerciseDatabase {
    static let all: [Exercise] = [
        Exercise(
            id: "bench",
            name: "杠铃卧推",
            group: "胸",
            equipment: "barbell",
            met: 5.0,
            unit: .reps,
            tip: "肩胛后收下沉，杠铃触胸中下部，大臂与躯干约 45°。",
            positionNotes: [
                PositionNote(part: "肩部", text: "肩胛后收下沉，全程不松"),
                PositionNote(part: "手臂", text: "大臂与躯干约 45°，别外展成 90°"),
                PositionNote(part: "腰部", text: "下背自然弓，双脚踩实地面")
            ],
            cues: [
                "起始：肩胛后收下沉贴凳，脚踩实，杠在肩正上方",
                "下放：2 秒慢放到胸中下部，肘与躯干约 45°",
                "推起：呼气沿略弧线向上，顶端不锁死肘",
                "节奏：下放 2 秒、推起 1 秒，组内别把杠架回去歇"
            ],
            mistake: "杠砸胸、臀部离凳借力 → 杠轻触胸停半秒再推，臀全程压凳"
        ),
        Exercise(
            id: "db-bench",
            name: "哑铃卧推",
            group: "胸",
            equipment: "dumbbell",
            met: 5.0,
            unit: .reps,
            tip: "下放至哑铃与胸齐平，推起时不要锁死肘关节。",
            positionNotes: [
                PositionNote(part: "手臂", text: "下放至哑铃与胸齐平"),
                PositionNote(part: "肩部", text: "推起时不要锁死肘"),
                PositionNote(part: "胸部", text: "顶端两铃靠拢但不碰撞")
            ],
            cues: [
                "起始：仰卧，哑铃在胸侧，掌心朝前，肩胛压紧凳面",
                "下放：沿弧线落到与胸齐平，前臂始终垂直地面",
                "推起：向上向内画弧，顶端两铃靠拢但不碰撞",
                "节奏：顶端主动挤胸停 1 秒，别靠惯性弹"
            ],
            mistake: "哑铃左右晃、靠肩前束顶 → 减重量，前臂保持垂直，先想胸再推"
        ),
        Exercise(
            id: "incline-db",
            name: "上斜哑铃卧推",
            group: "胸",
            equipment: "dumbbell",
            met: 5.0,
            unit: .reps,
            tip: "凳面 30° 左右，主攻上胸，全程避免耸肩。",
            positionNotes: [
                PositionNote(part: "胸部", text: "凳面 30° 主攻上胸"),
                PositionNote(part: "肩部", text: "全程避免耸肩"),
                PositionNote(part: "手臂", text: "沿上胸方向斜上推")
            ],
            cues: [
                "起始：凳面 30°，上背贴凳，哑铃在上胸两侧",
                "下放：顺上胸方向斜下放，肘不要过度外展",
                "推起：沿上胸方向斜上推，别推成平板卧推",
                "发力：轻重量先找上胸收缩感，别用肩前束顶"
            ],
            mistake: "凳子调太高变成推肩 → 固定在 30°，沿上胸方向斜上推"
        ),
        Exercise(
            id: "pushup",
            name: "俯卧撑",
            group: "胸",
            equipment: "bodyweight",
            met: 4.0,
            unit: .reps,
            tip: "身体一条直线，胸口接近地面，核心收紧不塌腰。",
            positionNotes: [
                PositionNote(part: "核心", text: "身体一条直线，核心收紧"),
                PositionNote(part: "胸部", text: "胸口接近地面"),
                PositionNote(part: "肩部", text: "肩不耸，肘约 45°")
            ],
            cues: [
                "起始：手腕在肩下，耳肩髋踝一条直线",
                "下放：肘约 45° 向后，胸口离地一拳",
                "撑起：呼气推地，肩胛不耸、腰不塌",
                "节奏：3 秒下放 1 秒撑起，做不动就改跪姿"
            ],
            mistake: "塌腰翘臀、肘外展成 90° → 收腹夹臀，肘回收到约 45°"
        ),
        Exercise(
            id: "fly",
            name: "绳索夹胸",
            group: "胸",
            equipment: "cable",
            met: 4.0,
            unit: .reps,
            tip: "肘微屈固定角度，靠胸部发力夹合，顶峰停 1 秒。",
            positionNotes: [
                PositionNote(part: "手臂", text: "肘微屈固定角度"),
                PositionNote(part: "胸部", text: "靠胸部夹合，顶峰停 1 秒"),
                PositionNote(part: "肩部", text: "肩胛下沉，别用肩前束借力")
            ],
            cues: [
                "起始：双手微屈握把，肘角度全程固定",
                "合拢：想象抱大树，靠胸把两手带向身前",
                "顶端：挤压 1 秒，别让两手交叉借惯性",
                "回放：慢放到胸有拉伸感就停，肩别被拉到身后"
            ],
            mistake: "屈肘变成推、回放时肩被拉到身后 → 锁住肘角，放到胸有拉伸感就停"
        ),
        Exercise(
            id: "dips",
            name: "双杠臂屈伸",
            group: "胸",
            equipment: "bodyweight",
            met: 5.5,
            unit: .reps,
            tip: "身体前倾偏胸，下沉至肩略低于肘即可；要负重就填在重量栏，0 即自重。",
            positionNotes: [
                PositionNote(part: "肩部", text: "身体前倾偏胸"),
                PositionNote(part: "手臂", text: "下沉至肩略低于肘"),
                PositionNote(part: "核心", text: "不摆荡，双腿交叉稳住")
            ],
            cues: [
                "起始：撑稳后肩胛下沉，身体略前倾偏胸",
                "下放：沉到肩略低于肘，肘微向后不外翻",
                "撑起：呼气推直，顶端不锁死肘",
                "节奏：全程不摆荡，双腿交叉屈膝稳住重心"
            ],
            mistake: "耸肩下沉过深、身体摆荡 → 先沉肩胛，沉到肩略低于肘，双腿交叉稳住"
        ),
        Exercise(
            id: "deadlift",
            name: "硬拉",
            group: "背",
            equipment: "barbell",
            met: 6.0,
            unit: .reps,
            tip: "杠贴小腿，背部中立，靠髋膝同时伸展站起。",
            positionNotes: [
                PositionNote(part: "腰部", text: "腰部挺直，背部中立"),
                PositionNote(part: "膝盖", text: "杠贴小腿，髋膝同时伸展"),
                PositionNote(part: "握法", text: "握稳，杠全程不离开身体")
            ],
            cues: [
                "起始：杠贴小腿，肩略在杠前，收紧背阔夹住腋下",
                "拉起：蹬地伸膝，杠始终贴腿上行",
                "锁定：髋向前顶到位就停，不后仰不耸肩",
                "下放：先送髋再屈膝，沿原路贴腿放回地面"
            ],
            mistake: "弓腰拉、杠离腿绕膝 → 宁可减重量也保持背中立，杠全程贴腿"
        ),
        Exercise(
            id: "pullup",
            name: "正握引体",
            group: "背",
            equipment: "bodyweight",
            met: 5.5,
            unit: .reps,
            tip: "掌心朝前、握距略宽于肩。先沉肩再拉，胸口找杠，顶端停 1 秒再慢放 2-3 秒；要加负重就填在重量栏（额外负重），0 即纯自重。",
            positionNotes: [
                PositionNote(part: "肩部", text: "先沉肩再拉，别耸肩"),
                PositionNote(part: "胸部", text: "胸口找杠，拉到过杠"),
                PositionNote(part: "核心", text: "身体垂直不摆荡借力")
            ],
            cues: [
                "起始：完全悬垂，先沉肩再启动背部",
                "上拉：想象肘向下后方压，胸口找杠",
                "顶端：下巴过杠停 1 秒",
                "下放：2-3 秒慢放到手臂伸直，别直接掉下来"
            ],
            mistake: "耸肩甩腿借惯性 → 先沉肩再拉，下放 2-3 秒；做不了先用弹力带"
        ),
        Exercise(
            id: "chinup",
            name: "反手引体",
            group: "背",
            equipment: "bodyweight",
            met: 5.5,
            unit: .reps,
            tip: "掌心朝自己、与肩同宽，肱二头参与更多，是练成引体的入门变式。全程肩胛下沉，别用蹬腿借力。",
            positionNotes: [
                PositionNote(part: "握法", text: "掌心朝自己、与肩同宽"),
                PositionNote(part: "手臂", text: "肱二头参与更多"),
                PositionNote(part: "胸部", text: "下巴过杠，慢放到底")
            ],
            cues: [
                "起始：反握与肩同宽，肩胛下沉",
                "上拉：肘贴身，肱二头与背阔同时收",
                "顶端：下巴过杠，胸口尽量靠近杠",
                "下放：慢放到完全伸直，别借腿摆"
            ],
            mistake: "身体后仰用腰蹬 → 保持垂直，肘贴身慢放到手臂伸直"
        ),
        Exercise(
            id: "neutral-pullup",
            name: "对握引体",
            group: "背",
            equipment: "bodyweight",
            met: 5.5,
            unit: .reps,
            tip: "掌心相对抓平行把手，肱肌与背阔同时发力，对肩肘最友好。肘贴身向后下拉，避免耸肩。",
            positionNotes: [
                PositionNote(part: "握法", text: "掌心相对，握把与肩同宽"),
                PositionNote(part: "肩部", text: "先沉肩再启动背部"),
                PositionNote(part: "手臂", text: "肘贴身向后下方拉")
            ],
            cues: [
                "起始：掌心相对抓把，完全悬垂",
                "上拉：沉肩后肘向下后方拉，肘贴身",
                "顶端：胸口找把手，停 1 秒",
                "下放：慢放不摆荡，手腕保持中立"
            ],
            mistake: "手腕内扣、拉成高位下拉 → 手腕中立，肘向下后方压而不是往外"
        ),
        Exercise(
            id: "muscle-up",
            name: "双力臂",
            group: "背",
            equipment: "bodyweight",
            met: 8.0,
            unit: .reps,
            tip: "引体拉到锁骨后快速翻腕，顺势撑起至手臂伸直；先能拉 8 个标准引体、会高翻再练，别硬翻砸肘。",
            positionNotes: [
                PositionNote(part: "手臂", text: "拉到锁骨以上快速翻腕"),
                PositionNote(part: "肩部", text: "顺势撑起至手臂伸直"),
                PositionNote(part: "核心", text: "核心收紧，借髋部爆发")
            ],
            cues: [
                "起始：悬垂略前倾，脚前伸蓄力",
                "爆发：一次拉到锁骨以上，同时快速翻腕",
                "过渡：肘上到杠上方，顺势推直手臂",
                "完成：核心收紧，杠上支撑不塌肩；下放先屈肘再落回悬垂"
            ],
            mistake: "拉不够高就急着翻腕 → 先把爆发引体拉到锁骨以上，再练翻腕过渡"
        ),
        Exercise(
            id: "one-arm-pullup",
            name: "单臂引体",
            group: "背",
            equipment: "bodyweight",
            met: 8.0,
            unit: .reps,
            tip: "单手抓杠，另一手可扶腕辅助；建议负重引体达到 +50% 体重后再尝试。",
            positionNotes: [
                PositionNote(part: "握法", text: "单手抓杠，另一手扶腕"),
                PositionNote(part: "肩部", text: "启动前先沉肩锁住"),
                PositionNote(part: "核心", text: "身体不旋转不摆荡")
            ],
            cues: [
                "起始：单手抓杠，先沉肩锁住肩胛",
                "上拉：身体略侧转但不旋转摆荡",
                "顶端：下巴过杠，另一手仅轻扶腕",
                "进阶：先练单臂悬垂和极慢离心打基础"
            ],
            mistake: "身体旋转靠甩上去 → 先练单臂悬垂和极慢离心，别硬拉"
        ),
        Exercise(
            id: "lat-pulldown",
            name: "高位下拉",
            group: "背",
            equipment: "machine",
            met: 4.5,
            unit: .reps,
            tip: "身体略后仰，拉至锁骨位置，感受背阔肌收缩。",
            positionNotes: [
                PositionNote(part: "胸部", text: "拉至锁骨位置"),
                PositionNote(part: "背部", text: "身体略后仰，背阔收缩"),
                PositionNote(part: "握法", text: "别用拇指锁死，靠肘下拉")
            ],
            cues: [
                "起始：大腿卡稳，挺胸略后仰 10-15°",
                "下拉：靠肘往下拉到锁骨，别用手拽",
                "顶端：背阔收紧停 1 秒",
                "回放：慢放到手臂伸直，肩胛自然上提但不塌腰"
            ],
            mistake: "后仰太多变成划船、用手拽 → 后仰控制在 15° 内，想象肘往下拉"
        ),
        Exercise(
            id: "bb-row",
            name: "杠铃划船",
            group: "背",
            equipment: "barbell",
            met: 5.0,
            unit: .reps,
            tip: "髋屈约 45°，拉向下腹，避免腰部代偿甩动。",
            positionNotes: [
                PositionNote(part: "腰部", text: "髋屈 45°，背部中立"),
                PositionNote(part: "手臂", text: "拉向下腹，别用腰甩"),
                PositionNote(part: "肩部", text: "顶端肩胛后缩停 1 秒")
            ],
            cues: [
                "起始：髋屈 45°，背部中立，杠自然垂",
                "拉起：肘向后上方，杠走向下腹",
                "顶端：肩胛后缩停 1 秒，别用腰甩",
                "下放：2 秒慢放，躯干角度全程不变"
            ],
            mistake: "弓背甩腰、杠拉向胸口 → 背保持中立，杠走下腹，用肘带"
        ),
        Exercise(
            id: "db-row",
            name: "单臂哑铃划船",
            group: "背",
            equipment: "dumbbell",
            met: 4.5,
            unit: .reps,
            tip: "单手支撑稳定躯干，肘贴身向后上方拉。",
            positionNotes: [
                PositionNote(part: "背部", text: "单手支撑稳定躯干"),
                PositionNote(part: "手臂", text: "肘贴身向后上方拉"),
                PositionNote(part: "腰部", text: "躯干不跟着旋转")
            ],
            cues: [
                "起始：一手一膝撑凳，背部平直不塌",
                "拉起：肘贴身向后上方，想象把哑铃拉进裤兜",
                "顶端：背阔收紧停 1 秒，躯干别跟着转",
                "下放：放到肩胛有拉伸感，别让重量把身体拽歪"
            ],
            mistake: "躯干跟着转、用肩提 → 支撑手压稳，肘贴身向后上，躯干不转"
        ),
        Exercise(
            id: "seated-row",
            name: "坐姿划船",
            group: "背",
            equipment: "machine",
            met: 4.5,
            unit: .reps,
            tip: "挺胸收腹，肩胛后缩，不要用腰发力。",
            positionNotes: [
                PositionNote(part: "背部", text: "挺胸收腹，肩胛后缩"),
                PositionNote(part: "手臂", text: "不要用腰发力"),
                PositionNote(part: "胸部", text: "拉到腹部停顿 1 秒")
            ],
            cues: [
                "起始：脚踩踏板，挺胸收腹，膝微屈",
                "拉起：先收肩胛再屈肘，把手拉向腹部",
                "顶端：停 1 秒，别后仰借腰",
                "回放：慢放到肩胛前伸，躯干始终稳定"
            ],
            mistake: "靠腰后仰拉重量 → 挺胸收腹固定躯干，先收肩胛再屈肘"
        ),
        Exercise(
            id: "face-pull",
            name: "面拉",
            group: "背",
            equipment: "cable",
            met: 3.5,
            unit: .reps,
            tip: "绳索拉向面部，肘高于手腕，练后束与肩关节健康。",
            positionNotes: [
                PositionNote(part: "肩部", text: "肘高于手腕"),
                PositionNote(part: "背部", text: "拉向面部练后束"),
                PositionNote(part: "握法", text: "绳索末端顺势外旋")
            ],
            cues: [
                "起始：绳索调到面部高度，双手握绳端",
                "拉起：肘高于手腕，拉向眉心并顺势外旋",
                "顶端：后束与肩胛收紧停 1 秒",
                "回放：慢放，别让肘掉下来变成划船"
            ],
            mistake: "肘掉下来变成划船 → 全程肘高于腕，绳索拉向眉心"
        ),
        Exercise(
            id: "inverted-row",
            name: "反向划船",
            group: "背",
            equipment: "bodyweight",
            met: 4.5,
            unit: .reps,
            tip: "身体绷直，胸口触杠，肩胛先收再拉。",
            positionNotes: [
                PositionNote(part: "核心", text: "身体绷直，脚跟支地"),
                PositionNote(part: "胸部", text: "胸口触杠，肩胛先收"),
                PositionNote(part: "肩部", text: "肩别耸到耳朵")
            ],
            cues: [
                "起始：身体绷直，脚跟支地，肩胛先收",
                "上拉：胸口触杠，肘向后不外展",
                "顶端：停 1 秒，别用腰把身体顶起",
                "下放：2 秒慢放，全程一条直线不塌腰"
            ],
            mistake: "塌腰、用髋把身体顶起 → 全身绷直，胸口主动找杠"
        ),
        Exercise(
            id: "superman",
            name: "超人式",
            group: "背",
            equipment: "bodyweight",
            met: 3.0,
            unit: .reps,
            tip: "俯卧同时抬起手脚，顶端停 2 秒再放下。",
            positionNotes: [
                PositionNote(part: "背部", text: "俯卧同时抬起手脚"),
                PositionNote(part: "腰部", text: "顶端停 2 秒再放下"),
                PositionNote(part: "头部", text: "颈部中立，别仰头")
            ],
            cues: [
                "起始：俯卧，手臂前伸，额头轻触地",
                "抬起：同时抬手抬腿，靠背与臀发力",
                "顶端：停 2 秒，颈部中立别仰头",
                "下放：控制回落，不要用惯性弹"
            ],
            mistake: "猛仰头用惯性弹 → 颈中立看地面，顶端停 2 秒再控制落下"
        ),
        Exercise(
            id: "squat",
            name: "杠铃深蹲",
            group: "腿",
            equipment: "barbell",
            met: 6.0,
            unit: .reps,
            tip: "脚略比肩宽，蹲至大腿平行，膝盖跟随脚尖方向。",
            positionNotes: [
                PositionNote(part: "腰部", text: "蹲至大腿平行，背部挺直"),
                PositionNote(part: "膝盖", text: "膝盖跟随脚尖方向"),
                PositionNote(part: "脚", text: "重心在中足，脚跟不离地")
            ],
            cues: [
                "起始：杠稳在上背，吸气收紧核心，脚距略宽于肩",
                "下蹲：髋膝同时屈，膝盖跟脚尖方向，蹲至大腿平行",
                "站起：脚跟与中足发力，髋膝同步伸展",
                "呼吸：下蹲吸气、过粘滞点呼气，全程别塌腰"
            ],
            mistake: "膝盖内扣、脚跟离地、上身前趴 → 膝跟脚尖，重心压中足，先练空杠幅度"
        ),
        Exercise(
            id: "front-squat",
            name: "前蹲",
            group: "腿",
            equipment: "barbell",
            met: 6.0,
            unit: .reps,
            tip: "肘部抬高，躯干保持直立，重心落在中足。",
            positionNotes: [
                PositionNote(part: "肩部", text: "双肘高抬，杠稳在锁骨"),
                PositionNote(part: "腰部", text: "躯干保持直立"),
                PositionNote(part: "膝盖", text: "膝盖跟脚尖，不内扣")
            ],
            cues: [
                "起始：杠架锁骨，双肘高抬，指尖轻托",
                "下蹲：躯干尽量直立，肘不掉",
                "站起：中足发力，别让上身前趴",
                "节奏：比后蹲慢，先空杠练持杠站姿找直立感"
            ],
            mistake: "肘往下掉、杠往前滚 → 高抬肘，重量宁轻，先练持杠站姿"
        ),
        Exercise(
            id: "leg-press",
            name: "腿举",
            group: "腿",
            equipment: "machine",
            met: 5.0,
            unit: .reps,
            tip: "下放至膝约 90°，不要锁死膝盖或抬臀。",
            positionNotes: [
                PositionNote(part: "膝盖", text: "下放至膝约 90°"),
                PositionNote(part: "髋部", text: "不要锁死膝盖或抬臀"),
                PositionNote(part: "脚", text: "脚掌全程贴稳踏板")
            ],
            cues: [
                "起始：脚掌贴稳踏板，骨盆贴凳，解开保险",
                "下放：慢放到膝约 90°，臀不离凳",
                "推起：不锁死膝盖，匀速控制",
                "幅度：宁可减重量也别让腰离开靠背"
            ],
            mistake: "下放过深导致骨盆离凳 → 到膝 90° 就停，腰和臀始终贴凳"
        ),
        Exercise(
            id: "rdl",
            name: "罗马尼亚硬拉",
            group: "腿",
            equipment: "barbell",
            met: 5.5,
            unit: .reps,
            tip: "膝微屈固定，髋向后推，感受腘绳肌拉伸。",
            positionNotes: [
                PositionNote(part: "腰部", text: "膝微屈固定，背部挺直"),
                PositionNote(part: "髋部", text: "髋向后推，感受腘绳肌拉伸"),
                PositionNote(part: "握法", text: "杠沿大腿贴身下放")
            ],
            cues: [
                "起始：膝微屈固定，收紧背阔",
                "下放：髋向后推，杠贴腿到膝下，感受腘绳肌拉伸",
                "拉起：腘绳肌与臀发力顶髋，不弓腰",
                "幅度：到背快要圆就停，不必非触地"
            ],
            mistake: "做成深蹲、背开始圆还继续下放 → 膝角固定只送髋，背一圆立刻起身"
        ),
        Exercise(
            id: "lunge",
            name: "箭步蹲",
            group: "腿",
            equipment: "dumbbell",
            met: 5.5,
            unit: .reps,
            tip: "后膝接近地面，前膝不超过脚尖，躯干直立。",
            positionNotes: [
                PositionNote(part: "膝盖", text: "后膝接近地面，前膝不超脚尖"),
                PositionNote(part: "腰部", text: "躯干直立"),
                PositionNote(part: "脚", text: "前脚掌踩稳，不内外翻")
            ],
            cues: [
                "起始：躯干直立，核心收紧，步距适中",
                "下蹲：后膝下沉接近地面，前膝不过脚尖",
                "站起：前脚跟发力，不借后腿蹬",
                "节奏：两侧交替，落地轻，别把膝盖砸向地面"
            ],
            mistake: "步子太小前膝猛超脚尖、砸地 → 加大步距，后膝垂直下沉，落地轻"
        ),
        Exercise(
            id: "leg-curl",
            name: "腿弯举",
            group: "腿",
            equipment: "machine",
            met: 3.5,
            unit: .reps,
            tip: "骨盆贴紧凳面，用腘绳肌发力卷起。",
            positionNotes: [
                PositionNote(part: "髋部", text: "骨盆贴紧凳面"),
                PositionNote(part: "膝盖", text: "用腘绳肌发力卷起"),
                PositionNote(part: "腰部", text: "别抬臀借力")
            ],
            cues: [
                "起始：俯卧，骨盆贴紧凳面，脚跟勾住滚垫",
                "卷起：用腘绳肌把滚垫拉向臀部",
                "顶端：挤压 1 秒，别抬臀借力",
                "下放：2 秒慢放，重量别甩"
            ],
            mistake: "抬臀借力、用惯性甩 → 骨盆压紧凳面，顶端停 1 秒"
        ),
        Exercise(
            id: "leg-ext",
            name: "腿屈伸",
            group: "腿",
            equipment: "machine",
            met: 3.5,
            unit: .reps,
            tip: "顶端停 1 秒，控制下放，不要甩重量。",
            positionNotes: [
                PositionNote(part: "膝盖", text: "顶端停 1 秒"),
                PositionNote(part: "手臂", text: "控制下放，不甩重量"),
                PositionNote(part: "核心", text: "躯干贴靠背不后仰")
            ],
            cues: [
                "起始：坐稳，膝窝贴凳沿，脚背勾住滚垫",
                "抬起：靠股四头肌伸膝到接近伸直",
                "顶端：停 1 秒，不锁死膝",
                "下放：控制 2 秒，躯干贴靠背不后仰"
            ],
            mistake: "甩腿、躯干后仰 → 减重量，2 秒慢放，背贴靠背"
        ),
        Exercise(
            id: "calf",
            name: "站姿提踵",
            group: "腿",
            equipment: "machine",
            met: 3.0,
            unit: .reps,
            tip: "脚跟尽量抬高，顶峰停 1 秒，下放拉长小腿。",
            positionNotes: [
                PositionNote(part: "脚", text: "脚跟尽量抬高"),
                PositionNote(part: "膝盖", text: "顶峰停 1 秒，下放拉长"),
                PositionNote(part: "核心", text: "身体不前后晃")
            ],
            cues: [
                "起始：前脚掌踩稳踏板，脚跟自然下沉拉伸",
                "抬起：脚跟尽量抬高，重心压在大脚趾球",
                "顶端：停 1 秒，别靠膝盖弹",
                "下放：慢放到小腿有拉伸感，身体不前后晃"
            ],
            mistake: "靠膝盖弹动、幅度很小 → 底部停 1 秒拉伸，顶端停 1 秒再落"
        ),
        Exercise(
            id: "hip-thrust",
            name: "臀推",
            group: "腿",
            equipment: "barbell",
            met: 5.0,
            unit: .reps,
            tip: "上背靠凳，收下巴，顶端臀部完全收紧。",
            positionNotes: [
                PositionNote(part: "髋部", text: "上背靠凳，顶端臀部收紧"),
                PositionNote(part: "腰部", text: "收下巴，不要用腰顶"),
                PositionNote(part: "膝盖", text: "小腿接近垂直，膝跟脚尖")
            ],
            cues: [
                "起始：上背靠凳，下巴微收，脚跟距臀约一掌",
                "顶起：脚跟发力，靠臀不靠腰",
                "顶端：髋完全伸展夹臀停 1 秒，小腿接近垂直",
                "下放：控制落回，别让腰过度超伸代偿"
            ],
            mistake: "用腰顶、下巴上仰 → 下巴微收，靠臀夹到髋完全伸展"
        ),
        Exercise(
            id: "bw-squat",
            name: "徒手深蹲",
            group: "腿",
            equipment: "bodyweight",
            met: 5.0,
            unit: .reps,
            tip: "双手前平举配平，蹲至大腿平行，全程控制。",
            positionNotes: [
                PositionNote(part: "腰部", text: "双手前平举配平，蹲至大腿平行"),
                PositionNote(part: "膝盖", text: "全程控制速度"),
                PositionNote(part: "脚", text: "脚跟踩实地面")
            ],
            cues: [
                "起始：双手前平举配平，脚距与肩同宽",
                "下蹲：髋往后坐，蹲至大腿平行，脚跟踩实",
                "站起：中足发力，膝盖跟脚尖",
                "节奏：3 秒下放 1 秒站起，先练幅度再加次数"
            ],
            mistake: "膝盖先往前跪、脚跟抬起 → 先往后坐髋，脚跟全程踩实"
        ),
        Exercise(
            id: "glute-bridge",
            name: "臀桥",
            group: "腿",
            equipment: "bodyweight",
            met: 3.5,
            unit: .reps,
            tip: "脚跟发力顶髋，顶端夹紧臀部停 1 秒。",
            positionNotes: [
                PositionNote(part: "髋部", text: "脚跟发力顶髋"),
                PositionNote(part: "核心", text: "顶端夹紧臀部停 1 秒"),
                PositionNote(part: "腰部", text: "腰椎不过度超伸")
            ],
            cues: [
                "起始：仰卧屈膝，脚跟靠近臀部，下背贴地",
                "顶起：脚跟发力顶髋，靠臀不靠腰",
                "顶端：夹紧臀部停 1 秒，腰椎不过度超伸",
                "下放：逐节落回，别让骨盆左右晃"
            ],
            mistake: "腰超伸代偿、脚放太远 → 脚跟靠近臀，顶端夹臀不顶腰"
        ),
        Exercise(
            id: "ohp",
            name: "站姿推举",
            group: "肩",
            equipment: "barbell",
            met: 5.0,
            unit: .reps,
            tip: "核心收紧，杠从锁骨上方垂直上推，不后仰。",
            positionNotes: [
                PositionNote(part: "核心", text: "核心收紧，不后仰"),
                PositionNote(part: "手臂", text: "杠从锁骨上方垂直上推"),
                PositionNote(part: "握法", text: "握距略宽于肩，手腕不折")
            ],
            cues: [
                "起始：杠架锁骨，核心与臀同时收紧",
                "上推：头略后让杠走直线，过脸后前送",
                "顶端：锁定不后仰，缓慢下放",
                "呼吸：推起呼气，全程别用腿蹬借力"
            ],
            mistake: "后仰用腰顶成上斜卧推 → 收紧臀腹，杠走垂直线，过脸后头前送"
        ),
        Exercise(
            id: "db-sp",
            name: "哑铃肩推",
            group: "肩",
            equipment: "dumbbell",
            met: 5.0,
            unit: .reps,
            tip: "肘部略前于身体，推到头顶上方不撞击。",
            positionNotes: [
                PositionNote(part: "肩部", text: "肘部略前于身体"),
                PositionNote(part: "手臂", text: "推到头顶不撞击"),
                PositionNote(part: "核心", text: "不靠腰顶，坐姿更稳")
            ],
            cues: [
                "起始：哑铃在耳侧，肘略前于身体",
                "上推：沿弧线向头顶中间靠拢",
                "顶端：不撞击，慢放控制",
                "稳定：坐姿有靠背更稳，别靠腰顶"
            ],
            mistake: "顶端两只哑铃对撞、腰后仰 → 沿弧线靠拢不碰撞，坐姿更稳"
        ),
        Exercise(
            id: "lat-raise",
            name: "侧平举",
            group: "肩",
            equipment: "dumbbell",
            met: 3.0,
            unit: .reps,
            tip: "小重量高次数，抬到与肩平，小指略高，不耸肩。",
            positionNotes: [
                PositionNote(part: "肩部", text: "抬到与肩平，不耸肩"),
                PositionNote(part: "握法", text: "小指略高"),
                PositionNote(part: "手臂", text: "肘微屈固定，不甩")
            ],
            cues: [
                "起始：双手持铃在体侧，肘微屈固定",
                "抬起：向两侧抬到与肩平，小指略高",
                "顶端：停 1 秒，不耸肩",
                "下放：2 秒慢放，重量宁轻勿重，别甩惯性"
            ],
            mistake: "耸肩甩重量、抬过肩 → 重量宁轻，抬到与肩平，小指略高"
        ),
        Exercise(
            id: "rear-fly",
            name: "俯身飞鸟",
            group: "肩",
            equipment: "dumbbell",
            met: 3.0,
            unit: .reps,
            tip: "上身前倾，肘微屈，用后束打开，别用斜方肌。",
            positionNotes: [
                PositionNote(part: "背部", text: "上身前倾，别用斜方肌"),
                PositionNote(part: "手臂", text: "肘微屈，用后束打开"),
                PositionNote(part: "腰部", text: "背部挺直不弓")
            ],
            cues: [
                "起始：上身前倾约 45°，背部挺直，肘微屈",
                "打开：用后束把哑铃向两侧画弧",
                "顶端：肩胛微收停 1 秒，别夹成划船",
                "下放：慢放，脖子放松别仰头"
            ],
            mistake: "斜方肌代偿、做成划船 → 肘微屈固定，想象向两侧打开"
        ),
        Exercise(
            id: "pike-pushup",
            name: "折刀俯卧撑",
            group: "肩",
            equipment: "bodyweight",
            met: 4.5,
            unit: .reps,
            tip: "臀部高抬呈倒 V，头顶朝地面下压，练肩前束。",
            positionNotes: [
                PositionNote(part: "髋部", text: "臀部高抬呈倒 V"),
                PositionNote(part: "头部", text: "头顶朝地面下压"),
                PositionNote(part: "肩部", text: "肘向后 45°，不外展")
            ],
            cues: [
                "起始：臀部高抬呈倒 V，手脚距适中",
                "下压：头顶朝地面下压，肘向后 45°",
                "撑起：肩与三头同时发力推回倒 V",
                "幅度：头越靠近手肩部负荷越大，循序渐进"
            ],
            mistake: "臀部不够高、肘外展 → 先摆好倒 V，肘向后 45° 不外翻"
        ),
        Exercise(
            id: "bb-curl",
            name: "杠铃弯举",
            group: "手臂",
            equipment: "barbell",
            met: 3.5,
            unit: .reps,
            tip: "肘固定在体侧，全程控制，不要靠腰摆动。",
            positionNotes: [
                PositionNote(part: "手臂", text: "肘固定在体侧"),
                PositionNote(part: "腰部", text: "不要靠腰摆动"),
                PositionNote(part: "握法", text: "握距与肩同宽，手腕中立")
            ],
            cues: [
                "起始：握距与肩同宽，手腕中立，肘夹体侧",
                "上举：只动前臂，顶峰挤压肱二头",
                "顶端：停 1 秒，上臂不向前抬",
                "下放：2-3 秒慢放，别靠腰摆"
            ],
            mistake: "上臂前抬、靠腰摆 → 肘夹体侧固定，背靠墙练更直观"
        ),
        Exercise(
            id: "db-curl",
            name: "哑铃弯举",
            group: "手臂",
            equipment: "dumbbell",
            met: 3.5,
            unit: .reps,
            tip: "上举时前臂外旋，顶峰挤压肱二头肌。",
            positionNotes: [
                PositionNote(part: "手臂", text: "上举时前臂外旋"),
                PositionNote(part: "胸部", text: "顶峰挤压肱二头肌"),
                PositionNote(part: "肩部", text: "肩不耸，下放要慢")
            ],
            cues: [
                "起始：掌心朝前，肘固定在体侧",
                "上举：前臂顺势外旋，小指略高",
                "顶端：挤压 1 秒，肩不耸",
                "下放：慢放到完全伸直，两侧交替别甩"
            ],
            mistake: "肩耸、下放直接掉 → 沉肩，2-3 秒离心慢放"
        ),
        Exercise(
            id: "hammer",
            name: "锤式弯举",
            group: "手臂",
            equipment: "dumbbell",
            met: 3.5,
            unit: .reps,
            tip: "掌心相对握法，更多刺激肱肌与前臂。",
            positionNotes: [
                PositionNote(part: "握法", text: "掌心相对握法"),
                PositionNote(part: "手臂", text: "更多刺激肱肌与前臂"),
                PositionNote(part: "核心", text: "身体不晃")
            ],
            cues: [
                "起始：掌心相对握铃，手腕中立",
                "上举：保持对握，肘不离开体侧",
                "顶端：停 1 秒，重点感受肱肌与前臂",
                "下放：控制回落，身体不晃"
            ],
            mistake: "身体左右晃借力 → 减重量，肘贴身不摆动"
        ),
        Exercise(
            id: "pushdown",
            name: "绳索下压",
            group: "手臂",
            equipment: "cable",
            met: 3.5,
            unit: .reps,
            tip: "肘夹紧体侧，只做前臂伸展，底端略外翻。",
            positionNotes: [
                PositionNote(part: "手臂", text: "肘夹紧体侧，只做前臂伸展"),
                PositionNote(part: "握法", text: "底端略外翻"),
                PositionNote(part: "肩部", text: "肩不前后移动")
            ],
            cues: [
                "起始：肘夹紧体侧，上臂垂直固定",
                "下压：只做前臂伸展，把绳压到大腿侧",
                "底端：略向外分开绳端，挤压 1 秒",
                "回放：慢放到前臂约 90°，肩不前后移动"
            ],
            mistake: "肘往前跑变成卧推 → 上臂垂直锁在体侧，只动前臂"
        ),
        Exercise(
            id: "skull",
            name: "仰卧臂屈伸",
            group: "手臂",
            equipment: "barbell",
            met: 3.5,
            unit: .reps,
            tip: "上臂固定垂直，肘屈伸，注意肘部不要外张。",
            positionNotes: [
                PositionNote(part: "手臂", text: "上臂固定垂直"),
                PositionNote(part: "肩部", text: "肘部不要外张"),
                PositionNote(part: "握法", text: "手腕不折，慢速下放")
            ],
            cues: [
                "起始：仰卧，上臂垂直固定，手腕中立",
                "下放：慢放到额前或头后，肘不外张",
                "推起：只动前臂，顶端不锁死肘",
                "保护：先用轻重量，肘不适就改窄握卧推"
            ],
            mistake: "肘外张、上臂晃 → 上臂保持垂直，或改用窄握卧推"
        ),
        Exercise(
            id: "cgbp",
            name: "窄距卧推",
            group: "手臂",
            equipment: "barbell",
            met: 5.0,
            unit: .reps,
            tip: "握距与肩同宽，肘贴身下放，主攻肱三头。",
            positionNotes: [
                PositionNote(part: "握法", text: "握距与肩同宽"),
                PositionNote(part: "手臂", text: "肘贴身下放"),
                PositionNote(part: "肩部", text: "肩胛后收下沉")
            ],
            cues: [
                "起始：肩胛后收，握距与肩同宽",
                "下放：肘贴身，杠到胸侧",
                "推起：三头发力，不锁死肘",
                "手腕：别让杠压得手腕后折，握距过窄会伤腕"
            ],
            mistake: "握距过窄伤腕、肘外翻 → 与肩同宽，手腕保持中立"
        ),
        Exercise(
            id: "tricep-dip",
            name: "凳上臂屈伸",
            group: "手臂",
            equipment: "bodyweight",
            met: 4.0,
            unit: .reps,
            tip: "手撑凳沿，身体贴凳下放，肩不要耸。",
            positionNotes: [
                PositionNote(part: "肩部", text: "肩不要耸"),
                PositionNote(part: "手臂", text: "身体贴凳下放"),
                PositionNote(part: "腰部", text: "核心收紧不塌")
            ],
            cues: [
                "起始：手撑凳边，脚跟前移，肩下沉",
                "下放：身体贴凳垂直下沉，肘向后",
                "撑起：三头发力推回，肩不耸",
                "幅度：肩有不适就减小下沉深度"
            ],
            mistake: "肩耸到耳朵、下沉过深 → 先沉肩，肩不适就减小幅度"
        ),
        Exercise(
            id: "plank",
            name: "平板支撑",
            group: "核心",
            equipment: "bodyweight",
            met: 3.5,
            unit: .reps,
            tip: "肘在肩正下方，臀部不塌不翘，均匀呼吸。",
            positionNotes: [
                PositionNote(part: "腰部", text: "臀部不塌不翘，身体一条直线"),
                PositionNote(part: "肩部", text: "肘在肩正下方"),
                PositionNote(part: "核心", text: "收腹夹臀，均匀呼吸")
            ],
            cues: [
                "起始：肘在肩正下方，收腹夹臀",
                "保持：耳肩髋踝一条直线，均匀呼吸不憋气",
                "时间：宁可 30 秒标准，也别 2 分钟塌腰",
                "进阶：先练死虫和侧桥，再拉长时长"
            ],
            mistake: "塌腰翘臀、憋气 → 收腹夹臀，缩短时长也要保持直线"
        ),
        Exercise(
            id: "leg-raise",
            name: "悬垂举腿",
            group: "核心",
            equipment: "bodyweight",
            met: 4.5,
            unit: .reps,
            tip: "骨盆后倾卷起，用腹肌抬腿，避免摆荡。",
            positionNotes: [
                PositionNote(part: "核心", text: "骨盆后倾卷起，避免摆荡"),
                PositionNote(part: "腰部", text: "用腹肌抬腿"),
                PositionNote(part: "肩部", text: "肩胛下沉不耸")
            ],
            cues: [
                "起始：悬垂沉肩，骨盆先微微后倾",
                "上抬：用下腹卷起骨盆，不是单纯抬腿",
                "顶端：腿到水平即可，腰不弓",
                "下放：慢放不摆荡，做不了先屈膝"
            ],
            mistake: "直腿硬抬导致腰弓、身体摆荡 → 先屈膝练骨盆后倾，慢放不甩"
        ),
        Exercise(
            id: "crunch",
            name: "卷腹",
            group: "核心",
            equipment: "bodyweight",
            met: 3.0,
            unit: .reps,
            tip: "下巴微收，肩胛离地即可，靠腹肌卷起。",
            positionNotes: [
                PositionNote(part: "头部", text: "下巴微收"),
                PositionNote(part: "核心", text: "肩胛离地即可"),
                PositionNote(part: "腰部", text: "下背贴地不弓")
            ],
            cues: [
                "起始：仰卧屈膝，下背贴地，下巴微收",
                "卷起：肩胛离地即可，眼睛看天花板",
                "顶端：挤压腹肌 1 秒，别用手抱头拽脖子",
                "下放：缓慢落回，腰始终不离地"
            ],
            mistake: "抱头拽脖子、整个上身坐起 → 手轻扶耳侧，肩胛离地即可"
        ),
        Exercise(
            id: "cable-crunch",
            name: "绳索卷腹",
            group: "核心",
            equipment: "cable",
            met: 4.0,
            unit: .reps,
            tip: "跪姿固定髋部，靠腹肌收缩把重量卷下来。",
            positionNotes: [
                PositionNote(part: "核心", text: "跪姿固定髋部，靠腹肌卷下"),
                PositionNote(part: "腰部", text: "不要用腰拉"),
                PositionNote(part: "头部", text: "下巴微收看地面")
            ],
            cues: [
                "起始：跪姿固定髋部，双手握绳于头侧",
                "卷下：靠腹肌把躯干卷向地面，髋角不变",
                "底端：停 1 秒，别用腰和手臂拉",
                "回放：慢放到躯干伸直，下巴微收看地面"
            ],
            mistake: "用腰和手臂把绳拉下来 → 髋角固定，靠腹肌卷躯干"
        ),
        Exercise(
            id: "twist",
            name: "俄罗斯转体",
            group: "核心",
            equipment: "bodyweight",
            met: 3.5,
            unit: .reps,
            tip: "身体后倾保持稳定，转体时眼随手动。",
            positionNotes: [
                PositionNote(part: "核心", text: "身体后倾保持稳定"),
                PositionNote(part: "手臂", text: "转体时眼随手动"),
                PositionNote(part: "腰部", text: "不要弓腰甩动")
            ],
            cues: [
                "起始：坐姿后倾，脊柱挺直，脚可离地",
                "转体：靠腹斜肌带动，眼随手动",
                "两侧：每侧停半秒，别用惯性甩",
                "呼吸：转体呼气、回正吸气，别弓腰"
            ],
            mistake: "弓腰用惯性甩 → 挺直脊柱，每侧停半秒再转回"
        ),
        Exercise(
            id: "ab-wheel",
            name: "健腹轮",
            group: "核心",
            equipment: "bodyweight",
            met: 4.5,
            unit: .reps,
            tip: "跪姿握轮，收紧腹臀再向前滚，只滚到腰不塌的范围，回程靠腹肌拉回。",
            positionNotes: [
                PositionNote(part: "腰部", text: "只滚到腰不塌的范围"),
                PositionNote(part: "核心", text: "回程靠腹肌拉回"),
                PositionNote(part: "肩部", text: "肩胛收紧，手臂不弯")
            ],
            cues: [
                "起始：跪姿收腹，肩胛收紧，手臂伸直",
                "滚出：只滚到腰不塌的最大范围",
                "回程：靠腹肌拉回，别用髋屈肌猛收",
                "保护：先靠墙限位练小幅度，腰一塌立刻停"
            ],
            mistake: "腰一塌还继续往前滚 → 靠墙限位，腰塌立刻收；先练死虫"
        ),
        Exercise(
            id: "ab-wheel-stand",
            name: "站姿健腹轮",
            group: "核心",
            equipment: "bodyweight",
            met: 5.0,
            unit: .reps,
            tip: "站姿直腿滚出，需要极强的核心与肩稳定；先在跪姿做到 15 次再尝试。",
            positionNotes: [
                PositionNote(part: "腰部", text: "站姿直腿滚出，腰不能塌"),
                PositionNote(part: "肩部", text: "需要极强肩稳定"),
                PositionNote(part: "核心", text: "全程收腹，宁可小幅")
            ],
            cues: [
                "起始：站姿直腿，收腹夹臀，肩胛收紧",
                "滚出：极慢向前，全程腰不能塌",
                "回程：靠腹肌与背阔拉回，宁可半程",
                "门槛：能标准做 15 次跪姿再尝试，别硬撑"
            ],
            mistake: "没练好跪姿就上站姿 → 先能标准 15 次跪姿，站姿只做半程"
        ),
        Exercise(
            id: "run",
            name: "跑步",
            group: "有氧",
            equipment: "cardio",
            met: 8.5,
            unit: .minutes,
            tip: "配速 8-9 km/h，能说话但略喘的强度。",
            positionNotes: [],
            cues: [],
            mistake: nil
        ),
        Exercise(
            id: "walk",
            name: "快走",
            group: "有氧",
            equipment: "cardio",
            met: 4.5,
            unit: .minutes,
            tip: "步频加快、摆臂，心率约为最大心率 55-65%。",
            positionNotes: [],
            cues: [],
            mistake: nil
        ),
        Exercise(
            id: "bike",
            name: "单车",
            group: "有氧",
            equipment: "cardio",
            met: 7.0,
            unit: .minutes,
            tip: "座椅高度以踩到底膝微屈为准，保持匀速。",
            positionNotes: [],
            cues: [],
            mistake: nil
        ),
        Exercise(
            id: "rower",
            name: "划船机",
            group: "有氧",
            equipment: "cardio",
            met: 7.0,
            unit: .minutes,
            tip: "腿-髋-手顺序发力，回程手-髋-腿。",
            positionNotes: [],
            cues: [],
            mistake: nil
        ),
        Exercise(
            id: "rope",
            name: "跳绳",
            group: "有氧",
            equipment: "cardio",
            met: 11.0,
            unit: .minutes,
            tip: "小幅度弹跳，手腕摇绳，可 30 秒快慢交替。",
            positionNotes: [],
            cues: [],
            mistake: nil
        ),
        Exercise(
            id: "elliptical",
            name: "椭圆机",
            group: "有氧",
            equipment: "cardio",
            met: 5.0,
            unit: .minutes,
            tip: "全程脚不离踏板，阻力调到需要发力。",
            positionNotes: [],
            cues: [],
            mistake: nil
        ),
        Exercise(
            id: "swim",
            name: "游泳",
            group: "有氧",
            equipment: "cardio",
            met: 7.0,
            unit: .minutes,
            tip: "自由泳匀速，注意换气节奏，关节负担小。",
            positionNotes: [],
            cues: [],
            mistake: nil
        ),
        Exercise(
            id: "stair",
            name: "爬楼机",
            group: "有氧",
            equipment: "cardio",
            met: 9.0,
            unit: .minutes,
            tip: "不要扶扶手借力，全脚掌踩实台阶。",
            positionNotes: [],
            cues: [],
            mistake: nil
        ),
        Exercise(
            id: "hiit",
            name: "HIIT 循环",
            group: "有氧",
            equipment: "cardio",
            met: 8.0,
            unit: .minutes,
            tip: "20 秒全力 + 10 秒休息，动作可换波比跳/开合跳。",
            positionNotes: [],
            cues: [],
            mistake: nil
        ),
        Exercise(
            id: "kb-swing",
            name: "壶铃摆荡",
            group: "腿",
            equipment: "dumbbell",
            met: 6.0,
            unit: .reps,
            tip: "靠髋部铰链发力把壶铃荡起，手臂只是绳索。",
            positionNotes: [
                PositionNote(part: "髋部", text: "靠髋部铰链爆发发力"),
                PositionNote(part: "手臂", text: "手臂只是绳索，不主动抬"),
                PositionNote(part: "核心", text: "顶端收紧腹臀，不后仰")
            ],
            cues: [
                "起始：壶铃在体后，髋铰链蓄力，背挺直",
                "爆发：髋向前顶，手臂只是绳索不主动抬",
                "顶端：腹臀收紧，壶铃到胸高即止",
                "回落：顺势让壶铃荡回体后，别用手臂去拉"
            ],
            mistake: "用手臂抬成前平举、蹲成深蹲 → 只做髋铰链爆发，手臂放松"
        )
    ]

    static let byID: [String: Exercise] = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
    static let groups: [String] = ["胸", "背", "腿", "肩", "手臂", "核心", "有氧"]

    /// 同族变式：动作详情里可快速跳到难度相近的其它动作
    static let families: [[String]] = [
        ["pullup", "chinup", "neutral-pullup", "one-arm-pullup", "muscle-up"],
        ["ab-wheel", "ab-wheel-stand"]
    ]

    /// 引体族四种握法说明（纯文字）
    static let gripTexts: [GripText] = [
        GripText(name: "正握", detail: "掌心朝前，握距略宽于肩，主练背阔"),
        GripText(name: "反手", detail: "掌心朝向自己，与肩同宽，肱二头参与更多"),
        GripText(name: "对握", detail: "掌心相对，两手几乎贴紧，肘贴身后拉"),
        GripText(name: "单手", detail: "一手抓杠，另一手贴体侧，身体不旋转")
    ]

    static func family(of id: String) -> [Exercise] {
        guard let f = families.first(where: { $0.contains(id) }) else { return [] }
        return f.filter { $0 != id }.compactMap { byID[$0] }
    }

    static func equipmentLabel(_ eq: String) -> String {
        switch eq {
        case "barbell": return "杠铃"
        case "dumbbell": return "哑铃"
        case "machine": return "器械"
        case "cable": return "绳索"
        case "bodyweight": return "自重"
        case "band": return "弹力带"
        case "cardio": return "有氧"
        default: return eq
        }
    }

    static func search(_ text: String, group: String? = nil) -> [Exercise] {
        let key = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return all.filter { e in
            (group == nil || e.group == group!) &&
            (key.isEmpty || e.name.localizedCaseInsensitiveContains(key) || e.id.localizedCaseInsensitiveContains(key))
        }
    }
}
