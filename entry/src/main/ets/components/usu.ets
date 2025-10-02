// 导入鸿蒙路由模块：用于页面跳转（如顶部栏跳转到设置页）
import router from '@ohos.router';
// 导入记录数据类型定义：用于约束审核相关数据的格式
import * as TypeRecord from '../datatypes/Record'
// 导入日期工具类：用于时间戳与字符串的格式转换
import { DateUtils } from '../utils';
// 导入审核页数据服务：用于获取、筛选审核数据（全局状态管理）
import { UploadsData } from '../service/UploadsData'


// ====================== 1. 海报组件（Poster）======================
/**
 * 通用海报展示组件
 * 功能：负责展示海报图片，支持外部传入图片资源，适配父容器尺寸
 * 适用场景：首页顶部Banner、活动宣传图等
 */
@Component
export struct Poster {
  // 父组件传递的图片资源（@Prop修饰：单向数据流，父变子变）
  // 默认值为app.media.haibao（需在媒体资源目录中提前配置该资源）
  @Prop imageResource: ResourceStr = $r('app.media.haibao');

  build() {
    // 图片组件：展示海报资源
    Image(this.imageResource)
      .width('100%') // 宽度占满父容器
      .height('100%') // 高度占满父容器
      .objectFit(ImageFit.Contain); // 适配策略：完整显示图片（不拉伸、不裁剪）
  }
}


// ====================== 2. 底部导航栏组件（NavigationBar）======================
/**
 * 底部导航栏组件
 * 功能：实现「首页」与「审核页」的切换，支持导航项高亮（激活状态区分）
 * 设计：左右分栏布局，图标+文字组合，激活项用主题色背景
 */
@Component
export struct NavigationBar {
  // 页面切换回调函数（可选）：父组件传递，点击导航项时触发页面切换逻辑
  public onPageSwitch?: (type: number) => void = undefined;
  // 当前激活的页面索引（@Link修饰：双向数据流，父子同步）
  // 0 = 首页，1 = 审核页，用于控制导航项的高亮状态
  @Link currentPage: number;
  // 导航图标资源（@Prop修饰：可外部自定义，默认用内置资源）
  @Prop homeIcon: ResourceStr = $r('app.media.table1'); // 首页图标
  @Prop reviewIcon: ResourceStr = $r('app.media.table2'); // 审核页图标
  // 导航项颜色配置：区分激活/未激活状态
  private activeColor: string = '#ffaafafb'; // 激活状态背景色（浅蓝主题色）
  private inactiveColor: string = '#FFFFFF'; // 未激活状态背景色（白色）

  build() {
    // 水平布局容器：包裹两个导航项（占满屏幕宽度）
    Row() {
      // ---------------- 2.1 首页导航项 ----------------
      Column() {
        // 图标容器：椭圆形背景，点击触发切换
        Column() {
          Image(this.homeIcon) // 首页图标
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain); // 图标适配：完整显示
        }
        .width(100) // 图标容器宽度
        .height(50) // 图标容器高度
        .borderRadius(20) // 圆角：使容器呈椭圆形
        .justifyContent(FlexAlign.Center) // 图标垂直居中
        .alignItems(HorizontalAlign.Center) // 图标水平居中
        // 背景色逻辑：当前页面是首页则用激活色，否则用白色
        .backgroundColor(this.currentPage === 0 ? this.activeColor : this.inactiveColor)
        // 点击事件：触发父组件的页面切换回调（传递首页索引0）
        .onClick(() => {
          this.onPageSwitch && this.onPageSwitch(0); // 避免回调未定义时报错
        });

        // 导航文字：首页（当前文字色为透明，预留扩展用）
        Text('首页')
          .fontSize(14)
          .height(22)
          .margin({ top: 5 }) // 与图标保持间距
          .fontColor('#00000000'); // 文字透明（临时配置，可根据需求修改）
      }
      .width('50%') // 占导航栏宽度的50%
      .alignItems(HorizontalAlign.Center); // 导航项整体水平居中

      // ---------------- 2.2 审核页导航项 ----------------
      Column() {
        // 图标容器：结构与首页一致，仅图标和索引不同
        Column() {
          Image(this.reviewIcon) // 审核页图标
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain);
        }
        .width(100)
        .height(50)
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        // 背景色逻辑：当前页面是审核页则用激活色
        .backgroundColor(this.currentPage === 1 ? this.activeColor : this.inactiveColor)
        // 点击事件：触发父组件回调（传递审核页索引1）
        .onClick(() => {
          this.onPageSwitch && this.onPageSwitch(1);
        });

        // 导航文字：审核（同首页，文字透明预留）
        Text('审核')
          .fontSize(14)
          .height(22)
          .margin({ top: 5 })
          .fontColor('#00000000');
      }
      .width('50%')
      .alignItems(HorizontalAlign.Center);
    }
    .width('100%') // 导航栏宽度占满屏幕
    .height('100%') // 导航栏高度由父组件控制（通常为屏幕10%）
    .backgroundColor('#FFFFFF') // 导航栏整体背景色（白色）
    .shadow({ radius: 10, color: '#00000010' }) // 顶部阴影：增强层次感（避免与页面内容粘连）
    .padding({ top: 10 }); // 顶部内边距：避免图标贴顶
  }
}


// ====================== 3. 功能卡片数据结构（CardItem）======================
/**
 * 功能卡片数据源接口
 * 作用：约束「FeatureCard组件」的输入数据格式，确保数据结构统一
 * 适用场景：首页学业类、综合表现类卡片
 */
export interface CardItem {
  icon: ResourceStr; // 卡片图标资源（如"学业竞赛"图标）
  title: string; // 卡片标题（如"学业竞赛"、"志愿服务"）
  score: number; // 卡片当前分数（初始为0，后续可动态更新）
  addIcon: ResourceStr; // 加分按钮图标（如"+"号图标）
}


// ====================== 4. 功能卡片组件（FeatureCard）======================
/**
 * 功能卡片组件
 * 功能：展示具体功能模块（如学业竞赛、志愿服务），包含图标、标题、分数、加分入口
 * 设计：固定尺寸、白色背景、圆角阴影，适合网格布局展示
 */
@Component
export struct FeatureCard {
  // 父组件传递的卡片数据（@Prop修饰：单向接收CardItem格式数据）
  @Prop item: CardItem;

  build() {
    // 垂直布局容器：卡片主体（固定宽高）
    Column() {
      // ---------------- 4.1 卡片图标 ----------------
      Image(this.item.icon)
        .width(100)
        .height(100)
        .borderRadius(30) // 圆角：使图标呈圆形
        .margin({ top: 10, bottom: 10 }) // 与上下内容保持间距
        .objectFit(ImageFit.Contain); // 图标适配：完整显示

      // ---------------- 4.2 卡片标题 ----------------
      Text(this.item.title)
        .fontSize(16)
        .width(120) // 固定宽度：避免标题过长换行
        .margin({ top: 5, bottom: 15 })
        .textAlign(TextAlign.Start); // 文字左对齐（符合阅读习惯）

      // ---------------- 4.3 分数与加分按钮 ----------------
      Row() {
        // 分数显示（如"0分"）
        Text(`${this.item.score}分`)
          .fontSize(16)
          .flexGrow(1); // 占满剩余宽度：使加分按钮靠右对齐

        // 加分按钮图标（如"+"号）
        Image(this.item.addIcon)
          .width(32)
          .height(32)
          .objectFit(ImageFit.Contain);
      }
      .width(120)
      .margin({ top: 5 })
      .justifyContent(FlexAlign.SpaceBetween); // 两端对齐：分数左、按钮右
    }
    .width(150) // 卡片固定宽度
    .height(224) // 卡片固定高度
    .backgroundColor('#FFFFFF') // 卡片背景色（白色）
    .borderRadius(10) // 卡片整体圆角
    .padding(10) // 内边距：避免内容贴边
    .shadow({ radius: 5, color: '#00000014' }) // 卡片阴影：增强立体感
    .margin({ right: 10 }) // 右侧外边距：卡片之间留间隙（适合横向滚动布局）
    .alignItems(HorizontalAlign.Center); // 卡片内所有内容水平居中
  }
}


// ====================== 5. 审核页顶部栏组件（top）======================
/**
 * 审核页顶部栏组件
 * 功能：集成筛选、搜索、设置入口，支持搜索输入同步与筛选触发
 * 设计：上下布局（筛选+设置行 + 搜索框），白色背景+阴影
 */
@Component
export struct top {
  // 筛选更新回调（可选）：点击筛选按钮时，触发父组件的筛选逻辑
  public onFilterUpdate?: () => void = undefined;
  // 顶部栏图标资源（@Prop修饰：可外部自定义，默认用内置资源）
  @Prop image_setting: ResourceStr = $r('app.media.set'); // 设置图标
  @Prop image_search: ResourceStr = $r('app.media.Search'); // 搜索图标
  @Prop image_filter: ResourceStr = $r('app.media.filter'); // 筛选图标
  // 搜索框输入文本（@State修饰：组件内部状态，变化时触发重渲染）
  @State SearchText: string = '';
  // 颜色配置（当前未使用，预留扩展用）
  private activeColor: string = '#ff77f0ec';
  private inactiveColor: string = '#FFFFFF';

  build() {
    Column() {
      // ---------------- 5.1 筛选+设置按钮行 ----------------
      Row() {
        // 筛选按钮：点击触发筛选回调
        Image(this.image_filter)
          .width(24)
          .height(24)
          .backgroundImagePosition(Alignment.End)
          .margin({ right: 8 }) // 与右侧设置按钮保持间距
          .onClick(() => {
            this.onFilterUpdate && this.onFilterUpdate(); // 触发父组件筛选逻辑
          });

        // 空白列：占满中间空间，使设置按钮靠右
        Column()
          .flexGrow(1);

        // 设置按钮：点击跳转到设置页
        Image(this.image_setting)
          .width(24)
          .height(24)
          .backgroundImagePosition(Alignment.End)
          .margin({ right: 8 })
          .onClick(() => {
            // 路由跳转：跳转到"pages/setting"页面（需在config.json中配置该页面路径）
            router.pushUrl({ url: 'pages/setting' });
          });
      }
      .width(343) // 固定宽度：与下方搜索框对齐
      .height(52) // 固定高度
      .margin({ bottom: 15, top: 10 }); // 与上下内容保持间距

      // ---------------- 5.2 搜索框 ----------------
      Row() {
        // 搜索图标：固定在搜索框左侧
        Image(this.image_search)
          .width(24)
          .height(24)
          .margin({ left: 12 }) // 与搜索框左侧保持间距
          .objectFit(ImageFit.Contain);

        // 搜索输入框：支持文本输入、提交触发筛选
        TextInput({
          placeholder: 'Search', // 占位提示文本
          text: this.SearchText // 绑定内部状态：输入同步更新
        })
          .fontSize(16)
          .height(32)
          .backgroundColor('white') // 输入框背景色（白色）
          .placeholderColor('#999999') // 占位文本颜色（灰色）
          .margin({ left: 8 }) // 与搜索图标保持间距
          .flexGrow(1) // 占满剩余宽度：适配搜索框
          // 输入变化事件：同步输入文本到全局数据服务（UploadsData）
          .onChange((value: string) => {
            UploadsData.SearchText = value;
          })
          // 提交事件（如按回车）：触发筛选逻辑
          .onSubmit(() => {
            this.onFilterUpdate && this.onFilterUpdate();
          });
      }
      .justifyContent(FlexAlign.Center) // 搜索框内容垂直居中
      .backgroundColor('white') // 搜索框整体背景色（白色）
      .borderRadius(20) // 搜索框圆角：优化视觉
      .height(52) // 搜索框固定高度
      .width(343) // 搜索框固定宽度（与上方按钮行对齐）
      .shadow({
        // 搜索框阴影：增强层次感
        radius: 4,
        color: '#00000010',
        offsetX: 0,
        offsetY: 2
      })
      .margin({ bottom: 10 }); // 与下方内容保持间距
    }
    .width('100%') // 顶部栏宽度占满屏幕
    .height('100%') // 顶部栏高度由父组件控制（通常为屏幕20%）
    .backgroundColor('#fff4fafa') // 顶部栏背景色（浅蓝灰）
    .shadow({ radius: 10, color: '#00000010' }); // 顶部栏阴影：区分页面区域
  }
}


// ====================== 6. 审核页活动卡片数据结构（ActivityCard）======================
/**
 * 审核页活动卡片数据源接口
 * 作用：约束「ActivityCardComponent组件」的输入数据格式
 * 存储内容：单条审核记录的核心信息（状态、名称、时间、分数）
 */
export interface ActivityCard {
  status: string; // 审核状态（如"待审核"、"审核失败"）
  activityName: string; // 活动名称（如"XX学业竞赛"）
  publishTime: string; // 发布时间（格式化后的字符串，如"2024-05-20"）
  score: string; // 加分情况（如"加5分"）
  submitTime: string; // 提交时间（格式化后的字符串）
}


// ====================== 7. 审核页类别数据结构（Category）======================
/**
 * 审核页类别数据源接口
 * 作用：约束「CategoryComponent组件」的输入数据格式
 * 设计：按类别分组管理审核记录（如"学业类"、"综合类"）
 */
export interface Category {
  name: string; // 类别名称（如"学业竞赛"、"志愿服务"）
  cards: TypeRecord.RecordEntry[]; // 该类别下的审核记录数组（原始数据格式）
}


// ====================== 8. 审核页类别组件（CategoryComponent）======================
/**
 * 审核页类别组件
 * 功能：按类别统一管理并渲染审核记录列表
 * 核心特性：
 * - 监听数据更新触发器，自动数据变化时自动刷新列表
 * - 将原始始数据转换为UI展示所需的卡片格式
 * - 批量渲染活动卡片组件
 */
@Component
export struct CategoryComponent {
  // 数据更新触发器（双向绑定）
  // @Link：与父组件状态同步，父组件修改时子组件自动响应
  // @Watch('Update')：当UpdateTrigger值变化时，自动执行Update()方法刷新数据
  @Watch('Update')
  @Link UpdateTrigger: boolean;

  // 存储转换后的活动卡片数据（内部状态）
  // @State：状态变化时自动触发组件重新渲染，更新UI
  @State cards: ActivityCard[] = [];

  /**
   * 数据转换方法：原始记录 → 卡片数据
   * 作用：将后端返回的原始数据（RecordEntry）转换为UI组件所需的ActivityCard格式
   * @param data 原始审核记录（包含状态码、时间戳等原始信息）
   * @returns 格式化后的活动卡片数据（可直接用于ActivityCardComponent渲染）
   */
  Convert(data: TypeRecord.RecordEntry): ActivityCard {
    let status: string; // 存储转换后的审核状态文字

    // 1. 时间格式化：将时间戳转换为可读性强的字符串
    // 使用DateUtils工具类处理，确保时间格式统一（如"2024-05-01 12:00"）
    let submitTime: string = DateUtils.ToString(data.UploadTime); // 提交时间（用户上传记录的时间）
    let publishTime: string = DateUtils.ToString(data.ModifyTime); // 发布/更新时间（记录最后修改时间）

    // 2. 分数格式化：将数字分数转换为"加X分"的文本格式
    let score: string = '加' + data.Score.toString() + '分';

    // 3. 审核状态转换：将数字状态码转换为文字描述
    // 状态码规则：0=待审核，1=审核中，2=审核成功，3=审核失败
    switch (data.ReviewStatus) {
      case 0:
        status = "待审核"; // 未开始审核
        break;
      case 1:
        status = "审核中"; // 正在审核过程中
        break;
      case 2:
        status = "审核成功"; // 审核通过
        break;
      case 3:
        status = "审核失败"; // 审核未通过
        break;
      default:
        status = "待审核"; // 异常状态兜底，避免展示空白
        break;
    }

    // 4. 组装ActivityCard对象并返回
    let card: ActivityCard = {
      status: status,          // 转换后的审核状态
      activityName: data.Title, // 活动名称（直接取自原始数据的标题）
      publishTime: publishTime, // 格式化后的发布时间
      score: score,            // 格式化后的加分文本
      submitTime: submitTime   // 格式化后的提交时间
    };
    return card;
  }

  /**
   * 数据更新方法：刷新卡片列表
   * 触发时机：
   * - 组件初始化时（aboutToAppear）
   * - UpdateTrigger状态变化时（@Watch监听）
   * 逻辑：清空旧数据 → 遍历筛选后的原始记录 → 转换为卡片数据 → 存入cards数组
   */
  public Update() {
    this.cards = []; // 清空现有卡片数据，避免新旧数据混合
    // 遍历全局数据服务中筛选后的记录列表
    UploadsData.FilteredList.forEach(entry => {
      // 转换单条原始记录为卡片数据，并添加到数组
      this.cards.push(this.Convert(entry));
    });
  }

  /**
   * 组件生命周期方法：组件即将显示时调用
   * 作用：初始化加载数据，确保组件首次渲染时有数据可展示
   */
  aboutToAppear(): void {
    this.Update(); // 调用更新方法加载初始数据
  }

  /**
   * 组件构建方法：定义UI结构
   * 布局：垂直容器，内部循环渲染所有活动卡片
   */
  build() {
    Column() {
      // 循环渲染卡片列表
      // ForEach：鸿蒙UI框架的循环渲染组件，遍历cards数组
      ForEach(this.cards, (card: ActivityCard) => {
        // 为每个卡片数据创建一个活动卡片组件
        ActivityCardComponent({ card: card });
      });
    }
    .width('100%') // 宽度占满父容器
    .padding({ left: 10, right: 10 }); // 左右内边距，避免卡片贴边
  }
}

// ====================== 9. 活动卡片组件（ActivityCardComponent）======================
/**
 * 活动卡片组件
 * 功能：展示单条审核记录的详细信息
 * 包含：审核状态、活动名称、发布时间、加分情况、提交时间
 */
@Component
export struct ActivityCardComponent {
  // 接收父组件传递的卡片数据（单向绑定）
  // @Prop：父组件数据变化时，子组件自动更新
  @Prop card: ActivityCard;

  /**
   * 组件构建方法：定义单条审核记录的UI布局
   * 设计：白色背景卡片，带阴影效果，信息分区域展示
   */
  build() {
    Column() {
      // 第一行：审核状态 + 发布时间
      Row() {
        Text(this.card.status)
          .fontSize(14)
          // 审核失败时文字标红，其他状态默认黑色
          .fontColor(this.card.status.includes('失败') ? '#FF0000' : '#000000')
          .flexGrow(1); // 占满左侧空间，使发布时间靠右

        Text(this.card.publishTime)
          .fontSize(12); // 时间文字使用较小字号
      }
      .width(330) // 内容宽度（小于卡片宽度，预留边距）
      .margin({ bottom: 5, top: 10 }); // 与上下内容保持间距

      // 第二行：活动名称 + 分数与提交时间组合
      Row() {
        Text(this.card.activityName)
          .fontSize(20)
          .fontWeight(FontWeight.Medium) // 活动名称加粗突出显示
          .flexGrow(1); // 占满左侧空间

        // 右侧垂直布局：分数 + 提交时间
        Column() {
          Text(this.card.score)
            .fontSize(20); // 分数使用大字号突出显示
          Text(this.card.submitTime)
            .fontSize(12); // 提交时间使用小字号
        }
      }
      .width(330)
      .margin({ bottom: 10 }); // 与底部保持间距
    }
    .width(343) // 卡片固定宽度
    .backgroundColor('#FFFFFF') // 白色背景
    .borderRadius(8) // 圆角设计
    .shadow({ // 卡片阴影，增强立体感
      radius: 4,
      color: '#00000010', // 浅灰色阴影
      offsetX: 0,
      offsetY: 2 // 阴影向下偏移2px
    })
    .margin({ bottom: 10 }); // 卡片之间的垂直间距
  }
}