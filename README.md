# Rime 输入法配置

个人 Rime 配置，当前主力方案是五笔86（微软双拼反查）+ 微软双拼（笔画反查），辅以英文次翻译器、Emoji、符号表、Lua 扩展和跨平台同步

## 特性

- `wubi86`：五笔方案，支持 `z` 进入双拼反查，开启自动造词
- `double_mspy`：微软双拼方案，简体词库，支持笔画反查和以词定字
- `melt_eng`：借鉴 [rime-melt](https://github.com/tumuyan/rime-melt) 的英文次翻译器，在中文方案中输入英文
- 中英间距：`lua/en_spacer.lua` 会在中文/英文候选边界自动补空格
- Emoji：使用 [雾凇拼音](https://github.com/iDvel/rime-ice) 整理的 OpenCC Emoji 映射
- 符号输入：`/` 引导符号、数字、Emoji、邮箱等自定义候选

## 日常使用

### 方案切换

- `Control+grave`：打开方案切换菜单
- 默认启用两个方案：
  - `MSPY`：微软双拼
  - `五笔86`：五笔86

候选页大小是 5 个

### 通用按键

- `-`：上一页
- `=`：下一页
- `Tab` / `Ctrl+n`：下一个候选
- `Shift+Tab` / `Ctrl+p`：上一个候选
- `Ctrl+f` / `Ctrl+b`：移动光标或分段
- `Ctrl+k`：删除用户词
- `Ctrl+[` / `Ctrl+c`：清空当前编码
- `Left Shift`：中英文切换，当前配置为 `commit_code`

### 五笔86

官方默认的86版五笔码表有时候打出的字繁体在前并且可能出现缺字的可能，所以用微软五笔的单字替换官方的字典中的单字参考了[这理](https://github.com/networm/Rime)

- 方案文件：`wubi86.schema.yaml`
- 主词库入口：`zhcn_wubi.dict.yaml`
- 个人词库：`zhcn_wubi_custom.dict.yaml`
- 按 `z` 进入双拼反查，例如在五笔里临时用双拼查字
- 默认开启 `translator/enable_encoder: true` [自动造词](https://github.com/rime/librime/issues/184)，不会改变码表的候选词位置
- `fixed` 翻译器禁用用户调频，用来保持基础码表候选顺序稳定

### 微软双拼

只支持微软的方案，字典全部使用的是简体字，去掉了自带的繁简转换

- 方案文件：`double_mspy.schema.yaml`
- 主词库入口：`zhcn_simp.dict.yaml`
- 个人词库：`pinyin_simp_custom.dict.yaml`
- 使用微软双拼键位，只保留简体输出，不做繁简转换
- 反查：
  - `` ` ``：进入笔画反查
  - 笔画编码使用 `hspnz`，预编辑显示为 `一丨丿丶乙`
- [以词定字](https://github.com/BlindingDark/rime-lua-select-character)：
  - `[`：取当前候选词的第一个字
  - `]`：取当前候选词的最后一个字
  - 实现文件：`lua/select_character.lua`

### 英文输入和中英间距

两个中文方案都挂载了 `table_translator@melt_eng`，因此在中文输入中也会出现英文候选，例如 `ChatGPT`、`OpenAI` 等

相关文件：

- `melt_eng.schema.yaml`：英文方案定义
- `melt_eng.dict.yaml`：英文主词库入口
- `melt_eng_base.dict.yaml`：英文基础词库，来自 rime-melt
- `melt_mult_language.dict.yaml`：中英混输和符号词库
- `melt_eng_custom.dict.yaml`：个人英文词库
- `lua/en_spacer.lua`：候选上屏前的中英间距处理

当前行为：

- 英文候选权重为 `initial_quality: 0.8`，默认不抢中文首选
- 中文后选英文：`我` + `OpenAI` 上屏为 `我 OpenAI`
- 英文后选中文：`OpenAI` + `模型` 上屏为 `OpenAI 模型`
- 连续英文：`OpenAI` + `ChatGPT` 上屏为 `OpenAI ChatGPT`

注意：`en_spacer` 是候选 filter，只处理 Rime 候选上屏；如果已经切到 `ascii_mode` 直接打英文，不会经过这个 filter

如果英文候选太靠后或太靠前，调整两个中文 schema 里的：

```yaml
melt_eng:
  initial_quality: 0.8
```

数值越大，英文候选越靠前；数值越小，对中文输入干扰越少

### Emoji 和符号

Emoji 表情使用 [雾凇拼音](https://github.com/iDvel/rime-ice/tree/main/opencc) 整理的

`emoji_suggestion` 默认开启，双拼和五笔都会经过 `simplifier@emoji_suggestion`

`/` 可以触发符号候选。常用自定义入口在 `default.yaml`：

- `/mail`：邮箱
- `/hh`：花草
- `/bq`：常用表情
- `/ss`：手势

完整符号表在 `punctuator.yaml`，包括数学、箭头、罗马数字、拉丁字母、单位、星座、八卦等分类，例如：

- `/fh`：符号
- `/dn`：电脑按键
- `/jt`：箭头
- `/sx`：数学符号
- `/0` 到 `/10`：数字相关符号

## 安装

要先知道各系统的配置目录，各个平台有相应的发行版配置的地方也不同，选择相应的安装即可

- `用户目录` 存放用户的配置文件的地方，个人配置就放在这
- `系统共享目录` 共享目录提供了一些自带的方案及各项默认配置，供个人配置引用，一般不需要做改动

<details>
<summary>选择各平台发行版及配置目录</summary>
<details>
<summary>Android</summary>
<details>
<summary>Fcitx5 Android</summary>

安装 [Fcitx5](https://github.com/fcitx5-android/fcitx5-android) 和 [Rime Plugin](https://f-droid.org/en/packages/org.fcitx.fcitx5.android.plugin.rime/)

- 用户目录：`/storage/emulated/0/Android/data/org.fcitx.fcitx5.android/files/data/rime/`
- 系统共享目录：`/data/user_de/0/org.fcitx.fcitx5.android/usr/share/rime-data/`

</details>
</details>

<details>
<summary>macOS</summary>
<details>
<summary>Squirrel</summary>

[Squirrel](https://github.com/rime/squirrel)

- 用户目录：`~/Library/Rime`
- 系统共享目录：`/Library/Input Methods/Squirrel.app/Contents/SharedSupport/`

</details>
</details>

<details>
<summary>UN*X</summary>
<details>
<summary>Fcitx</summary>

[Fcitx](https://github.com/fcitx/fcitx-rime)

- 用户目录：`~/.config/fcitx/rime`

</details>

<details>
<summary>Fcitx5</summary>

[Fcitx5](https://github.com/fcitx/fcitx5-rime)

- 用户目录：`~/.local/share/fcitx5/rime`
- 系统共享目录：`/usr/share/rime-data`

</details>

<details>
<summary>IBus</summary>

[IBus](https://github.com/rime/ibus-rime)

- 用户目录：`~/.config/ibus/rime`
- 系统共享目录：`/usr/share/rime-data/`

</details>
</details>

<details>
<summary>Windows</summary>
<details>
<summary>Weasel</summary>

[Weasel](https://github.com/rime/weasel)

- 用户目录：`%AppData%\Rime`

</details>
</details>
</details>

---

1. 克隆此仓库，在`用户目录`中拷贝默认安装生成的 `user.yaml` 和 `installation.yaml` 两个文件到本项目
2. 删除原本的用户配置目录
3. 最后将此项目软连接到`用户目录`替换原来的配置目录

每次修改 schema、词库、OpenCC、Lua 或前端配置后，都需要重新部署

## 自定义

### 添加双拼词条

双拼主词库入口是 `zhcn_simp.dict.yaml`，它会导入：

- `cn_dicts/pinyin/pinyin_simp`
- `cn_dicts/pinyin/xiandaihanyuchangyongcibiao`
- `cn_dicts/pinyin/zhwiki-*`
- `cn_dicts/pinyin/pinyin_simp_custom`

编辑 `pinyin_simp_custom.dict.yaml`，在 `...` 后添加词条：

```text
自定义词	zi ding yi ci	100
```

### 添加五笔词条

五笔主词库入口是 `zhcn_wubi.dict.yaml`，它会导入：

- `cn_dicts/wubi/wubi86`
- `cn_dicts/wubi/zhcn_wubi_custom`

编辑 `zhcn_wubi_custom.dict.yaml`，在 `...` 后添加词条：

```text
自定义词	xxxx	100
```

注意：五笔自定义词条使用 tab 分隔 `字词`、`编码`、`权重`。

### 添加英文词条

英文主词库入口是 `melt_eng.dict.yaml`，它会导入：

- `en_dicts/melt_eng_base`
- `en_dicts/melt_mult_language`
- `en_dicts/melt_eng_custom`

编辑 `melt_eng_custom.dict.yaml`，在 `...` 后添加词条：

```text
OpenAI	OpenAI	100
ChatGPT	ChatGPT	100
```

### 添加符号和短语

少量个人短语建议加在 `default.yaml` 的 `punctuator/symbols` 下：

```yaml
punctuator:
  symbols:
    "/addr": ["某个地址"]
```

大量符号分类建议放到 `punctuator.yaml` 的 `symbols` 下

### 调整快捷键

通用快捷键在 `default.yaml` 的 `key_binder/bindings`

方案内快捷键在各自 schema：

- `double_mspy.schema.yaml`：`key_binder/select_first_character` 和 `select_last_character`
- `wubi86.schema.yaml`：逗号、句号选第 2、3 候选

### 调整中英文切换

编辑 `default.yaml` 的 `ascii_composer/switch_key`

当前配置：

```yaml
Shift_L: commit_code
Shift_R: noop
Caps_Lock: noop
```

如果希望左 Shift 临时进入行内英文编辑区，可以改为：

```yaml
Shift_L: inline_ascii
```

### 调整模糊音

双拼模糊音配置在 `double_mspy.schema.yaml` 的 `speller/algebra`，目前开启：

- `in` 和 `ing` 互转
- `ju/qu/xu/yu` 与 `v` 相关容错
- 零声母 `aoe` 容错

其他模糊音如 `z/c/s` 与 `zh/ch/sh`、`l/r` 等保留为注释，可按需打开

## 配置文件说明

以下是本配置库各文件说明

```text
.
├── build/                                    # 部署之后产生的构建结果，每次部署都会变
│   └── ...
├── lua/                                      # 存放 Lua 扩展脚本
│   ├── select_character.lua                  # 双拼 Lua 以词定字选词扩展
│   └── en_spacer.lua                         # 中英候选边界自动补空格
├── opencc/                                   # 词语映射文件夹，如 Emoji 实现就在这
│   └── ...
├── cn_dicts/                                 # 中文词库
│   ├── pinyin/                               # 拼音、双拼相关词库
│   │   ├── pinyin_simp.dict.yaml             # 袖珍简化字拼音词库
│   │   ├── xiandaihanyuchangyongcibiao.dict.yaml # 现代汉语常用词库
│   │   ├── zhwiki-*.dict.yaml                # 中文维基百科词库
│   │   └── pinyin_simp_custom.dict.yaml      # 双拼个人自定义词库
│   └── wubi/                                 # 五笔相关词库
│       ├── wubi86.dict.yaml                  # 官方86版五笔字典
│       └── zhcn_wubi_custom.dict.yaml        # 五笔个人自定义词库
├── en_dicts/                                 # 英文和中英混输词库
│   ├── melt_eng_base.dict.yaml               # 英文基础词库
│   ├── melt_mult_language.dict.yaml          # 中英混输和符号词库
│   └── melt_eng_custom.dict.yaml             # 英文个人词库
├── installation.yaml                         # 安装 Rime 产生的元信息文件包括安装时间、版本信息、机器ID等
├── user.yaml                                 # 本机设置 如记住上次使用的输入方案、什么时候用的等
├── punctuator.yaml                           # 从共享目录复制 `punctuation.yaml` 修改的符号注音映射表
│
├── default.yaml                              # 全局配置入口，方案列表、快捷键、标点、recognizer、中英文切换
│
├── double_mspy.schema.yaml                   # 微软双拼方案
├── zhcn_simp.dict.yaml                       # 双拼主词库入口，导入 cn_dicts/pinyin/ 下的子词库
├── zhcn_simp.userdb/                         # 使用双拼中中产生的二进制的用户词典 如开启同步就是同步此字典
│   └── ...
│
├── wubi86.schema.yaml                        # 五笔输入方案
├── zhcn_wubi.dict.yaml                       # 五笔主词库入口，导入 cn_dicts/wubi/ 下的子词库
├── zhcn_wubi.userdb/                         # 使用五笔中产生的二进制的用户词典 如开启同步就是同步此字典
│   └── ...
│
├── melt_eng.schema.yaml                      # 英文次翻译器方案
├── melt_eng.dict.yaml                        # 英文主词库入口，导入 en_dicts/ 下的子词库
│
├── squirrel.custom.yaml                      # mac 鼠须管前端配置文件，外观和应用级默认状态
└── rime_dict_manager                         # 字典管理 mac 上用
```

## 多平台同步

修改 `installation.yaml` 中的 `installation_id` 和 `sync_dir` 两项，没有的话就添加下

- `sync_dir`: 用于同步的目录，各种云同步此文件夹就行
- `installation_id`: 用于区分不同设备，每个设备的 `installation_id` 都不同，同步时会在 `sync_dir` 中创建一个以 `installation_id` 为名的文件夹

> 同步会同步用户配置文件夹下的文件但不会同步子文件夹
> 主要是同步用户输入中产生的 `*.userdb/` 文件夹内的二进制用户词典，会转成可读的 `*.userdb.txt` 文件到 `{sync_dir}/{installation_id}`
> `build/` 是部署产物，会重新生成，`installation.yaml` 和 `user.yaml` 含有本机状态

## Reference

- Rime 配置文档：[Configuration](https://github.com/rime/home/wiki/Configuration)
- Rime 定制指南：[CustomizationGuide](https://github.com/rime/home/wiki/CustomizationGuide)
- Schema 说明：[RimeWithSchemata](https://github.com/rime/home/wiki/RimeWithSchemata)
- 英文词库：[tumuyan/rime-melt](https://github.com/tumuyan/rime-melt)
- Emoji 映射：[iDvel/rime-ice](https://github.com/iDvel/rime-ice)
- 以词定字：[rime-lua-select-character](https://github.com/BlindingDark/rime-lua-select-character)
- 维基词库：[felixonmars/fcitx5-pinyin-zhwiki](https://github.com/felixonmars/fcitx5-pinyin-zhwiki)
