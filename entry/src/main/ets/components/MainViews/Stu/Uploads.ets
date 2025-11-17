// 导入通用组件库：包含导航栏、顶部栏、类别组件等可复用UI元素
import {top, CategoryComponent} from './UploadsComponents/RecordList'
// 导入鸿蒙路由模块：用于页面跳转（当前组件暂未直接使用，预留扩展）
import router from '@ohos.router';
// 导入测试数据：用于开发阶段模拟审核记录数据（避免依赖真实后端）
import { TestData } from '../../../debug/TestData';
// 导入审核记录数据类型：约束数据格式，确保类型安全
import * as TypeRecord from '../../../datatypes/Record';
// 导入审核页数据服务：全局管理审核数据（存储、筛选），实现数据与UI解耦
import { UploadsData } from '../../../service/Stu/UploadsData';
import {FilterDialog} from './UploadsComponents/Filter'
import http from '@ohos.net.http';
import json from '@ohos.util.json';
import { DynamicData, StaticData } from '../../../constants';
import App from '@system.app';
import * as RecordTypes from '../../../datatypes/Record';
import { PromptAction } from '@ohos.arkui.UIContext';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

interface Application{
  Type:number
  Title:string
  ApplyScore:number
  RealScore:number
  ReviewStatus:number //0=未提交，1=审核中，2=审核通过，3=审核失败
  UploadTime:number
  ModifyTime:number
  Description:string
  Attachments:string[]
  FeedBack:string
  extra_data:string
}

interface data{
  ApplyList?: Application[]
}

interface empty{

}

// 审核页视图组件（页面级组件，对应"审核"导航项的内容）
@Component
export struct UploadsView {
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
  @State List:RecordTypes.RecordEntry[] = []

  update(){
    UploadsData.Filter()
    this.List = [...UploadsData.FilteredList]
  }

  async refresh(){
    let httpRequest = http.createHttp();
    try {
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + '/api/student/material/applications/list/',
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token '+DynamicData.token
          }
        }
      )

      let DataObj: data | empty
      let DataObjTmp: object | null
      try {
        DataObjTmp = json.parse(Response.result.toString())
        DataObj = DataObjTmp ? DataObjTmp : {}

        if (Response.responseCode == 200 && DataObj && (DataObj as data).ApplyList) {
          const applyList = (DataObj as data).ApplyList;
          UploadsData.UploadsList = []

          for (const item of applyList!) {
            // 创建RecordEntry对象
            const recordEntry = new RecordTypes.RecordEntry(
              item.Type,
              item.Title,
              item.ApplyScore,
              item.ReviewStatus,
              item.Description,
              item.UploadTime,
              item.ModifyTime
            );

            recordEntry.RealScore = item.RealScore;
            recordEntry.Attachments = item.Attachments || [];
            recordEntry.FeedBack = item.FeedBack || '';

            // 解析extra_data
            if (item.extra_data && item.extra_data !== '') {
              try {
                const extraDataObj:object = JSON.parse(item.extra_data);
                let typeInfo: RecordTypes.TypeInfo | undefined;

                // 根据Type字段创建对应的TypeInfo对象
                switch (item.Type) {
                  case 0: // 学业竞赛
                    typeInfo = new RecordTypes.Competition();
                    break;
                  case 1: // 创新创业训练
                    typeInfo = new RecordTypes.Innovation();
                    break;
                  case 2: // 科研成果
                    typeInfo = new RecordTypes.Research();
                    break;
                  case 3: // 荣誉称号
                    typeInfo = new RecordTypes.Honor();
                    break;
                  case 4: // 社会工作
                    typeInfo = new RecordTypes.SocialWork();
                    break;
                  case 5: // 志愿服务
                    typeInfo = new RecordTypes.Volunteer();
                    break;
                  case 6: // 国际组织学习
                    typeInfo = new RecordTypes.International();
                    break;
                  case 7: // 参军入伍
                    typeInfo = new RecordTypes.Military();
                    break;
                  case 8: // 体育比赛
                    typeInfo = new RecordTypes.Sports();
                    break;
                  default:
                    console.warn('Unknown record type:', item.Type);
                }

                if (typeInfo) {
                  // 调用fromJSON方法解析数据
                  typeInfo.fromJSON(item.extra_data);
                  recordEntry.extra_data = typeInfo;
                }
              } catch (parseError) {
                console.error('Error parsing extra_data:', parseError);
              }
            }

            UploadsData.UploadsList.push(recordEntry);
          }
          this.update()


        } else if (DataObj && Object.keys(DataObj).includes('detail')) {
          promptAction.showToast({
            message: '登录失效，请重新登录',
            duration: 2000
          });
          router.pushUrl({ url: 'pages/Login' })
        } else {
          promptAction.showToast({
            message: '刷新失败，请检查网络连接',
            duration: 2000
          });
        }
      } catch (e) {
        let error = e as BusinessError
        let msg = error?.message
        promptAction.showToast({
          message: '解析错误：' + msg,
          duration: 2000
        });
        return;
      }
    } catch (e) {
      let err: BusinessError = e as BusinessError
      console.log(err.message)
      console.log(err.name)
    }
  }

  /**
   * 组件生命周期方法：组件即将显示时调用（初始化阶段）
   * 核心逻辑：初始化审核数据，执行首次筛选
   * 执行时机：页面切换到审核页时（如点击底部导航栏"审核"项）
   */
  aboutToAppear(): void {
    this.refresh()
    // 1. 加载测试数据到全局数据服务：将TestData中的模拟审核记录赋值给UploadsData的UploadsList（原始数据池）
    //UploadsData.UploadsList = TestData.RecordList;
    // 2. 执行首次数据筛选：根据默认筛选条件（如无搜索关键词时显示全部）生成FilteredList（筛选后的数据）
    //UploadsData.Filter();
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
        onSearchTextUpdate: () => {
          UploadsData.Filter();
          this.UpdateTrigger = !this.UpdateTrigger;
        },
        onFilterClicked: () => {
          this.FilterDialogInstance.open()
        }
      })
        .width('100%') // 顶部栏宽度占满屏幕
        .height('15%') // 顶部栏高度占屏幕20%（固定比例，确保布局稳定）
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
          CategoryComponent({UpdateTrigger:this.UpdateTrigger});
        }
        //.width(343) // 列表内容宽度固定（与顶部栏搜索框对齐，视觉统一）
        .justifyContent(FlexAlign.Start); // 列表项靠上排列（避免内容为空时居中）
        // .height('100%'); // 【注释保留】旧的高度配置，当前依赖Scroll容器自动适配

      }
      .scrollable(ScrollDirection.Vertical) // 允许垂直滚动（关键配置，确保内容超出时可滚动）
      .align(Alignment.Top) // 滚动容器内的内容靠上对齐
      .width('100%') // 滚动容器宽度占满屏幕
      .height('75%') // 滚动容器高度占屏幕70%（与顶部栏20%+底部导航栏10%适配）
      .position({ // 绝对定位：固定在顶部栏下方
        y: '15%', // 垂直方向距离顶部20%（与顶部栏高度一致，避免重叠）
        x: 0 // 水平方向靠左
      });

    }
    .width('100%') // 根容器宽度占满屏幕
    .height('100%') // 根容器高度占满屏幕
    .alignItems(HorizontalAlign.Center) // 根容器内所有子组件水平居中（确保顶部栏、滚动列表对齐）
    .backgroundColor('#f4fafa'); // 审核页整体背景色（浅蓝灰色，与首页背景统一）
  }

}