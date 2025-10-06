// 导入通用组件库：包含导航栏、顶部栏、类别组件等可复用UI元素
import {top, CategoryComponent} from './UploadsComponents/RecordList'
// 导入鸿蒙路由模块：用于页面跳转（当前组件暂未直接使用，预留扩展）
import router from '@ohos.router';
// 导入测试数据：用于开发阶段模拟审核记录数据（避免依赖真实后端）
import { TestData } from '../../debug/TestData';
// 导入审核记录数据类型：约束数据格式，确保类型安全
import * as TypeRecord from '../../datatypes/Record';
// 导入审核页数据服务：全局管理审核数据（存储、筛选），实现数据与UI解耦
import { UploadsData } from '../../service/UploadsData';
import {FilterDialog} from './UploadsComponents/Filter'

// 审核页视图组件（页面级组件，对应"审核"导航项的内容）
@Component
export struct UploadsView {
  /*
  // 【废弃代码】旧的本地类别数据（开发过程中用于临时测试）
  // 作用：早期开发时直接在组件内定义静态数据，验证UI渲染效果
  // 现状：已替换为通过UploadsData服务获取数据，故注释保留
  @State categories: Category[] = [
    {
      name: '类别1',
      cards: [
        { status: '审核失败，请重新提交', activityName: '活动名称1', publishTime: '发布时间1', score: '加0分', submitTime: '提交时间1' },
        { status: '审核成功', activityName: '活动名称2', publishTime: '发布时间2', score: '加*分', submitTime: '提交时间2' },
        { status: '审核成功', activityName: '活动名称3', publishTime: '发布时间3', score: '加*分', submitTime: '提交时间3' },
      ],
    },
    {
      name: '类别2',
      cards: [
        { status: '审核失败，请重新提交', activityName: '活动名称4', publishTime: '发布时间4', score: '加0分', submitTime: '提交时间4' },
        { status: '审核成功', activityName: '活动名称5', publishTime: '发布时间5', score: '加*分', submitTime: '提交时间5' },
        { status: '审核成功', activityName: '活动名称6', publishTime: '发布时间6', score: '加*分', submitTime: '提交时间6' },
      ],
    },
  ];
  */

  /*
  // 【废弃代码】旧的本地审核记录列表（开发阶段临时使用）
  // 作用：早期直接绑定测试数据到组件状态，验证数据转换逻辑
  // 现状：已改为通过UploadsData服务管理数据，故注释保留
  @State RecordList: TypeRecord.RecordEntry[] = TestData.RecordList;
  */

  // 数据更新触发器（双向绑定）
  // @Link：与父组件（Main.ets）的UpdateTrigger状态同步，父组件可触发审核页更新
  // 核心作用：当筛选、搜索等操作触发数据变化时，通过反转布尔值（!this.UpdateTrigger）触发子组件（CategoryComponent）重新渲染
  FilterModifyHandler(NewFilter:TypeRecord.Filter){
    UploadsData.Filters=NewFilter
    // 1. 调用UploadsData服务的筛选方法：根据当前搜索关键词（UploadsData.SearchText）更新筛选后的列表（FilteredList）
    UploadsData.Filter();
    // 2. 触发数据更新：通过反转布尔值改变UpdateTrigger状态，进而触发子组件（CategoryComponent）重新渲染
    this.UpdateTrigger = !this.UpdateTrigger;
  }

  FilterDialogInstance:CustomDialogController=new CustomDialogController({
    builder: FilterDialog(
      {
        confirm: (NewFilter:TypeRecord.Filter) => {
          this.FilterModifyHandler(NewFilter)
          this.FilterDialogInstance.close()
        },
        cancel:() => {
          this.FilterDialogInstance.close()
        }
      }),
    alignment: DialogAlignment.Center,
    autoCancel: true
  })
  @Link UpdateTrigger: boolean;

  /**
   * 组件生命周期方法：组件即将显示时调用（初始化阶段）
   * 核心逻辑：初始化审核数据，执行首次筛选
   * 执行时机：页面切换到审核页时（如点击底部导航栏"审核"项）
   */
  aboutToAppear(): void {
    // 1. 加载测试数据到全局数据服务：将TestData中的模拟审核记录赋值给UploadsData的UploadsList（原始数据池）
    UploadsData.UploadsList = TestData.RecordList;
    // 2. 执行首次数据筛选：根据默认筛选条件（如无搜索关键词时显示全部）生成FilteredList（筛选后的数据）
    UploadsData.Filter();
  }

  /**
   * 组件构建方法：定义审核页的UI结构与布局
   * 整体布局：垂直容器（Column）包含两部分——顶部栏（top）、滚动列表（Scroll）
   */
  build() {
    // 根容器：垂直布局，占满整个屏幕
    Column() {
      // ---------------- 1. 审核页顶部栏（筛选+搜索+设置） ----------------
      top({
        // 筛选/搜索回调：点击筛选按钮或提交搜索时触发
        onFilterUpdate: () => {
          this.FilterDialogInstance.open()
        }
      })
        .width('100%') // 顶部栏宽度占满屏幕
        .height('20%') // 顶部栏高度占屏幕20%（固定比例，确保布局稳定）
        .backgroundColor('#FFFFFFFF') // 顶部栏背景色（白色）
        .position({ // 绝对定位：固定在屏幕顶部
          x: 0, // 水平方向靠左
          y: 0, // 垂直方向靠上
          top: 0 // 顶部贴合父容器顶部（冗余配置，增强兼容性）
        });

      // ---------------- 2. 审核记录滚动列表 ----------------
      Scroll() {
        // 列表容器：垂直布局，存放类别组件（CategoryComponent）
        Column() {
          /*
          // 【废弃代码】旧的循环渲染逻辑（基于本地categories数据）
          // 作用：早期遍历本地类别数据，渲染多个类别组件
          // 现状：已改为基于UploadsData服务的筛选后数据，故注释保留
          ForEach(this.RecordList, (record: Category) => {
            CategoryComponent({ UpdateTrigger: this.UpdateTrigger });
          });
          */

          // 渲染类别组件：传递UpdateTrigger状态，实现数据更新联动
          // 核心作用：展示筛选后的审核记录列表（通过CategoryComponent内部遍历UploadsData.FilteredList实现）
          CategoryComponent();
        }
        .width(343) // 列表内容宽度固定（与顶部栏搜索框对齐，视觉统一）
        .justifyContent(FlexAlign.Start); // 列表项靠上排列（避免内容为空时居中）
        // .height('100%'); // 【注释保留】旧的高度配置，当前依赖Scroll容器自动适配

      }
      .scrollable(ScrollDirection.Vertical) // 允许垂直滚动（关键配置，确保内容超出时可滚动）
      .align(Alignment.Top) // 滚动容器内的内容靠上对齐
      .width('100%') // 滚动容器宽度占满屏幕
      .height('70%') // 滚动容器高度占屏幕70%（与顶部栏20%+底部导航栏10%适配）
      .position({ // 绝对定位：固定在顶部栏下方
        y: '20%', // 垂直方向距离顶部20%（与顶部栏高度一致，避免重叠）
        x: 0 // 水平方向靠左
      });

    }
    .width('100%') // 根容器宽度占满屏幕
    .height('100%') // 根容器高度占满屏幕
    .alignItems(HorizontalAlign.Center) // 根容器内所有子组件水平居中（确保顶部栏、滚动列表对齐）
    .backgroundColor('#f4fafa'); // 审核页整体背景色（浅蓝灰色，与首页背景统一）
  }

}