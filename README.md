# qq_speed_box

**⚠️ 本项目当前处于早期开发阶段, 待功能完善后再公布细节**

## 简介
- 这是一个 **QQ飞车(端游)** 赛王记录的爬虫 APP, 基于 `flutter` 开发, 主要用于数据(视频)展示, 您可以更加方便地查看所有的赛王记录
- 所有数据都来自下方数据源中的 5 个帖子
- 基于 [GPL 3.0](https://github.com/SublimeCT/qq_speed_box/blob/master/LICENSE) 开源协议, 仅用于学习和交流, 禁止直接用于商业用途

## 界面

页面 | 路由 | 说明 | 进度 | 截图
--- |--- |--- |--- |---
视频中心 | `/videos` | 展示官方论坛视频区最新数据 | *待开发* | <img src="/docs/images/screen_database_fold.jpeg" alt="折叠"> <img src="/docs/images/screen_database_unfold.jpeg" alt="展开">
赛王数据 | `/database` | 展示所有审核通过的赛王记录 | *开发中* |
关于 | `/about` | app 信息 | *待开发* |

## 参考

- 数据源
  - [【赛道之王】记录你的王者风范(爵士赛车＆改装b车)](https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663147&extra=page%3D1)
  - [【飞驰之王】烙印你的飞驰英姿(A车＆B车＆S宝石版）](https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1682060&extra=page%3D1)
  - [【极限之王】展现你的速度极限(S车原装＆S车改装)](https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663287&extra=page%3D1)
  - [【极速之王】挑战你的生命极限(A级赛车原装＆改装)](https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1662762&extra=page%3D1)
  - [【抓地之王】秀出你的领跑风采（爵士赛车&原装S车)](https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663042&extra=page%3D1)
  - [QQ飞车官方论坛视频区](https://speed.gamebbs.qq.com/forum.php?mod=forumdisplay&fid=30673)
  - [官网系列/地图列表](http://speed.qq.com/web201008/page/race.shtml)
- 编码
  - [Provider / Consumer 的使用](https://blog.csdn.net/u013894711/article/details/102782366)
  - [List 常用 API 总结](https://blog.csdn.net/ffa_ijj/article/details/85051156)
  - [dartpad](https://dartpad.cn/)
  - [使用 PageView 实现 keep alive](https://zhuanlan.zhihu.com/p/58582876)
  - [腾讯视频 cKey 9.1 分析](https://zsaim.github.io/2019/05/06/Tencent-cKey9.1-Analysis/)
  - [视频广告自动跳过脚本](https://greasyfork.org/zh-CN/scripts/394637-%E8%A7%86%E9%A2%91%E5%B9%BF%E5%91%8A%E8%87%AA%E5%8A%A8%E8%B7%B3%E8%BF%87/feedback)