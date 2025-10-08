
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








