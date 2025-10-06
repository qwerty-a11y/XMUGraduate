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
    .shadow({offsetX:5, offsetY:5, radius: 10, color: '#40000000' }) // 卡片阴影：增强立体感
    .margin({ right: 10 }) // 右侧外边距：卡片之间留间隙（适合横向滚动布局）
    .alignItems(HorizontalAlign.Center); // 卡片内所有内容水平居中
  }
}