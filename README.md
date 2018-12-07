# QMYK_App_Swift
全民养鲲_Swift

## 如图
* https://github.com/576410448/QMYK_App_Swift/blob/master/QMYK_IMG/1544066614078.jpg?raw=true
* https://github.com/576410448/QMYK_App_Swift/blob/master/QMYK_IMG/WX20181207-105520@2x.png?raw=true

## 视图：
* collectionview                       展示鱼池
* cell->imgv touch手势                  合成 出售 工作
* 指定坐标区域                           开始工作动画（拖至此处开始工作） / 出售区域等
* 贝塞尔曲线 coreAnimation               绘制路径 开始动画
* 每个处于动画中的控件添加定时器            记录经过区域 （经过赚钱 加速区域
* 父视图添加点击事件                      取记录数据判断是否调用加速（点击加速）
* 商城                                  可购等级鱼

## 数据：(数据不太准确)
* 初始价格  level^2*100        (没算出来   初始值非线性非单一函数)
* 购鱼增值                      1.07增值  没隔4个等级上调0.011                 1.07 + level * 0.011/4 
* 鱼工作赚钱增值                 25 * 2^(level-1)  2的等级-1次方 基数25

## 本地化：
* Codable 序列化模型本地储存   取本地数据反序列化获取上次记录

## 未实现：
* 离线数据记录  （1. 本地化方法：applicationWillTerminate记录秒数据 时间进行存储  下次启动后进行时间差计算  2.服务器记录状态 计算同理）
* 数据累计  （。。懒得写）
* 航道限制：（总共就12个数据 10个限制数据加入限制个数即可  ps：临时调增赚钱增幅可直接在数据累计进行 不修改数据模型）
* 商城记录

