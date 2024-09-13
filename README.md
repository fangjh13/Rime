# Rime 输入法配置

五笔86 + 微软双拼反查

- `Ctrl+s` or `Control+grave` 切换输入方案
- 自动造词
- 自定义词库
- `/` 键 _试试输入 `/hh` 可自定义添加_
- Emoji
- `Ctrl+[` or `Ctrl+c` 清码

配置参考文档：

- [Rime 配置文件](https://github.com/rime/home/wiki/Configuration)
- [RimeWithSchemata](https://github.com/rime/home/wiki/RimeWithSchemata)
- [Rime 定制指南](https://github.com/rime/home/wiki/CustomizationGuide)
- [schema.yaml 详解](https://github.com/LEOYoon-Tsaw/Rime_collections/blob/master/Rime_description.md)

## 86 版五笔

- 官方默认的86版五笔码表有时候打出的字繁体在前并且可能出现缺字的可能，所以用微软五笔的单字替换官方的字典中的单字参考了[这理](https://github.com/networm/Rime)

- 支持按 `z` 双拼反查

- 默认开启[自动造词](https://github.com/rime/librime/issues/184)，不会改变码表的候选词位置

## 微软双拼

- 只支持微软的方案，字典全部使用的是简体字，去掉了自带的繁简转换

- 支持[以词定字](https://github.com/BlindingDark/rime-lua-select-character) `[` 为第一个字 `]` 为最后一个字符

## 安装

要先知道各系统的配置目录，各个平台有相应的发行版配置的地方也不同，选择相应的安装即可

`用户目录` 存放用户的配置文件的地方，个人配置就放在这

`系统共享目录` 共享目录提供了一些自带的方案及各项默认配置，供个人配置引用，一般不需要做改动

<details>
<summary>选择各平台发行版及配置目录</summary>
<details>
<summary>Android</summary>
<details>
<summary>Trime</summary>

[Trime](https://github.com/osfans/trime)

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

## Emoji

Emoji 表情使用 [雾凇拼音](https://github.com/iDvel/rime-ice/tree/main/opencc) 整理的

## 配置文件说明

以下是本配置库各文件说明

```
.
├── build/                                    # 部署之后产生的文件
│   └── ...
├── lua/                                      # 存放 Lua 扩展脚本
│   └── select_character.lua                  # Lua 以词定字选词扩展
├── opencc/                                   # 词语映射文件夹，如 Emoji 实现就在这
│   └── ...
├── installation.yaml                         # 安装 Rime 产生的元信息文件包括安装时间、版本信息、机器ID等
├── user.yaml                                 # 本机设置 如记住上次使用的输入方案、什么时候用的等

├── punctuator.yaml                           # 从共享目录复制 `punctuation.yaml` 修改的符号注音映射表

├── default.yaml                              # 全局配置入口

├── double_mspy.schema.yaml                   # 微软双拼方案
├── zhcn_simp.dict.yaml                       # 双拼主词库主要导入下面子词库
├── pinyin_simp.dict.yaml                     #  - 袖珍简化字词库
├── xiandaihanyuchangyongcibiao.dict.yaml     #  - 现代汉语常用词库
├── zhwiki_*.dict.yaml                        #  - 中文维基百科词库
├── pinyin_simp_custom.dict.yaml              #  - 个人自定义词库可自行添加
├── zhcn_simp.userdb/                         # 使用双拼中中产生的二进制的用户词典 如开启同步就是同步此字典
│   └── ...

├── wubi86.schema.yaml                        # 五笔输入方案
├── zhcn_wubi.dict.yaml                       # 五笔主词库主要导入下面子词库
├── wubi86.dict.yaml                          #  - 官方86版五笔字典
├── zhcn_wubi_custom.dict.yaml                #  - 个人自定义词库可自行添加
├── zhcn_wubi.userdb/                         # 使用五笔中产生的二进制的用户词典 如开启同步就是同步此字典
│   └── ...

├── squirrel.custom.yaml                      # mac 鼠须管前端配置文件
└── rime_dict_manager                         # 字典管理 mac 上用
```

> NOTE: 中文维基百科词库不定期更新地址 https://github.com/felixonmars/fcitx5-pinyin-zhwiki

## 多平台同步

修改 `installation.yaml` 中的 `installation_id` 和 `sync_dir` 两项，没有的话就添加下

- `sync_dir`: 用于同步的目录，各种云同步此文件夹就行
- `installation_id`: 用于区分不同设备，每个设备的 `installation_id` 都不同，同步时会在 `sync_dir` 中创建一个以 `installation_id` 为名的文件夹

> 同步会同步用户配置文件夹下的文件但不会同步子文件夹
> 主要是同步用户输入中产生的 `*.userdb/` 文件夹内的二进制用户词典，会转成可读的 `*.userdb.txt` 文件到 `{sync_dir}/{installation_id}`
