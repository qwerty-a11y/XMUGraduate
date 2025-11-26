import {HistoryData} from '../../../../service/Tea/HistoryData'

// ====================== 5. 审核页顶部栏组件（top）======================
/**
 * 审核页顶部栏组件
 * 功能：集成筛选、搜索、设置入口，支持搜索输入同步与筛选触发
 * 设计：上下布局（筛选+设置行 + 搜索框），白色背景+阴影
 */
@Component
export struct top {
  // 筛选更新回调（可选）：点击筛选按钮时，触发父组件的筛选逻辑
  public onSearchTextUpdate?: () => void = undefined;
  public onFilterClicked?: () => void = undefined;
  // 顶部栏图标资源（@Prop修饰：可外部自定义，默认用内置资源）
   @Prop image_arrange: ResourceStr = $r("app.media.Sort"); // 排序图标
   @Prop image_search: ResourceStr = $r('app.media.Search'); // 搜索图标
   @Prop image_filter: ResourceStr = $r("app.media.Filter"); // 筛选图标
  // 搜索框输入文本（@State修饰：组件内部状态，变化时触发重渲染）
  @State SearchText: string = '';
  // 颜色配置（当前未使用，预留扩展用）
  private activeColor: string = '#ff77f0ec';
  private inactiveColor: string = '#FFFFFF';

   build() {
     RelativeContainer() {
       // ---------------- 5.1 筛选+设置按钮行 ----------------
       // ---------------- 5.2 搜索框 ----------------
       Row() {
         // 搜索图标：固定在搜索框左侧
         Image(this.image_search)
           .width(24)
           .height(24)
           .margin({ left: 12 }) // 与搜索框左侧保持间距
         //.objectFit(ImageFit.Contain);

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
           //.flexGrow(1) // 占满剩余宽度：适配搜索框
           // 输入变化事件：同步输入文本到全局数据服务（UploadsData）
           .onChange((value: string) => {
             HistoryData.SearchText = value;
           })
           // 提交事件（如按回车）：触发筛选逻辑
           .onSubmit(() => {
             this.onSearchTextUpdate && this.onSearchTextUpdate();
           })
           .layoutWeight(1)
           //.width('220.00vp');
       }
       //.justifyContent(FlexAlign.Center) // 搜索框内容垂直居中
       .backgroundColor('white') // 搜索框整体背景色（白色）
       .borderRadius(20) // 搜索框圆角：优化视觉
       .height(52) // 搜索框固定高度
       .width(300)
       .shadow({
         // 搜索框阴影：增强层次感
         radius: 4,
         color: '#10000000',
         offsetX: 0,
         offsetY: 2
       })
       .alignRules({
         left:{anchor:"__container__",align:HorizontalAlign.Start},
         center:{anchor:'__container__',align:VerticalAlign.Center}
       })
       .margin({ left:15,bottom: 10 }); // 与下方内容保持间距


       Image(this.image_filter)
         .width(24)
         .height(24)
         //.backgroundImagePosition(Alignment.End)
         .margin({ left:8,right: 15 }) // 与右侧设置按钮保持间距
         .alignRules({
           right:{anchor:"__container__",align:HorizontalAlign.End},
           center:{anchor:'__container__',align:VerticalAlign.Center}
         })
         .onClick(() => {
           this.onFilterClicked && this.onFilterClicked(); // 触发父组件筛选逻辑
         });
/*
       Image(this.image_arrange)
         .width(24)
         .height(24)
*/
     }
     //.width(343) // 固定宽度：与下方搜索框对齐
     //.height(52) // 固定高度
     .margin({ bottom: 15, top: 10 }) // 与上下内容保持间距
     .width('100%') // 顶部栏宽度占满屏幕
     .height('100%') // 顶部栏高度由父组件控制（通常为屏幕20%）
     .backgroundColor('#fff4fafa') // 顶部栏背景色（浅蓝灰）
     .shadow({ radius: 10, color: '#00000010' }) // 顶部栏阴影：区分页面区域
   }
 }
