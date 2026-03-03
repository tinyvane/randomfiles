# randomfiles - 随机文件生成工具 - 项目规划

## 项目概述
包含 btsync 同步脚本的随机文件相关工具（Shell 脚本）。

---

## 2026-03-03 Claude 建议

### 建议
- btsync（BitTorrent Sync）是 Resilio Sync 的前身，用于 P2P 文件同步
- **应用场景**：多设备文件同步（不走中心服务器）

### 现代替代
- Syncthing（开源免费，P2P 同步）
- 坚果云 / OneDrive（简单易用）

### 如有测试文件需求
- 生成大文件（测试上传速度）
- 生成随机数据（压力测试）
- Python `os.urandom()` 更简洁
