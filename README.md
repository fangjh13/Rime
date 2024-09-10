# Rime 输入法配置

## 安装

要先知道各系统的配置目录

**Android**

- [Trime](https://github.com/osfans/trime): `/sdcard/rime`

**macOS**

- [Squirrel](https://github.com/rime/squirrel): `~/Library/Rime`

**UN\*X**

- [Fcitx](https://github.com/fcitx/fcitx-rime): `~/.config/fcitx/rime`
- [Fcitx5](https://github.com/fcitx/fcitx5-rime): `~/.local/share/fcitx5/rime`
- [IBus](https://github.com/rime/ibus-rime): `~/.config/ibus/rime`

**Windows**

- [Weasel](https://github.com/rime/weasel): `%AppData%\Rime`

1. 克隆此仓库，在配置目录中拷贝默认安装生成的 `user.yaml` 和 `installation.yaml` 两个文件到本项目
2. 删除原本的配置目录
3. 最后将此项目软连接到原来目录

## 同步

修改 `installation.yaml` 中的 `installation_id` 和 `sync_dir` 两项，没有的话就添加下

- `sync_dir`: 用于同步的目录，各种云同步此文件夹就行
- `installation_id`: 用于区分不同设备，每个设备的 `installation_id` 都不同，同步时会在 `sync_dir` 中创建一个以 `installation_id` 为名的文件夹

## Emoji

Emoji 表情使用 [雾凇拼音](https://github.com/iDvel/rime-ice/tree/main/opencc) 整理的
