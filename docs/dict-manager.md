# 用户词典管理

### 同步机制

Rime 输入时使用本机用户目录中的 `*.userdb/` 数据库，不会把云盘中的 `*.userdb.txt` 直接当作运行数据库。执行“同步用户资料”时，对于本机已经存在的每个用户词典，Rime 会：

1. 扫描 `sync_dir` 下每个一级设备目录
2. 合入精确同名的 `<词典名>.userdb.txt`
3. 将合并后的本机用户词典重新备份到 `sync_dir/<当前 installation_id>/`

例如同步 `zhcn_wubi` 时会读取：

```text
Rime/
├── A_host/zhcn_wubi.userdb.txt
├── B_host/zhcn_wubi.userdb.txt
└── C_host/zhcn_wubi.userdb.txt
```

同步不是按修改时间选择单个“最新文件”，而是合并所有可见的同名快照。刚刚成功同步后，当前设备新生成的 `zhcn_wubi.userdb.txt` 可以作为本次同步时的整合快照。

以下文件不会自动合入用户词典：

- `zhcn_wubi.userdb_<xx>_<xx>_conflict.txt` 等云同步产生的冲突副本，因为文件名不精确匹配
- 设备目录中的 `installation.yaml`、`user.yaml`、`*.dict.yaml` 等配置备份
- `build/`、`trash/` 等本机构建或废弃目录

Rime 默认还会把用户目录根层的 YAML 和 TXT 文件单向备份到当前设备目录。静态大词典会因此在每台设备下重复出现。若配置文件已经由本仓库管理，可在每台活跃设备本地的 `installation.yaml` 中加入：

```yaml
backup_config_files: false
```

这只会停止后续的配置文件备份，不会关闭 `*.userdb.txt` 用户词典同步，也不会自动删除已有副本。

### 清理或合并旧的用户词典

在 macOS 鼠须管上带了一个 `rime_dict_manager` 脚本，可以用来合并冲突快照、清理旧

```bash
RIME_USER_DIR="$HOME/Library/Rime"
RIME_SYNC_DIR="$HOME/RemoteDrive/Rime"
RIME_DICT_MANAGER="$RIME_USER_DIR/rime_dict_manager"
```

操作前先完成以下准备：

1. 确保云盘同步完成，暂时关闭
2. 将整个 `RIME_SYNC_DIR` 完整备份到同步目录之外
3. 切换到 ABC 等非 Rime 输入法，确认没有正在部署或同步
4. 关闭鼠须管并确认进程已经退出

```bash
killall Squirrel
pgrep -x Squirrel
```

`pgrep` 没有输出才表示鼠须管已经退出，执行

```bash
cd "$RIME_USER_DIR"

fd --type f --glob '*.userdb*.txt' \
  "$RIME_SYNC_DIR" \
  --threads=1 \
  -x "$RIME_DICT_MANAGER" --restore {}
```

`rime_dict_manager --restore` 会从快照元数据读取所属词典名称，因此不需要把冲突文件改回原名。重复合入已有快照也不会简单重复累加词频。

等待全部恢复成功后，然后可以按需删除 `RIME_SYNC_DIR` 下的文件

最后在鼠须管仍关闭的情况下执行一次完整用户词典同步：

```bash
cd "$RIME_USER_DIR"
"$RIME_DICT_MANAGER" --sync
```

该命令会继续合入同步目录中所有正常命名的同名快照，并生成或更新 `<当前 installation_id>` 目录，生成整合后的新快照。之后切换回鼠须管，macOS 会自动重新启动输入法。

也可以单独备份指定词典：

```bash
"$RIME_DICT_MANAGER" --backup zhcn_wubi
```

官方说明：[同步用户资料](https://github.com/rime/home/wiki/UserGuide#同步用戶資料)、[用户词典管理](https://github.com/rime/home/wiki/UserGuide#用戶詞典管理)
