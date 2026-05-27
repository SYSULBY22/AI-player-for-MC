# AIMC — 在《我的世界》里加一个 AI 队友

你刚拿到这个项目文件夹。按下面顺序做，就能让一个 AI 以「第二个玩家」的身份进你的世界，帮你挖矿、建造、战斗、聊天。

**它是什么？** 基于开源 [Mindcraft](https://github.com/mindcraft-bots/mindcraft)：大模型负责思考，程序通过「局域网开放」连进你的单人世界。**不是**改游戏模组，也**不是**看屏幕点鼠标的外挂。

**你需要知道的一件事：** 游戏必须开启「对局域网开放」，且端口固定为 **55916**。这是连线的唯一入口，漏做这一步 AI 永远进不来。

---

## 一、开始前：准备这些东西

在动手之前，请确认：

| 准备项 | 要求 |
|--------|------|
| 操作系统 | **Windows**（本项目脚本为 `.bat`，面向 Windows） |
| 《我的世界》 | **Java 版**，版本建议 **1.21.10**，已安装 **Fabric 0.17.3**（可用 PCL、HMCL 等启动器） |
| Node.js | **20 LTS** 推荐（[下载](https://nodejs.org/)）。若已是 v22+ 且安装报错，请改用 20 |
| Git | [下载](https://git-scm.com/download/win)（仅第一次安装 AI 环境时需要） |
| AI 方案（二选一） | **方案 A**：本机 [Ollama](https://ollama.com/download)，免费、占磁盘<br>**方案 B**：DeepSeek + 阿里云 DashScope 的 API 密钥，更聪明、按量计费 |

打开文件夹后，应能看到这些关键文件（名称不必完全一致，但结构类似）：

```
AIMC/                          ← 项目根目录（本 README 所在位置）
├── README.md
├── 安装AI环境.bat
├── 安装Ollama本地模型.bat      ← 仅方案 A 需要
├── 启动AI玩家.bat
├── 启动AI玩家-云端API.bat      ← 方案 B 推荐用这个
├── 检查局域网端口.bat
├── .env.example               ← 方案 B 的密钥模板
└── mindcraft/                 ← AI 核心程序
    ├── settings.js
    └── aimc-bot.json          ← 机器人名字与模型配置
```

---

## 二、第一步：安装 AI 运行环境（只需做一次）

1. 进入项目**根目录**（和 `README.md` 同级）。
2. **双击** `安装AI环境.bat`。
3. 等待窗口跑完（首次约 **5～15 分钟**），期间会：
   - 若缺少 `mindcraft` 文件夹，自动从 GitHub 拉取 Mindcraft；
   - 在 `mindcraft` 里执行 `npm install` 安装依赖。
4. 看到 **Done** 或类似提示即表示成功。

**若报错：**

- `git clone failed` → 安装 Git，或检查网络。
- `npm install failed` → 安装 **Node.js 20 LTS**，删掉 `mindcraft\node_modules` 文件夹后，再双击一次 `安装AI环境.bat`。

安装脚本还会自动生成 `.env` 文件（从 `.env.example` 复制）。**先不要关窗口**，继续下一步选方案。

---

## 三、第二步：选择 AI「大脑」并配置

两种方案**只能先选一种**配好；之后可随时改 `mindcraft/aimc-bot.json` 切换。

---

### 方案 A：完全本地（免费，不用填 API 密钥）

适合：不想花钱、能接受 AI 稍笨一点、电脑磁盘够（模型约 2～4 GB）。

**A-1.** 安装 [Ollama](https://ollama.com/download)，安装后保持它在后台运行（托盘里能看到图标）。

**A-2.** 回到项目根目录，**双击** `安装Ollama本地模型.bat`，等待模型下载完成。

**A-3.** 用记事本打开 `mindcraft\aimc-bot.json`，改成下面内容（注意逗号与引号）：

```json
{
    "name": "小艾",
    "model": "ollama/sweaterdog/andy-4:micro-q8_0",
    "embedding": "ollama"
}
```

`name` 是游戏里的机器人名字，下面指挥它时要和这里一致。

**A-4.** 方案 A **不用**编辑 `.env`，可以跳过下一小节，直接去 **第四步** 启动游戏。

---

### 方案 B：云端 API（更聪明，需要两个密钥）

适合：想要更好的理解与执行力，愿意申请 API。

仓库默认已按 **DeepSeek 对话 + 阿里云嵌入** 配好 `mindcraft\aimc-bot.json`，你只需填密钥。

**B-1. 申请密钥**

| 变量名 | 用途 | 去哪申请 |
|--------|------|----------|
| `DEEPSEEK_API_KEY` | AI 对话、思考 | [DeepSeek 开放平台](https://platform.deepseek.com/) |
| `EMBEDDING_API_KEY` | 记忆检索（嵌入向量） | [阿里云 DashScope](https://dashscope.console.aliyun.com/)（开通后创建 API Key） |

**B-2. 填写 `.env` 文件**

1. 在项目**根目录**找到 `.env`（若没有：复制 `.env.example`，重命名或另存为 `.env`）。
2. 用记事本打开，把占位符换成你的真实密钥，例如：

```env
DEEPSEEK_API_KEY=sk-xxxxxxxx
EMBEDDING_API_KEY=sk-xxxxxxxx
```

3. 保存。注意：
   - 等号两边**不要加空格**；
   - **不要**把 `.env` 发给别人或上传到 GitHub（已在 `.gitignore` 里忽略）。

**B-3. 确认机器人配置**

打开 `mindcraft\aimc-bot.json`，默认应为（一般不用改）：

```json
{
    "name": "XiaoAi",
    "model": {
        "api": "deepseek",
        "model": "deepseek-chat"
    },
    "embedding": {
        "api": "qwen",
        "url": "https://dashscope.aliyuncs.com/compatible-mode/v1",
        "model": "text-embedding-v3"
    }
}
```

游戏内私聊机器人时，名字是 **`XiaoAi`**（区分大小写）。

---

## 四、第三步：启动《我的世界》并开放局域网

**每次玩都要做**，顺序不能反：先开游戏并开放局域网，再启动 AI。

1. 用你的启动器（PCL、HMCL 等）启动 **Java 版** Minecraft，版本 **1.21.10 + Fabric**。
   - 仓库里可能有 `启动 1.21.10-Fabric 0.17.3.bat`，那是作者本机路径的示例；**你的电脑**请用自己的启动器，或改 bat 里的路径后再用。
2. 进入或创建一个**单人世界**，等完全加载进地图。
3. 按 **ESC** → 点击 **「对局域网开放」**（Open to LAN）。
4. 在端口一栏输入：**`55916`**（必须与此一致，见 `mindcraft/settings.js` 里的 `port`）。
5. 点击开始开放，看到「本地游戏已在端口 55916 上开放」一类提示。
6. **保持在这个世界里**，不要退回主菜单，也不要退出游戏。

**可选自检：** 开放局域网后，双击 `检查局域网端口.bat`，确认 55916 已在监听。

---

## 五、第四步：启动 AI 玩家

回到项目根目录，根据你的方案选择脚本：

| 你的方案 | 双击运行 |
|----------|----------|
| 方案 B（云端，已填好 `.env`） | **`启动AI玩家-云端API.bat`** |
| 方案 A（Ollama）或已确认环境无误 | **`启动AI玩家.bat`** |

1. 黑窗口会提示确认：此时应已满足「游戏在世界内 + 局域网端口 55916」。
2. 按任意键继续，等待出现连接成功、机器人生成等日志。
3. 浏览器一般会自动打开 **http://localhost:8080**（网页控制面板）；若没有，可手动在浏览器输入该地址。

**若提示缺少 `.env` 或 API key：** 说明方案 B 的密钥未配好，回到 **第三步方案 B** 检查 `.env` 两行密钥是否已保存。

---

## 六、第五步：在游戏里指挥 AI

机器人名字以 `mindcraft\aimc-bot.json` 里的 `name` 为准：

- 方案 A 默认：**小艾**
- 方案 B 默认：**XiaoAi**

在聊天栏输入（把名字换成你的）：

```
/msg XiaoAi 你好
/msg XiaoAi 去砍 10 个木头
/msg XiaoAi 在我旁边建一个 5x5 的平台
```

也可以在浏览器 **http://localhost:8080** 的界面里输入任务。

**指令越具体，AI 越容易做对**，例如：「向前挖 3 格」「把背包里的圆石放到箱子里」。

---

## 七、以后每次玩：推荐顺序（速查）

```
1. 启动 Minecraft → 进入单人世界
2. ESC → 对局域网开放 → 端口 55916
3. 双击 启动AI玩家.bat 或 启动AI玩家-云端API.bat
4. 在游戏或网页里 /msg 机器人名字 + 指令
```

关掉 AI：直接关闭启动 AI 时的黑窗口即可。下次玩重复上面四步。

---

## 八、常见问题

**黑窗口里写 MC server not found / 一直 spawning**

- 最常见原因：**还没开放局域网**，或端口不是 **55916**。
- 请确保人还在世界里，且局域网仍处于开放状态。

**提示 API key not found**

- 方案 B：检查根目录 `.env` 里是否有 `DEEPSEEK_API_KEY` 和 `EMBEDDING_API_KEY`，保存后重新运行 bat。
- 方案 A：确认 `aimc-bot.json` 已改为 Ollama 配置，且 Ollama 在后台运行。

**npm / Node 相关报错**

- 安装 **Node.js 20 LTS**，删除 `mindcraft\node_modules` 后重新运行 `安装AI环境.bat`。

**AI 进服了但很笨、不动**

- 方案 A 模型较小，可换方案 B，或换更大的 Ollama 模型。
- 把任务说得更具体，一次只给一件事。

**部分 Fabric 模组导致连不上**

- 先用**尽量少 mod 的 Fabric** 测试；个别模组会与 Mineflayer 冲突。

**想改成更激进的生存模式**

- 编辑 `mindcraft\settings.js`，把 `base_profile` 从 `"assistant"` 改为 `"survival"`。

---

## 九、主要文件是干什么的

| 文件 | 作用 |
|------|------|
| `安装AI环境.bat` | 首次安装依赖（必做） |
| `安装Ollama本地模型.bat` | 方案 A：下载本地模型 |
| `启动AI玩家-云端API.bat` | 方案 B：检查 `.env` 后启动 AI |
| `启动AI玩家.bat` | 通用启动 AI |
| `检查局域网端口.bat` | 检查 55916 是否已开放 |
| `.env` | 你的 API 密钥（本地私有，勿分享） |
| `.env.example` | 密钥填写模板 |
| `mindcraft/settings.js` | 端口 55916、中文、游戏版本等 |
| `mindcraft/aimc-bot.json` | 机器人名字、用哪个大模型 |

---

## 十、说明与致谢

- 核心能力来自 [mindcraft-bots/mindcraft](https://github.com/mindcraft-bots/mindcraft)，本仓库是在其上的整合与汉化配置。
- 需要「对局域网开放」是因为 AI 以合法第二玩家身份连接本地世界，稳定且可扩展。
- 更详细的模型与 API 列表见 `mindcraft/README.md`。

若某一步与界面不一致，请以你当前的 Minecraft 中文/英文菜单为准，端口 **55916** 不变即可。
