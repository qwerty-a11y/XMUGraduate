 import * as TypeRecord from '../../../../datatypes/Record'
 import {DateUtils} from '../../../../utils'
 import {UploadsData} from '../../../../service/Stu/UploadsData'
 import router from '@ohos.router';

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
             UploadsData.SearchText = value;
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


 export class ForceRefresh {
  public refresh?:()=>void = undefined
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
  @State FilteredList:TypeRecord.RecordEntry[]=UploadsData.FilteredList
  @Link Controller:ForceRefresh
  /**
   * 组件构建方法：定义UI结构
   * 布局：垂直容器，内部循环渲染所有活动卡片
   */
  ForceUpdate(){
    this.FilteredList=[...UploadsData.FilteredList]
  }

  aboutToAppear(): void {
    this.Controller.refresh=this.ForceUpdate
  }

  build() {
    Column() {
      // 循环渲染卡片列表
      // ForEach：鸿蒙UI框架的循环渲染组件，遍历cards数组
      ForEach(this.FilteredList, (entry: TypeRecord.RecordEntry) => {
        // 为每个卡片数据创建一个活动卡片组件
        ActivityCardComponent({ entry: entry }).onClick(() => {
          router.pushUrl({ url: 'pages/Stu/Records' ,params:{data:entry,ref:this.Controller}});
        });
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
  @Prop entry: TypeRecord.RecordEntry;
  private status: string=''; // 审核状态（如"待审核"、"审核失败"）
  private activityName: string=''; // 活动名称（如"XX学业竞赛"）
  private uploadTime: string=''; // 提交时间（格式化后的字符串，如"2024-05-20"）
  private modifyTime: string=''; // 更改时间（格式化后的字符串）
  private score: string=''; // 加分情况（如"加5分"）
  private typeList:string[] = ['学业竞赛','创新创业训练','科研成果','荣誉称号','社会工作','志愿服务','国际组织学习','参军入伍','体育比赛']

  aboutToAppear(): void {
    switch (this.entry.ReviewStatus.valueOf()) {
      case 0:
        this.status = "待审核"; // 未开始审核
        break;
      case 1:
        this.status = "审核中"; // 正在审核过程中
        break;
      case 2:
        this.status = "审核成功"; // 审核通过
        break;
      case 3:
        this.status = "审核失败"; // 审核未通过
        break;
      default:
        this.status = "待审核"; // 异常状态兜底，避免展示空白
        break;
    }
    this.activityName=this.entry.Title
    this.uploadTime=DateUtils.ToString(this.entry.UploadTime)
    this.modifyTime=DateUtils.ToString(this.entry.ModifyTime)
    this.score='加'+((this.entry.RealScore != -1)?this.entry.RealScore.toString():this.entry.ApplyScore.toString())+'分'
  }
  /**
   * 组件构建方法：定义单条审核记录的UI布局
   * 设计：白色背景卡片，带阴影效果，信息分区域展示
   */
   @Prop image_accepted: ResourceStr = $r("app.media.RecordEntry_Accepted"); // 设置图标
   @Prop image_denied: ResourceStr = $r("app.media.RecordEntry_Denied"); // 设置图标
   @Prop image_reviewing: ResourceStr = $r("app.media.RecordEntry_Reviewing"); // 设置图标
   @Prop image_draft: ResourceStr = $r("app.media.RecordEntry_Draft"); // 设置图标
   @Prop image_uploadtime: ResourceStr = $r("app.media.RecordEntry_UploadTime"); // 设置图标
   @Prop image_modifytime: ResourceStr = $r("app.media.RecordEntry_ModifyTime"); // 设置图标
   build() {
     RelativeContainer() {
       Text(this.typeList[this.entry.Type.valueOf()])
         .fontSize(14)
         .margin({ left:15,top:15 })

       Column(){
       if (this.entry.ReviewStatus.valueOf() == 3) {
         Image(this.image_denied)
           .width(30)
           .height(30);
       } else if (this.entry.ReviewStatus.valueOf() == 2) {
         Image(this.image_accepted)
           .width(30)
           .height(30);
       } else if (this.entry.ReviewStatus.valueOf() == 1) {
         Image(this.image_reviewing)
           .width(30)
           .height(30);
       } else if (this.entry.ReviewStatus.valueOf() == 0) {
         Image(this.image_draft)
           .width(30)
           .height(30);
       }}
       .id('icon')
       .margin({left:10,bottom:20})
       .alignRules({
         left:{anchor:'__container__',align:HorizontalAlign.Start},
         bottom:{anchor:'__container__',align:VerticalAlign.Bottom}
       })


       Text(this.activityName)
         .fontSize(24)
         .fontWeight(FontWeight.Medium)
         .margin({ left: 5 })
         .width('50%')
         .height('75%')
         .flexGrow(1)
         .ellipsisMode(EllipsisMode.END)
         .maxLines(2)
         .textOverflow({overflow:TextOverflow.Ellipsis})
         .alignRules({
           left:{anchor:'icon',align:HorizontalAlign.End},
           center:{anchor:'icon',align:VerticalAlign.Center}
         })

       Column() {
         Text(this.score)
           .fontSize(18)
           .fontWeight(FontWeight.Medium)
           .fontColor((this.entry.ReviewStatus == 2) ? '#000000' : '#707070')
           .margin({ right:20,bottom:10})
           .flexGrow(1)
           .decoration({
             type: (this.entry.ReviewStatus == 3)
               ? TextDecorationType.LineThrough
               : TextDecorationType.None // 不包含 '失败' 时，无装饰
           })
         Row() {
           Image(this.image_uploadtime)
             .width(10)
             .height(10)
             .margin({ right: 3 })
           Text(this.modifyTime)
             .fontSize(12); // 时间文字使用较小字号
         }

         Row() {
           Image(this.image_modifytime)
             .width(10)
             .height(10)
             .margin({ right: 3 })
           Text(this.uploadTime)
             .fontSize(12); // 提交时间使用小字号
         }
       }.alignItems(HorizontalAlign.End)
       .id('time')
       .flexGrow(1)
       .margin({ right: 10 })
       .alignRules({
         right:{anchor:'__container__',align:HorizontalAlign.End},
         center:{anchor:'__container__',align:VerticalAlign.Center}
       })



     }
     .width('95%') // 卡片固定宽度
     .height(90)
     .borderRadius(20) // 圆角设计
     .backgroundColor('#FFFFFF') // 白色背景
     .shadow({
       // 卡片阴影，增强立体感
       radius: 4,
       color: '#D9D9D9', // 浅灰色阴影
       offsetX: 0,
       offsetY: 2 // 阴影向下偏移2px
     })
     .margin({ bottom: 10 });
   }
 }